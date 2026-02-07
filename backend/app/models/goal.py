"""
NutritionGoal database model.
"""
import uuid
from datetime import datetime
from sqlalchemy import Column, String, Integer, Float, Boolean, DateTime, ForeignKey, Enum as SQLEnum
from sqlalchemy.orm import relationship

from app.db.base import Base
from app.core.constants import MacroFormat


def generate_uuid():
    """Generate a UUID as a string."""
    return str(uuid.uuid4())


class NutritionGoal(Base):
    """Nutrition goal model for user targets."""

    __tablename__ = "nutrition_goals"

    id = Column(String(36), primary_key=True, default=generate_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    daily_calories = Column(Integer, nullable=False)
    macro_format = Column(SQLEnum(MacroFormat), nullable=False)
    protein_target = Column(Float, nullable=False)  # Percentage or grams based on format
    carb_target = Column(Float, nullable=False)
    fat_target = Column(Float, nullable=False)
    is_active = Column(Boolean, default=True, nullable=False, index=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    user = relationship("User", back_populates="goals")
    meal_plans = relationship("MealPlan", back_populates="goal")
