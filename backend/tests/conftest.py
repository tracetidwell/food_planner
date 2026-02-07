"""
Pytest configuration and fixtures.
"""
import os
import pytest
from typing import Generator
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app.main import app
from app.db.base import Base
from app.db.session import get_db
from app.api.deps import get_current_user
from app.models.user import User, UserProfile
from app.core.security import hash_password

# Use in-memory SQLite for testing
SQLALCHEMY_DATABASE_URL = "sqlite:///:memory:"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


@pytest.fixture(scope="function")
def db() -> Generator:
    """Create a fresh database for each test."""
    Base.metadata.create_all(bind=engine)
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()
        Base.metadata.drop_all(bind=engine)


@pytest.fixture(scope="function")
def client(db) -> Generator:
    """Create a test client with database override."""

    def override_get_db():
        try:
            yield db
        finally:
            pass

    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as test_client:
        yield test_client
    app.dependency_overrides.clear()


@pytest.fixture
def test_user(db) -> User:
    """Create a test user."""
    user = User(
        email="test@example.com",
        hashed_password=hash_password("testpassword123"),
    )
    db.add(user)
    db.flush()

    profile = UserProfile(
        user_id=user.id,
        meals_per_day=3,
        snacks_per_day=2,
    )
    db.add(profile)
    db.commit()
    db.refresh(user)
    return user


@pytest.fixture
def auth_headers(client, test_user) -> dict:
    """Get authentication headers for test user."""
    response = client.post(
        "/api/v1/auth/login",
        json={"email": "test@example.com", "password": "testpassword123"},
    )
    token = response.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}


@pytest.fixture
def mock_openai_response():
    """Mock OpenAI API response for meal plan generation."""
    return {
        "days": [
            {
                "day": 1,
                "meals": [
                    {
                        "type": "meal",
                        "index": 1,
                        "name": "Grilled Chicken with Brown Rice and Broccoli",
                        "foods": [
                            {"food": "Chicken breast (grilled)", "quantity_grams": 200},
                            {"food": "Brown rice (cooked)", "quantity_grams": 150},
                            {"food": "Broccoli (steamed)", "quantity_grams": 100},
                        ],
                        "protein_grams": 52.0,
                        "carb_grams": 48.0,
                        "fat_grams": 8.0,
                        "calories": 468,
                    },
                    {
                        "type": "meal",
                        "index": 2,
                        "name": "Salmon with Quinoa and Asparagus",
                        "foods": [
                            {"food": "Salmon fillet", "quantity_grams": 180},
                            {"food": "Quinoa (cooked)", "quantity_grams": 120},
                            {"food": "Asparagus", "quantity_grams": 100},
                        ],
                        "protein_grams": 48.0,
                        "carb_grams": 52.0,
                        "fat_grams": 18.0,
                        "calories": 562,
                    },
                    {
                        "type": "meal",
                        "index": 3,
                        "name": "Turkey Meatballs with Sweet Potato",
                        "foods": [
                            {"food": "Turkey meatballs", "quantity_grams": 200},
                            {"food": "Sweet potato (baked)", "quantity_grams": 200},
                            {"food": "Green beans", "quantity_grams": 100},
                        ],
                        "protein_grams": 50.0,
                        "carb_grams": 60.0,
                        "fat_grams": 12.0,
                        "calories": 540,
                    },
                    {
                        "type": "snack",
                        "index": 1,
                        "name": "Greek Yogurt with Berries",
                        "foods": [
                            {"food": "Greek yogurt", "quantity_grams": 150},
                            {"food": "Mixed berries", "quantity_grams": 80},
                        ],
                        "protein_grams": 15.0,
                        "carb_grams": 20.0,
                        "fat_grams": 5.0,
                        "calories": 185,
                    },
                    {
                        "type": "snack",
                        "index": 2,
                        "name": "Almonds and Apple",
                        "foods": [
                            {"food": "Almonds", "quantity_grams": 30},
                            {"food": "Apple", "quantity_grams": 120},
                        ],
                        "protein_grams": 6.0,
                        "carb_grams": 20.0,
                        "fat_grams": 14.0,
                        "calories": 230,
                    },
                ],
            }
        ]
    }
