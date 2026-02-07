"""
Meal plan Pydantic schemas.
"""
from datetime import datetime, date
from typing import List, Dict, Any, Optional
from pydantic import BaseModel, Field

from app.core.constants import PlanStatus, MealType


class FoodItem(BaseModel):
    """Schema for a food item in a meal."""

    food: str
    quantity_grams: float


class PlannedMealResponse(BaseModel):
    """Schema for planned meal response."""

    id: str
    meal_plan_id: str
    day_index: int
    meal_type: MealType
    meal_index: int
    name: str
    foods: List[Dict[str, Any]]  # List of food items
    protein_grams: float
    carb_grams: float
    fat_grams: float
    calories: int

    class Config:
        from_attributes = True


class MealPlanGenerateRequest(BaseModel):
    """Schema for generating a meal plan."""

    start_date: date
    duration_days: int = Field(..., ge=1, le=14)


class RegenerateMealRequest(BaseModel):
    """Schema for regenerating a single meal."""

    planned_meal_id: str


class MealPlanResponse(BaseModel):
    """Schema for meal plan response."""

    id: str
    user_id: str
    goal_id: Optional[str]
    start_date: date
    duration_days: int
    status: PlanStatus
    generated_at: datetime
    accepted_at: Optional[datetime]
    planned_meals: List[PlannedMealResponse] = []

    class Config:
        from_attributes = True


class MealPlanListItem(BaseModel):
    """Schema for meal plan list item (without meals)."""

    id: str
    start_date: date
    duration_days: int
    status: PlanStatus
    generated_at: datetime
    accepted_at: Optional[datetime]
    total_meals: int

    class Config:
        from_attributes = True


class GroceryListItem(BaseModel):
    """Schema for grocery list item."""

    food: str
    total_quantity_grams: float
    category: str


class GroceryListResponse(BaseModel):
    """Schema for grocery list response."""

    id: str
    meal_plan_id: str
    items: List[Dict[str, Any]]
    generated_at: datetime

    class Config:
        from_attributes = True
