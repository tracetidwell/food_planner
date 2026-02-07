"""
GroceryList database model.
"""
import uuid
from datetime import datetime
from sqlalchemy import Column, String, DateTime, ForeignKey, JSON
from sqlalchemy.orm import relationship

from app.db.base import Base


def generate_uuid():
    """Generate a UUID as a string."""
    return str(uuid.uuid4())


class GroceryList(Base):
    """Grocery list generated from a meal plan."""

    __tablename__ = "grocery_lists"

    id = Column(String(36), primary_key=True, default=generate_uuid)
    meal_plan_id = Column(String(36), ForeignKey("meal_plans.id", ondelete="CASCADE"), nullable=False, unique=True)
    items = Column(JSON, nullable=False)  # List of {food: str, total_quantity_grams: float, category: str}
    generated_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    meal_plan = relationship("MealPlan", back_populates="grocery_list")
