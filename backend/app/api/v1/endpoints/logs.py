"""
Meal logging API endpoints.
"""
from datetime import date, datetime
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user
from app.schemas.log import MealLogCreate, MealLogResponse, DailyMealsResponse, DailyMealWithLog
from app.schemas.meal_plan import PlannedMealResponse
from app.crud.log import log as log_crud
from app.crud.meal_plan import meal_plan as meal_plan_crud, planned_meal as planned_meal_crud
from app.models.user import User
from app.models.meal_plan import PlannedMeal
from app.models.log import MealLog

router = APIRouter()


@router.get("/logs/today", response_model=DailyMealsResponse)
def get_today_meals(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get today's meals from active plan with log status."""
    today = date.today()
    return get_meals_for_date(current_user, db, today)


@router.get("/logs/date/{target_date}", response_model=DailyMealsResponse)
def get_date_meals(
    target_date: date,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get meals for a specific date with log status."""
    return get_meals_for_date(current_user, db, target_date)


def get_meals_for_date(current_user: User, db: Session, target_date: date) -> DailyMealsResponse:
    """Helper function to get meals for a specific date."""
    # Get active meal plan
    active_plan = meal_plan_crud.get_active_plan(db, user_id=current_user.id)
    if not active_plan:
        return DailyMealsResponse(date=target_date, meals=[])

    # Calculate day index
    days_diff = (target_date - active_plan.start_date).days
    if days_diff < 0 or days_diff >= active_plan.duration_days:
        # Date is outside the plan range
        return DailyMealsResponse(date=target_date, meals=[])

    # Get planned meals for this day
    planned_meals = (
        db.query(PlannedMeal)
        .filter(
            PlannedMeal.meal_plan_id == active_plan.id,
            PlannedMeal.day_index == days_diff,
        )
        .order_by(PlannedMeal.meal_type, PlannedMeal.meal_index)
        .all()
    )

    # Get logs for this date
    logs = log_crud.get_logs_for_date(db, user_id=current_user.id, log_date=target_date)
    logs_by_meal = {log.planned_meal_id: log for log in logs}

    # Build response
    meals_with_logs = []
    for meal in planned_meals:
        log = logs_by_meal.get(meal.id)
        meals_with_logs.append(
            DailyMealWithLog(
                planned_meal=PlannedMealResponse.model_validate(meal),
                log=MealLogResponse.model_validate(log) if log else None,
            )
        )

    return DailyMealsResponse(date=target_date, meals=meals_with_logs)


@router.post("/logs", response_model=MealLogResponse, status_code=status.HTTP_201_CREATED)
def create_log(
    log_in: MealLogCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Log a meal as eaten or skipped."""
    # Verify the meal exists and belongs to user's plan
    meal = planned_meal_crud.get_meal(db, meal_id=log_in.planned_meal_id)
    if not meal:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Planned meal not found",
        )

    # Verify ownership through meal plan
    plan = meal_plan_crud.get(db, id=meal.meal_plan_id)
    if not plan or plan.user_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to log this meal",
        )

    # Create or update log
    log = log_crud.create_log(
        db,
        user_id=current_user.id,
        planned_meal_id=log_in.planned_meal_id,
        status=log_in.status,
        log_date=date.today(),
    )

    return log


@router.get("/logs/range", response_model=List[MealLogResponse])
def get_logs_range(
    start_date: date,
    end_date: date,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get logs for a date range."""
    if (end_date - start_date).days > 90:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Date range cannot exceed 90 days",
        )

    logs = log_crud.get_logs_in_range(
        db,
        user_id=current_user.id,
        start_date=start_date,
        end_date=end_date,
    )

    return logs
