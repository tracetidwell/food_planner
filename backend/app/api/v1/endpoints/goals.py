"""
Nutrition goals API endpoints.
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user
from app.schemas.goal import (
    NutritionGoalCreate,
    NutritionGoalResponse,
    TDEECalculateRequest,
    TDEECalculateResponse,
)
from app.crud.goal import goal as goal_crud
from app.services.tdee_service import tdee_service
from app.models.user import User

router = APIRouter()


@router.get("/goals", response_model=NutritionGoalResponse)
def get_active_goal(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get user's active nutrition goal."""
    goal = goal_crud.get_active_goal(db, user_id=current_user.id)
    if not goal:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No active goal found",
        )
    return goal


@router.post("/goals", response_model=NutritionGoalResponse, status_code=status.HTTP_201_CREATED)
def create_goal(
    goal_in: NutritionGoalCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Create or update nutrition goal (deactivates previous goals)."""
    goal = goal_crud.create_new_goal(db, user_id=current_user.id, obj_in=goal_in)
    return goal


@router.post("/goals/calculate-tdee", response_model=TDEECalculateResponse)
def calculate_tdee(request: TDEECalculateRequest):
    """Calculate TDEE and recommended calories."""
    result = tdee_service.calculate_full(
        age=request.age,
        weight_kg=request.weight_kg,
        height_cm=request.height_cm,
        gender=request.gender,
        activity_level=request.activity_level,
        goal=request.goal,
    )
    return result
