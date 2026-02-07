"""
Tests for nutrition goals endpoints.
"""
import pytest
from fastapi.testclient import TestClient
from app.models.goal import NutritionGoal
from app.core.constants import MacroFormat


def test_create_goal_absolute(client: TestClient, auth_headers, test_user):
    """Test creating a nutrition goal with absolute macros."""
    response = client.post(
        "/api/v1/goals",
        headers=auth_headers,
        json={
            "daily_calories": 2000,
            "macro_format": "absolute",
            "protein_target": 150.0,
            "carb_target": 200.0,
            "fat_target": 70.0,
        },
    )
    assert response.status_code == 201
    data = response.json()
    assert data["daily_calories"] == 2000
    assert data["macro_format"] == "absolute"
    assert data["protein_target"] == 150.0
    assert data["is_active"] == True


def test_create_goal_percentage(client: TestClient, auth_headers):
    """Test creating a nutrition goal with percentage macros."""
    response = client.post(
        "/api/v1/goals",
        headers=auth_headers,
        json={
            "daily_calories": 2500,
            "macro_format": "percentage",
            "protein_target": 30.0,
            "carb_target": 40.0,
            "fat_target": 30.0,
        },
    )
    assert response.status_code == 201
    data = response.json()
    assert data["macro_format"] == "percentage"
    assert data["protein_target"] == 30.0


def test_get_active_goal(client: TestClient, auth_headers, test_user, db):
    """Test getting active nutrition goal."""
    # Create a goal first
    goal = NutritionGoal(
        user_id=test_user.id,
        daily_calories=2000,
        macro_format=MacroFormat.ABSOLUTE,
        protein_target=150.0,
        carb_target=200.0,
        fat_target=70.0,
        is_active=True,
    )
    db.add(goal)
    db.commit()

    response = client.get("/api/v1/goals", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["daily_calories"] == 2000
    assert data["is_active"] == True


def test_get_active_goal_not_found(client: TestClient, auth_headers):
    """Test getting active goal when none exists."""
    response = client.get("/api/v1/goals", headers=auth_headers)
    assert response.status_code == 404


def test_create_second_goal_deactivates_first(client: TestClient, auth_headers, test_user, db):
    """Test that creating a new goal deactivates the previous one."""
    # Create first goal
    goal1 = NutritionGoal(
        user_id=test_user.id,
        daily_calories=2000,
        macro_format=MacroFormat.ABSOLUTE,
        protein_target=150.0,
        carb_target=200.0,
        fat_target=70.0,
        is_active=True,
    )
    db.add(goal1)
    db.commit()
    goal1_id = goal1.id

    # Create second goal
    response = client.post(
        "/api/v1/goals",
        headers=auth_headers,
        json={
            "daily_calories": 2500,
            "macro_format": "absolute",
            "protein_target": 180.0,
            "carb_target": 220.0,
            "fat_target": 80.0,
        },
    )
    assert response.status_code == 201

    # Check that first goal is now inactive
    db.refresh(goal1)
    assert goal1.is_active == False

    # Check that active goal is the new one
    active_response = client.get("/api/v1/goals", headers=auth_headers)
    assert active_response.json()["daily_calories"] == 2500


def test_calculate_tdee(client: TestClient):
    """Test TDEE calculation."""
    response = client.post(
        "/api/v1/goals/calculate-tdee",
        json={
            "age": 30,
            "weight_kg": 70.0,
            "height_cm": 175.0,
            "gender": "male",
            "activity_level": "moderately_active",
            "goal": "maintenance",
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert "bmr" in data
    assert "tdee" in data
    assert "recommended_calories" in data
    assert data["bmr"] > 0
    assert data["tdee"] > data["bmr"]
    assert data["recommended_calories"] == data["tdee"]  # Maintenance = no adjustment


def test_calculate_tdee_cutting(client: TestClient):
    """Test TDEE calculation for cutting."""
    response = client.post(
        "/api/v1/goals/calculate-tdee",
        json={
            "age": 25,
            "weight_kg": 80.0,
            "height_cm": 180.0,
            "gender": "male",
            "activity_level": "lightly_active",
            "goal": "cutting",
        },
    )
    assert response.status_code == 200
    data = response.json()
    # Cutting should be 500 calories less than TDEE
    assert data["recommended_calories"] == data["tdee"] - 500


def test_calculate_tdee_bulking(client: TestClient):
    """Test TDEE calculation for bulking."""
    response = client.post(
        "/api/v1/goals/calculate-tdee",
        json={
            "age": 28,
            "weight_kg": 65.0,
            "height_cm": 170.0,
            "gender": "female",
            "activity_level": "very_active",
            "goal": "bulking",
        },
    )
    assert response.status_code == 200
    data = response.json()
    # Bulking should be 500 calories more than TDEE
    assert data["recommended_calories"] == data["tdee"] + 500


def test_goals_unauthorized(client: TestClient):
    """Test accessing goals without authentication."""
    response = client.get("/api/v1/goals")
    assert response.status_code == 403
