"""
Nutrition goal Pydantic schemas.
"""
from datetime import datetime
from typing import Optional
from pydantic import BaseModel, Field, field_validator

from app.core.constants import MacroFormat


class NutritionGoalCreate(BaseModel):
    """Schema for creating a nutrition goal."""

    daily_calories: int = Field(..., gt=0, le=10000)
    macro_format: MacroFormat
    protein_target: float = Field(..., gt=0)
    carb_target: float = Field(..., gt=0)
    fat_target: float = Field(..., gt=0)

    @field_validator("protein_target", "carb_target", "fat_target")
    @classmethod
    def validate_macro_targets(cls, v, info):
        """Validate macro targets based on format."""
        if info.data.get("macro_format") == MacroFormat.PERCENTAGE:
            if v > 100:
                raise ValueError("Percentage values must be <= 100")
        return v


class NutritionGoalResponse(BaseModel):
    """Schema for nutrition goal response."""

    id: str
    user_id: str
    daily_calories: int
    macro_format: MacroFormat
    protein_target: float
    carb_target: float
    fat_target: float
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True


class TDEECalculateRequest(BaseModel):
    """Schema for TDEE calculation request."""

    age: int = Field(..., gt=0, le=120)
    weight_kg: float = Field(..., gt=0, le=500)
    height_cm: float = Field(..., gt=0, le=300)
    gender: str = Field(..., pattern="^(male|female)$")
    activity_level: str = Field(
        ...,
        pattern="^(sedentary|lightly_active|moderately_active|very_active|extra_active)$",
    )
    goal: str = Field(..., pattern="^(lose_weight|maintain|gain_weight)$")


class TDEECalculateResponse(BaseModel):
    """Schema for TDEE calculation response."""

    bmr: int
    tdee: int
    recommended_calories: int
    activity_level: str
    goal: str
