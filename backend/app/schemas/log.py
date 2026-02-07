"""
Meal logging Pydantic schemas.
"""
from datetime import datetime, date
from typing import List, Optional
from pydantic import BaseModel

from app.core.constants import LogStatus
from app.schemas.meal_plan import PlannedMealResponse


class MealLogCreate(BaseModel):
    """Schema for creating a meal log."""

    planned_meal_id: str
    status: LogStatus


class MealLogResponse(BaseModel):
    """Schema for meal log response."""

    id: str
    user_id: str
    planned_meal_id: str
    log_date: date
    status: LogStatus
    logged_at: datetime

    class Config:
        from_attributes = True


class DailyMealWithLog(BaseModel):
    """Schema for a planned meal with its log status."""

    planned_meal: PlannedMealResponse
    log: Optional[MealLogResponse] = None


class DailyMealsResponse(BaseModel):
    """Schema for today's meals with log status."""

    date: date
    meals: List[DailyMealWithLog]
