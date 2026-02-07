"""
Analytics Pydantic schemas.
"""
from datetime import date
from typing import Optional
from pydantic import BaseModel


class DailyTotals(BaseModel):
    """Schema for daily macro totals."""

    date: date
    protein_grams: float
    carb_grams: float
    fat_grams: float
    calories: int
    meals_logged: int
    meals_planned: int


class WeeklySummary(BaseModel):
    """Schema for weekly summary statistics."""

    avg_daily_calories: Optional[float] = None
    avg_protein_grams: Optional[float] = None
    avg_carb_grams: Optional[float] = None
    avg_fat_grams: Optional[float] = None
    days_with_logs: int
    total_days: int


class SummaryStatsResponse(BaseModel):
    """Schema for summary statistics response."""

    seven_day_summary: WeeklySummary
    thirty_day_summary: WeeklySummary
    logging_consistency_percentage: float
