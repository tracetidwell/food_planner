"""
Tests for meal plans endpoints.
"""
import pytest
from datetime import date
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient

from app.models.goal import NutritionGoal
from app.models.meal_plan import MealPlan, PlannedMeal
from app.core.constants import MacroFormat, PlanStatus, MealType


@pytest.fixture
def test_goal(db, test_user):
    """Create a test nutrition goal."""
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
    db.refresh(goal)
    return goal


def test_generate_meal_plan_success(
    client: TestClient, auth_headers, test_goal, mock_openai_response
):
    """Test successful meal plan generation."""
    with patch("app.services.meal_plan_service.OpenAIService") as mock_openai:
        mock_instance = MagicMock()
        mock_instance.generate_meal_plan.return_value = mock_openai_response
        mock_openai.return_value = mock_instance

        response = client.post(
            "/api/v1/meal-plans/generate",
            headers=auth_headers,
            json={"start_date": "2026-01-15", "duration_days": 1},
        )

        assert response.status_code == 201
        data = response.json()
        assert data["duration_days"] == 1
        assert data["status"] == "pending"
        assert len(data["planned_meals"]) == 5  # 3 meals + 2 snacks


def test_generate_meal_plan_no_goal(client: TestClient, auth_headers):
    """Test meal plan generation fails without active goal."""
    response = client.post(
        "/api/v1/meal-plans/generate",
        headers=auth_headers,
        json={"start_date": "2026-01-15", "duration_days": 1},
    )
    assert response.status_code == 500  # Wrapped in generic error


def test_generate_meal_plan_invalid_duration(client: TestClient, auth_headers, test_goal):
    """Test meal plan generation with invalid duration."""
    response = client.post(
        "/api/v1/meal-plans/generate",
        headers=auth_headers,
        json={"start_date": "2026-01-15", "duration_days": 20},  # Max is 14
    )
    assert response.status_code == 422


def test_list_meal_plans(client: TestClient, auth_headers, test_user, test_goal, db):
    """Test listing user's meal plans."""
    # Create some meal plans
    plan1 = MealPlan(
        user_id=test_user.id,
        goal_id=test_goal.id,
        start_date=date(2026, 1, 10),
        duration_days=3,
        status=PlanStatus.ACCEPTED,
    )
    plan2 = MealPlan(
        user_id=test_user.id,
        goal_id=test_goal.id,
        start_date=date(2026, 1, 15),
        duration_days=1,
        status=PlanStatus.PENDING,
    )
    db.add_all([plan1, plan2])
    db.commit()

    response = client.get("/api/v1/meal-plans", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 2


def test_get_meal_plan(client: TestClient, auth_headers, test_user, test_goal, db):
    """Test getting a specific meal plan."""
    plan = MealPlan(
        user_id=test_user.id,
        goal_id=test_goal.id,
        start_date=date(2026, 1, 10),
        duration_days=1,
        status=PlanStatus.PENDING,
    )
    db.add(plan)
    db.flush()

    meal = PlannedMeal(
        meal_plan_id=plan.id,
        day_index=0,
        meal_type=MealType.MEAL,
        meal_index=1,
        name="Test Meal",
        foods=[{"food": "Chicken", "quantity_grams": 200}],
        protein_grams=50.0,
        carb_grams=10.0,
        fat_grams=5.0,
        calories=300,
    )
    db.add(meal)
    db.commit()

    response = client.get(f"/api/v1/meal-plans/{plan.id}", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == plan.id
    assert len(data["planned_meals"]) == 1


def test_get_meal_plan_not_found(client: TestClient, auth_headers):
    """Test getting non-existent meal plan."""
    response = client.get(
        "/api/v1/meal-plans/nonexistent-id", headers=auth_headers
    )
    assert response.status_code == 404


def test_accept_meal_plan(client: TestClient, auth_headers, test_user, test_goal, db):
    """Test accepting a meal plan."""
    plan = MealPlan(
        user_id=test_user.id,
        goal_id=test_goal.id,
        start_date=date(2026, 1, 10),
        duration_days=1,
        status=PlanStatus.PENDING,
    )
    db.add(plan)
    db.flush()

    # Add a meal to the plan
    meal = PlannedMeal(
        meal_plan_id=plan.id,
        day_index=0,
        meal_type=MealType.MEAL,
        meal_index=1,
        name="Test Meal",
        foods=[{"food": "Chicken breast", "quantity_grams": 200}],
        protein_grams=50.0,
        carb_grams=10.0,
        fat_grams=5.0,
        calories=300,
    )
    db.add(meal)
    db.commit()

    response = client.post(
        f"/api/v1/meal-plans/{plan.id}/accept", headers=auth_headers
    )
    assert response.status_code == 204

    # Verify status changed
    db.refresh(plan)
    assert plan.status == PlanStatus.ACCEPTED
    assert plan.accepted_at is not None


def test_get_grocery_list(client: TestClient, auth_headers, test_user, test_goal, db):
    """Test getting grocery list for a meal plan."""
    plan = MealPlan(
        user_id=test_user.id,
        goal_id=test_goal.id,
        start_date=date(2026, 1, 10),
        duration_days=1,
        status=PlanStatus.PENDING,
    )
    db.add(plan)
    db.flush()

    meal = PlannedMeal(
        meal_plan_id=plan.id,
        day_index=0,
        meal_type=MealType.MEAL,
        meal_index=1,
        name="Test Meal",
        foods=[{"food": "Chicken breast", "quantity_grams": 200}],
        protein_grams=50.0,
        carb_grams=10.0,
        fat_grams=5.0,
        calories=300,
    )
    db.add(meal)
    db.commit()

    # Accept the plan to generate grocery list
    client.post(f"/api/v1/meal-plans/{plan.id}/accept", headers=auth_headers)

    # Get grocery list
    response = client.get(
        f"/api/v1/meal-plans/{plan.id}/grocery-list", headers=auth_headers
    )
    assert response.status_code == 200
    data = response.json()
    assert "items" in data
    assert len(data["items"]) > 0


def test_delete_meal_plan(client: TestClient, auth_headers, test_user, test_goal, db):
    """Test deleting a meal plan."""
    plan = MealPlan(
        user_id=test_user.id,
        goal_id=test_goal.id,
        start_date=date(2026, 1, 10),
        duration_days=1,
        status=PlanStatus.PENDING,
    )
    db.add(plan)
    db.commit()
    plan_id = plan.id

    response = client.delete(f"/api/v1/meal-plans/{plan_id}", headers=auth_headers)
    assert response.status_code == 204

    # Verify it's deleted
    get_response = client.get(f"/api/v1/meal-plans/{plan_id}", headers=auth_headers)
    assert get_response.status_code == 404


def test_meal_plans_unauthorized(client: TestClient):
    """Test accessing meal plans without authentication."""
    response = client.get("/api/v1/meal-plans")
    assert response.status_code == 403
