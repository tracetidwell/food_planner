"""
User CRUD operations.
"""
from datetime import datetime, timedelta
from typing import Optional
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.user import User, UserProfile
from app.schemas.user import UserCreate
from app.core.security import hash_password, verify_password


class CRUDUser(CRUDBase[User, UserCreate, dict]):
    """CRUD operations for User model."""

    def get_by_email(self, db: Session, *, email: str) -> Optional[User]:
        """Get user by email."""
        return db.query(User).filter(User.email == email).first()

    def create_with_profile(self, db: Session, *, obj_in: UserCreate) -> User:
        """Create a new user with a profile."""
        # Hash password
        hashed_password = hash_password(obj_in.password)

        # Create user
        db_user = User(
            email=obj_in.email,
            hashed_password=hashed_password,
        )
        db.add(db_user)
        db.flush()  # Get the user ID

        # Create profile
        db_profile = UserProfile(
            user_id=db_user.id,
            meals_per_day=3,
            snacks_per_day=2,
        )
        db.add(db_profile)
        db.commit()
        db.refresh(db_user)
        return db_user

    def authenticate(self, db: Session, *, email: str, password: str) -> Optional[User]:
        """Authenticate a user."""
        user = self.get_by_email(db, email=email)
        if not user:
            return None
        if not verify_password(password, user.hashed_password):
            return None
        return user

    def update_api_usage(self, db: Session, *, user_id: str) -> None:
        """Increment API usage count for a user."""
        profile = db.query(UserProfile).filter(UserProfile.user_id == user_id).first()
        if profile:
            # Check if we need to reset the counter (monthly reset)
            if datetime.utcnow() >= profile.api_usage_reset_date + timedelta(days=30):
                profile.api_usage_count = 1
                profile.api_usage_reset_date = datetime.utcnow()
            else:
                profile.api_usage_count += 1
            db.commit()


user = CRUDUser(User)
