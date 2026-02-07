"""
MealPlan and PlannedMeal database models.
"""
import uuid
from datetime import datetime, date
from sqlalchemy import Column, String, Integer, Float, DateTime, ForeignKey, Enum as SQLEnum, Date, JSON
from sqlalchemy.orm import relationship

from app.db.base import Base
from app.core.constants import PlanStatus, MealType


def generate_uuid():
    """Generate a UUID as a string."""
    return str(uuid.uuid4())


class MealPlan(Base):
    """Meal plan model."""

    __tablename__ = "meal_plans"

    id = Column(String(36), primary_key=True, default=generate_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    goal_id = Column(String(36), ForeignKey("nutrition_goals.id", ondelete="SET NULL"), nullable=True)
    start_date = Column(Date, nullable=False)
    duration_days = Column(Integer, nullable=False)
    status = Column(SQLEnum(PlanStatus), default=PlanStatus.PENDING, nullable=False, index=True)
    generated_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    accepted_at = Column(DateTime, nullable=True)

    # Relationships
    user = relationship("User", back_populates="meal_plans")
    goal = relationship("NutritionGoal", back_populates="meal_plans")
    planned_meals = relationship("PlannedMeal", back_populates="meal_plan", cascade="all, delete-orphan")
    grocery_list = relationship("GroceryList", back_populates="meal_plan", uselist=False, cascade="all, delete-orphan")


class PlannedMeal(Base):
    """Planned meal within a meal plan."""

    __tablename__ = "planned_meals"

    id = Column(String(36), primary_key=True, default=generate_uuid)
    meal_plan_id = Column(String(36), ForeignKey("meal_plans.id", ondelete="CASCADE"), nullable=False, index=True)
    day_index = Column(Integer, nullable=False)  # 0-based index for day in plan
    meal_type = Column(SQLEnum(MealType), nullable=False)
    meal_index = Column(Integer, nullable=False)  # Index within type (meal 1, meal 2, snack 1, etc.)
    name = Column(String(255), nullable=False)
    foods = Column(JSON, nullable=False)  # List of {food: str, quantity_grams: float}
    protein_grams = Column(Float, nullable=False)
    carb_grams = Column(Float, nullable=False)
    fat_grams = Column(Float, nullable=False)
    calories = Column(Integer, nullable=False)

    # Relationships
    meal_plan = relationship("MealPlan", back_populates="planned_meals")
    logs = relationship("MealLog", back_populates="planned_meal", cascade="all, delete-orphan")
