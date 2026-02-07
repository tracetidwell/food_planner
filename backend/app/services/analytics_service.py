"""
Analytics and statistics service.
"""
from datetime import date, timedelta
from typing import Dict
from sqlalchemy.orm import Session

from app.crud.log import log as log_crud
from app.models.meal_plan import MealPlan, PlannedMeal
from app.core.constants import PlanStatus


class AnalyticsService:
    """Service for calculating analytics and statistics."""

    @staticmethod
    def get_daily_totals(db: Session, *, user_id: str, target_date: date) -> Dict:
        """Get daily macro totals for a specific date."""
        totals = log_crud.get_daily_totals(db, user_id=user_id, log_date=target_date)

        # Get total planned meals for the date
        active_plan = (
            db.query(MealPlan)
            .filter(
                MealPlan.user_id == user_id,
                MealPlan.status == PlanStatus.ACCEPTED,
                MealPlan.start_date <= target_date,
            )
            .order_by(MealPlan.accepted_at.desc())
            .first()
        )

        meals_planned = 0
        if active_plan:
            days_diff = (target_date - active_plan.start_date).days
            if 0 <= days_diff < active_plan.duration_days:
                meals_planned = (
                    db.query(PlannedMeal)
                    .filter(
                        PlannedMeal.meal_plan_id == active_plan.id,
                        PlannedMeal.day_index == days_diff,
                    )
                    .count()
                )

        return {
            "date": target_date,
            "protein_grams": totals["protein_grams"],
            "carb_grams": totals["carb_grams"],
            "fat_grams": totals["fat_grams"],
            "calories": totals["calories"],
            "meals_logged": totals["meals_logged"],
            "meals_planned": meals_planned,
        }

    @staticmethod
    def get_summary_stats(db: Session, *, user_id: str, days: int = 7) -> Dict:
        """
        Get summary statistics for a period (7 or 30 days).
        """
        end_date = date.today()
        start_date = end_date - timedelta(days=days - 1)

        # Get logs for the period
        logs = log_crud.get_logs_in_range(
            db, user_id=user_id, start_date=start_date, end_date=end_date
        )

        # Calculate stats
        total_protein = 0.0
        total_carbs = 0.0
        total_fat = 0.0
        total_calories = 0
        days_with_logs = set()

        for log in logs:
            days_with_logs.add(log.log_date)
            # Get the meal details
            meal = db.query(PlannedMeal).filter(PlannedMeal.id == log.planned_meal_id).first()
            if meal and log.status.value == "eaten":
                total_protein += meal.protein_grams
                total_carbs += meal.carb_grams
                total_fat += meal.fat_grams
                total_calories += meal.calories

        num_days_with_logs = len(days_with_logs)

        # Calculate averages
        if num_days_with_logs > 0:
            avg_calories = total_calories / num_days_with_logs
            avg_protein = total_protein / num_days_with_logs
            avg_carbs = total_carbs / num_days_with_logs
            avg_fat = total_fat / num_days_with_logs
        else:
            avg_calories = None
            avg_protein = None
            avg_carbs = None
            avg_fat = None

        return {
            "avg_daily_calories": round(avg_calories, 1) if avg_calories else None,
            "avg_protein_grams": round(avg_protein, 1) if avg_protein else None,
            "avg_carb_grams": round(avg_carbs, 1) if avg_carbs else None,
            "avg_fat_grams": round(avg_fat, 1) if avg_fat else None,
            "days_with_logs": num_days_with_logs,
            "total_days": days,
        }

    @staticmethod
    def calculate_logging_consistency(db: Session, *, user_id: str, days: int = 30) -> float:
        """
        Calculate logging consistency percentage over a period.

        Consistency = (days with at least one log / total days) * 100
        """
        end_date = date.today()
        start_date = end_date - timedelta(days=days - 1)

        logs = log_crud.get_logs_in_range(
            db, user_id=user_id, start_date=start_date, end_date=end_date
        )

        days_with_logs = len(set(log.log_date for log in logs))
        consistency_percentage = (days_with_logs / days) * 100

        return round(consistency_percentage, 1)


analytics_service = AnalyticsService()
