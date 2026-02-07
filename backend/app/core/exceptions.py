"""
Custom exception classes for the application.
"""


class APIKeyLimitExceeded(Exception):
    """Raised when user exceeds API usage limit."""

    pass


class OpenAIAPIError(Exception):
    """Raised when OpenAI API call fails."""

    pass


class MealPlanNotFound(Exception):
    """Raised when a meal plan is not found."""

    pass


class InvalidCredentials(Exception):
    """Raised when authentication credentials are invalid."""

    pass


class ActiveGoalNotFound(Exception):
    """Raised when user has no active nutrition goal."""

    pass


class ValidationError(Exception):
    """Raised when validation fails."""

    pass
