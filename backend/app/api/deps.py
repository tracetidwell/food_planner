"""
API dependencies for dependency injection.
"""
from typing import Generator
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.core.security import verify_token
from app.crud.user import user as user_crud
from app.models.user import User, UserProfile
from app.config import settings
from app.core.exceptions import APIKeyLimitExceeded

# HTTP Bearer token scheme
security = HTTPBearer()


def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db),
) -> User:
    """Get the current authenticated user from JWT token."""
    token = credentials.credentials

    # Verify token
    payload = verify_token(token)
    if payload is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

    email: str = payload.get("sub")
    if email is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # Get user from database
    user = user_crud.get_by_email(db, email=email)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found",
        )

    return user


def check_api_rate_limit(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> None:
    """
    Check if user has exceeded API usage limit.

    Only applies if user is using the default app API key (not their own).
    """
    profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()

    # If user has their own API key, no limit
    if profile and profile.openai_api_key_encrypted:
        return

    # Check if user has exceeded limit
    if profile and profile.api_usage_count >= settings.API_USAGE_LIMIT_PER_MONTH:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail=f"API usage limit exceeded ({settings.API_USAGE_LIMIT_PER_MONTH} per month). Please add your own OpenAI API key.",
        )
