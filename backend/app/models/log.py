"""
MealLog database model.
"""
import uuid
from datetime import datetime, date
from sqlalchemy import Column, String, DateTime, ForeignKey, Enum as SQLEnum, Date, Index
from sqlalchemy.orm import relationship

from app.db.base import Base
from app.core.constants import LogStatus


def generate_uuid():
    """Generate a UUID as a string."""
    return str(uuid.uuid4())


class MealLog(Base):
    """Meal log for tracking eaten/skipped meals."""

    __tablename__ = "meal_logs"

    id = Column(String(36), primary_key=True, default=generate_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    planned_meal_id = Column(String(36), ForeignKey("planned_meals.id", ondelete="CASCADE"), nullable=False)
    log_date = Column(Date, nullable=False, index=True)
    status = Column(SQLEnum(LogStatus), nullable=False)
    logged_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    user = relationship("User", back_populates="meal_logs")
    planned_meal = relationship("PlannedMeal", back_populates="logs")

    # Composite index for efficient queries
    __table_args__ = (
        Index("ix_meal_logs_user_date", "user_id", "log_date"),
    )
