"""
User profile API endpoints.
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user
from app.schemas.user import UserProfileResponse, UserProfileUpdate, SetAPIKeyRequest
from app.models.user import User, UserProfile
from app.core.security import encrypt_api_key, decrypt_api_key

router = APIRouter()


@router.get("/profile", response_model=UserProfileResponse)
def get_profile(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get user profile."""
    profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()
    if not profile:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Profile not found",
        )

    # Return profile with has_custom_api_key flag (don't expose actual key)
    response = UserProfileResponse(
        user_id=profile.user_id,
        food_preferences=profile.food_preferences,
        meals_per_day=profile.meals_per_day,
        snacks_per_day=profile.snacks_per_day,
        has_custom_api_key=profile.openai_api_key_encrypted is not None,
        api_usage_count=profile.api_usage_count,
        api_usage_reset_date=profile.api_usage_reset_date,
    )
    return response


@router.put("/profile", response_model=UserProfileResponse)
def update_profile(
    profile_in: UserProfileUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Update user profile."""
    profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()
    if not profile:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Profile not found",
        )

    # Update profile fields
    update_data = profile_in.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(profile, field, value)

    db.commit()
    db.refresh(profile)

    response = UserProfileResponse(
        user_id=profile.user_id,
        food_preferences=profile.food_preferences,
        meals_per_day=profile.meals_per_day,
        snacks_per_day=profile.snacks_per_day,
        has_custom_api_key=profile.openai_api_key_encrypted is not None,
        api_usage_count=profile.api_usage_count,
        api_usage_reset_date=profile.api_usage_reset_date,
    )
    return response


@router.post("/profile/api-key", status_code=status.HTTP_204_NO_CONTENT)
def set_api_key(
    request: SetAPIKeyRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Set user's OpenAI API key."""
    profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()
    if not profile:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Profile not found",
        )

    # Encrypt and store API key
    encrypted_key = encrypt_api_key(request.api_key)
    profile.openai_api_key_encrypted = encrypted_key

    db.commit()
    return


@router.delete("/profile/api-key", status_code=status.HTTP_204_NO_CONTENT)
def delete_api_key(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Remove user's OpenAI API key."""
    profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()
    if not profile:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Profile not found",
        )

    profile.openai_api_key_encrypted = None
    db.commit()
    return
