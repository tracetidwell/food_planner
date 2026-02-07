"""
User and authentication Pydantic schemas.
"""
from datetime import datetime
from typing import Optional
from pydantic import BaseModel, EmailStr, Field


class UserCreate(BaseModel):
    """Schema for creating a new user."""

    email: EmailStr
    password: str = Field(..., min_length=8, max_length=100)


class UserLogin(BaseModel):
    """Schema for user login."""

    email: EmailStr
    password: str


class Token(BaseModel):
    """Schema for JWT token response."""

    access_token: str
    token_type: str = "bearer"


class TokenData(BaseModel):
    """Schema for decoded JWT token data."""

    email: Optional[str] = None


class UserResponse(BaseModel):
    """Schema for user response."""

    id: str
    email: str
    created_at: datetime

    class Config:
        from_attributes = True


class UserProfileUpdate(BaseModel):
    """Schema for updating user profile."""

    food_preferences: Optional[str] = None
    meals_per_day: Optional[int] = Field(None, ge=1, le=6)
    snacks_per_day: Optional[int] = Field(None, ge=0, le=4)


class UserProfileResponse(BaseModel):
    """Schema for user profile response."""

    user_id: str
    food_preferences: Optional[str] = None
    meals_per_day: int
    snacks_per_day: int
    has_custom_api_key: bool  # Don't expose the actual key
    api_usage_count: int
    api_usage_reset_date: datetime

    class Config:
        from_attributes = True


class SetAPIKeyRequest(BaseModel):
    """Schema for setting user's OpenAI API key."""

    api_key: str = Field(..., min_length=20)
