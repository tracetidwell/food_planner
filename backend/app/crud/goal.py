"""
NutritionGoal CRUD operations.
"""
from typing import Optional
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.goal import NutritionGoal
from app.schemas.goal import NutritionGoalCreate
from app.core.constants import MacroFormat


class CRUDGoal(CRUDBase[NutritionGoal, NutritionGoalCreate, dict]):
    """CRUD operations for NutritionGoal model."""

    def get_active_goal(self, db: Session, *, user_id: str) -> Optional[NutritionGoal]:
        """Get the active nutrition goal for a user."""
        return (
            db.query(NutritionGoal)
            .filter(NutritionGoal.user_id == user_id, NutritionGoal.is_active == True)
            .first()
        )

    def create_new_goal(self, db: Session, *, user_id: str, obj_in: NutritionGoalCreate) -> NutritionGoal:
        """Create a new goal and deactivate previous ones."""
        # Deactivate all previous goals
        db.query(NutritionGoal).filter(
            NutritionGoal.user_id == user_id,
            NutritionGoal.is_active == True
        ).update({"is_active": False})

        # Create new goal
        obj_in_data = obj_in.model_dump()
        db_goal = NutritionGoal(
            user_id=user_id,
            **obj_in_data
        )
        db.add(db_goal)
        db.commit()
        db.refresh(db_goal)
        return db_goal

    def convert_macros_to_grams(
        self,
        *,
        daily_calories: int,
        protein: float,
        carbs: float,
        fat: float,
        format: MacroFormat
    ) -> tuple:
        """Convert macros from percentage to grams or vice versa."""
        if format == MacroFormat.PERCENTAGE:
            # Convert percentage to grams
            protein_grams = (daily_calories * (protein / 100)) / 4
            carb_grams = (daily_calories * (carbs / 100)) / 4
            fat_grams = (daily_calories * (fat / 100)) / 9
            return protein_grams, carb_grams, fat_grams
        else:
            # Already in grams
            return protein, carbs, fat


goal = CRUDGoal(NutritionGoal)
