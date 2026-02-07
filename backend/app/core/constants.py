"""
Application-wide constants and enums.
"""
from enum import Enum


class MacroFormat(str, Enum):
    """Macro target format."""

    PERCENTAGE = "percentage"
    ABSOLUTE = "absolute"


class PlanStatus(str, Enum):
    """Meal plan status."""

    PENDING = "pending"
    ACCEPTED = "accepted"
    ARCHIVED = "archived"


class LogStatus(str, Enum):
    """Meal log status."""

    EATEN = "eaten"
    SKIPPED = "skipped"


class MealType(str, Enum):
    """Type of meal in the plan."""

    MEAL = "meal"
    SNACK = "snack"
