"""
MealPlan CRUD operations.
"""
from typing import Optional, List
from sqlalchemy.orm import Session, joinedload

from app.crud.base import CRUDBase
from app.models.meal_plan import MealPlan, PlannedMeal
from app.core.constants import PlanStatus


class CRUDMealPlan(CRUDBase[MealPlan, dict, dict]):
    """CRUD operations for MealPlan model."""

    def get_active_plan(self, db: Session, *, user_id: str) -> Optional[MealPlan]:
        """Get the active meal plan for a user."""
        return (
            db.query(MealPlan)
            .filter(
                MealPlan.user_id == user_id,
                MealPlan.status == PlanStatus.ACCEPTED
            )
            .order_by(MealPlan.accepted_at.desc())
            .first()
        )

    def get_plan_with_meals(self, db: Session, *, plan_id: str) -> Optional[MealPlan]:
        """Get a meal plan with all planned meals (eager loading)."""
        return (
            db.query(MealPlan)
            .options(joinedload(MealPlan.planned_meals))
            .filter(MealPlan.id == plan_id)
            .first()
        )

    def get_user_plans(
        self, db: Session, *, user_id: str, skip: int = 0, limit: int = 100
    ) -> List[MealPlan]:
        """Get all meal plans for a user."""
        return (
            db.query(MealPlan)
            .filter(MealPlan.user_id == user_id)
            .order_by(MealPlan.generated_at.desc())
            .offset(skip)
            .limit(limit)
            .all()
        )

    def update_status(
        self, db: Session, *, plan_id: str, status: PlanStatus
    ) -> Optional[MealPlan]:
        """Update meal plan status."""
        plan = db.query(MealPlan).filter(MealPlan.id == plan_id).first()
        if plan:
            plan.status = status
            if status == PlanStatus.ACCEPTED:
                from datetime import datetime
                plan.accepted_at = datetime.utcnow()
            db.commit()
            db.refresh(plan)
        return plan


class CRUDPlannedMeal(CRUDBase[PlannedMeal, dict, dict]):
    """CRUD operations for PlannedMeal model."""

    def get_meal(self, db: Session, *, meal_id: str) -> Optional[PlannedMeal]:
        """Get a planned meal by ID."""
        return db.query(PlannedMeal).filter(PlannedMeal.id == meal_id).first()

    def delete_meal(self, db: Session, *, meal_id: str) -> bool:
        """Delete a planned meal."""
        meal = self.get_meal(db, meal_id=meal_id)
        if meal:
            db.delete(meal)
            db.commit()
            return True
        return False


meal_plan = CRUDMealPlan(MealPlan)
planned_meal = CRUDPlannedMeal(PlannedMeal)
