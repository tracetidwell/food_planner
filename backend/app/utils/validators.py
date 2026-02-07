"""
Custom validation functions.
"""
from app.core.constants import MacroFormat


def validate_macro_percentages(
    *, protein: float, carbs: float, fat: float, format: MacroFormat
) -> bool:
    """Validate that macro percentages sum to approximately 100%."""
    if format == MacroFormat.PERCENTAGE:
        total = protein + carbs + fat
        return 99 <= total <= 101  # Allow 1% variance
    return True  # No validation needed for absolute values


def validate_meal_structure(*, meals_per_day: int, snacks_per_day: int) -> bool:
    """Validate meal structure."""
    return 1 <= meals_per_day <= 6 and 0 <= snacks_per_day <= 4
