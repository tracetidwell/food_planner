"""
MealLog CRUD operations.
"""
from datetime import date, datetime, timedelta
from typing import List, Optional, Dict
from sqlalchemy.orm import Session
from sqlalchemy import func

from app.crud.base import CRUDBase
from app.models.log import MealLog
from app.models.meal_plan import PlannedMeal
from app.core.constants import LogStatus


class CRUDLog(CRUDBase[MealLog, dict, dict]):
    """CRUD operations for MealLog model."""

    def get_logs_for_date(
        self, db: Session, *, user_id: str, log_date: date
    ) -> List[MealLog]:
        """Get all logs for a specific date."""
        return (
            db.query(MealLog)
            .filter(MealLog.user_id == user_id, MealLog.log_date == log_date)
            .all()
        )

    def get_logs_in_range(
        self, db: Session, *, user_id: str, start_date: date, end_date: date
    ) -> List[MealLog]:
        """Get logs within a date range."""
        return (
            db.query(MealLog)
            .filter(
                MealLog.user_id == user_id,
                MealLog.log_date >= start_date,
                MealLog.log_date <= end_date,
            )
            .all()
        )

    def create_log(
        self,
        db: Session,
        *,
        user_id: str,
        planned_meal_id: str,
        status: LogStatus,
        log_date: date
    ) -> MealLog:
        """Create a meal log."""
        # Check if log already exists for this meal and date
        existing_log = (
            db.query(MealLog)
            .filter(
                MealLog.user_id == user_id,
                MealLog.planned_meal_id == planned_meal_id,
                MealLog.log_date == log_date,
            )
            .first()
        )

        if existing_log:
            # Update existing log
            existing_log.status = status
            existing_log.logged_at = datetime.utcnow()
            db.commit()
            db.refresh(existing_log)
            return existing_log
        else:
            # Create new log
            db_log = MealLog(
                user_id=user_id,
                planned_meal_id=planned_meal_id,
                log_date=log_date,
                status=status,
            )
            db.add(db_log)
            db.commit()
            db.refresh(db_log)
            return db_log

    def get_daily_totals(
        self, db: Session, *, user_id: str, log_date: date
    ) -> Dict[str, float]:
        """Calculate daily macro totals for a specific date."""
        logs = (
            db.query(MealLog, PlannedMeal)
            .join(PlannedMeal, MealLog.planned_meal_id == PlannedMeal.id)
            .filter(
                MealLog.user_id == user_id,
                MealLog.log_date == log_date,
                MealLog.status == LogStatus.EATEN,
            )
            .all()
        )

        totals = {
            "protein_grams": 0.0,
            "carb_grams": 0.0,
            "fat_grams": 0.0,
            "calories": 0,
            "meals_logged": len(logs),
        }

        for log, meal in logs:
            totals["protein_grams"] += meal.protein_grams
            totals["carb_grams"] += meal.carb_grams
            totals["fat_grams"] += meal.fat_grams
            totals["calories"] += meal.calories

        return totals


log = CRUDLog(MealLog)
