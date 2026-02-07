"""
Common Pydantic schemas used across the application.
"""
from typing import Generic, TypeVar, List
from pydantic import BaseModel


T = TypeVar("T")


class PaginatedResponse(BaseModel, Generic[T]):
    """Generic paginated response."""

    data: List[T]
    total: int
    page: int
    page_size: int
    total_pages: int


class SuccessResponse(BaseModel):
    """Standard success response."""

    message: str = "Success"
    data: dict = {}


class ErrorResponse(BaseModel):
    """Standard error response."""

    detail: dict
