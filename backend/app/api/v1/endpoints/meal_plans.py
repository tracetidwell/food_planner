"""
Meal plans API endpoints.
"""
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user, check_api_rate_limit
from app.schemas.meal_plan import (
    MealPlanGenerateRequest,
    MealPlanResponse,
    MealPlanListItem,
    RegenerateMealRequest,
    PlannedMealResponse,
    GroceryListResponse,
)
from app.crud.meal_plan import meal_plan as meal_plan_crud
from app.crud.user import user as user_crud
from app.services.meal_plan_service import meal_plan_service
from app.services.grocery_service import grocery_service
from app.models.user import User, UserProfile
from app.models.grocery import GroceryList
from app.core.constants import PlanStatus
from app.core.security import decrypt_api_key

router = APIRouter()


@router.post("/meal-plans/generate", response_model=MealPlanResponse, status_code=status.HTTP_201_CREATED)
def generate_meal_plan(
    request: MealPlanGenerateRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    _rate_limit: None = Depends(check_api_rate_limit),
):
    """Generate a new meal plan."""
    # Get user's API key if they have one
    profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()
    custom_api_key = None
    if profile and profile.openai_api_key_encrypted:
        custom_api_key = decrypt_api_key(profile.openai_api_key_encrypted)

    try:
        # Generate meal plan
        meal_plan = meal_plan_service.generate_meal_plan(
            db,
            user_id=current_user.id,
            start_date=request.start_date,
            duration_days=request.duration_days,
            custom_api_key=custom_api_key,
        )

        # Update API usage count if using default key
        if not custom_api_key:
            user_crud.update_api_usage(db, user_id=current_user.id)

        # Refresh to get planned meals
        db.refresh(meal_plan)

        return meal_plan

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to generate meal plan: {str(e)}",
        )


@router.get("/meal-plans", response_model=List[MealPlanListItem])
def list_meal_plans(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    skip: int = 0,
    limit: int = 100,
):
    """List user's meal plans."""
    plans = meal_plan_crud.get_user_plans(
        db, user_id=current_user.id, skip=skip, limit=limit
    )

    # Convert to list items with meal count
    result = []
    for plan in plans:
        result.append(
            MealPlanListItem(
                id=plan.id,
                start_date=plan.start_date,
                duration_days=plan.duration_days,
                status=plan.status,
                generated_at=plan.generated_at,
                accepted_at=plan.accepted_at,
                total_meals=len(plan.planned_meals),
            )
        )

    return result


@router.get("/meal-plans/{plan_id}", response_model=MealPlanResponse)
def get_meal_plan(
    plan_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get a specific meal plan with all meals."""
    plan = meal_plan_crud.get_plan_with_meals(db, plan_id=plan_id)
    if not plan:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Meal plan not found",
        )

    # Check ownership
    if plan.user_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to access this meal plan",
        )

    return plan


@router.post("/meal-plans/{plan_id}/accept", status_code=status.HTTP_204_NO_CONTENT)
def accept_meal_plan(
    plan_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Accept a meal plan and generate grocery list."""
    plan = meal_plan_crud.get_plan_with_meals(db, plan_id=plan_id)
    if not plan:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Meal plan not found",
        )

    # Check ownership
    if plan.user_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to modify this meal plan",
        )

    # Update status to accepted
    meal_plan_crud.update_status(db, plan_id=plan_id, status=PlanStatus.ACCEPTED)

    # Generate grocery list
    grocery_service.generate_grocery_list(db, meal_plan=plan)

    return


@router.post("/meal-plans/{plan_id}/regenerate-meal", response_model=PlannedMealResponse)
def regenerate_meal(
    plan_id: str,
    request: RegenerateMealRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    _rate_limit: None = Depends(check_api_rate_limit),
):
    """Regenerate a specific meal in the plan."""
    plan = meal_plan_crud.get(db, id=plan_id)
    if not plan:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Meal plan not found",
        )

    # Check ownership
    if plan.user_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to modify this meal plan",
        )

    # Get user's API key if they have one
    profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()
    custom_api_key = None
    if profile and profile.openai_api_key_encrypted:
        custom_api_key = decrypt_api_key(profile.openai_api_key_encrypted)

    try:
        # Regenerate the meal
        meal = meal_plan_service.regenerate_meal(
            db,
            meal_id=request.planned_meal_id,
            user_id=current_user.id,
            custom_api_key=custom_api_key,
        )

        # Update API usage count if using default key
        if not custom_api_key:
            user_crud.update_api_usage(db, user_id=current_user.id)

        return meal

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to regenerate meal: {str(e)}",
        )


@router.delete("/meal-plans/{plan_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_meal_plan(
    plan_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Delete a meal plan."""
    plan = meal_plan_crud.get(db, id=plan_id)
    if not plan:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Meal plan not found",
        )

    # Check ownership
    if plan.user_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this meal plan",
        )

    meal_plan_crud.delete(db, id=plan_id)
    return


@router.get("/meal-plans/{plan_id}/grocery-list", response_model=GroceryListResponse)
def get_grocery_list(
    plan_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get grocery list for a meal plan."""
    plan = meal_plan_crud.get(db, id=plan_id)
    if not plan:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Meal plan not found",
        )

    # Check ownership
    if plan.user_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to access this grocery list",
        )

    # Get grocery list
    grocery_list = db.query(GroceryList).filter(GroceryList.meal_plan_id == plan_id).first()
    if not grocery_list:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Grocery list not found. Accept the meal plan first.",
        )

    return grocery_list
