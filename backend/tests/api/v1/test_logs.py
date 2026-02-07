"""
Tests for meal logging endpoints.
"""
import pytest
from datetime import date
from fastapi.testclient import TestClient

from app.models.goal import NutritionGoal
from app.models.meal_plan import MealPlan, PlannedMeal
from app.models.log import MealLog
from app.core.constants import MacroFormat, PlanStatus, MealType, LogStatus


@pytest.fixture
def accepted_plan_with_meals(db, test_user):
    """Create an accepted meal plan with meals for testing."""
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
    db.flush()

    plan = MealPlan(
        user_id=test_user.id,
        goal_id=goal.id,
        start_date=date.today(),
        duration_days=3,
        status=PlanStatus.ACCEPTED,
    )
    db.add(plan)
    db.flush()

    # Add meals for today (day_index=0)
    meal1 = PlannedMeal(
        meal_plan_id=plan.id,
        day_index=0,
        meal_type=MealType.MEAL,
        meal_index=1,
        name="Breakfast",
        foods=[{"food": "Oatmeal", "quantity_grams": 100}],
        protein_grams=10.0,
        carb_grams=50.0,
        fat_grams=5.0,
        calories=290,
    )
    meal2 = PlannedMeal(
        meal_plan_id=plan.id,
        day_index=0,
        meal_type=MealType.MEAL,
        meal_index=2,
        name="Lunch",
        foods=[{"food": "Chicken salad", "quantity_grams": 300}],
        protein_grams=40.0,
        carb_grams=20.0,
        fat_grams=15.0,
        calories=380,
    )
    db.add_all([meal1, meal2])
    db.commit()

    return plan, [meal1, meal2]


def test_get_today_meals(client: TestClient, auth_headers, accepted_plan_with_meals):
    """Test getting today's meals."""
    response = client.get("/api/v1/logs/today", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["date"] == str(date.today())
    assert len(data["meals"]) == 2
    assert data["meals"][0]["log"] is None  # Not logged yet


def test_get_today_meals_no_plan(client: TestClient, auth_headers):
    """Test getting today's meals when no active plan exists."""
    response = client.get("/api/v1/logs/today", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert len(data["meals"]) == 0


def test_log_meal_eaten(client: TestClient, auth_headers, accepted_plan_with_meals):
    """Test logging a meal as eaten."""
    plan, meals = accepted_plan_with_meals
    meal_id = meals[0].id

    response = client.post(
        "/api/v1/logs",
        headers=auth_headers,
        json={"planned_meal_id": meal_id, "status": "eaten"},
    )
    assert response.status_code == 201
    data = response.json()
    assert data["planned_meal_id"] == meal_id
    assert data["status"] == "eaten"
    assert data["log_date"] == str(date.today())


def test_log_meal_skipped(client: TestClient, auth_headers, accepted_plan_with_meals):
    """Test logging a meal as skipped."""
    plan, meals = accepted_plan_with_meals
    meal_id = meals[1].id

    response = client.post(
        "/api/v1/logs",
        headers=auth_headers,
        json={"planned_meal_id": meal_id, "status": "skipped"},
    )
    assert response.status_code == 201
    data = response.json()
    assert data["status"] == "skipped"


def test_log_meal_update_existing(client: TestClient, auth_headers, accepted_plan_with_meals):
    """Test updating an existing log."""
    plan, meals = accepted_plan_with_meals
    meal_id = meals[0].id

    # Log as eaten first
    client.post(
        "/api/v1/logs",
        headers=auth_headers,
        json={"planned_meal_id": meal_id, "status": "eaten"},
    )

    # Update to skipped
    response = client.post(
        "/api/v1/logs",
        headers=auth_headers,
        json={"planned_meal_id": meal_id, "status": "skipped"},
    )
    assert response.status_code == 201
    data = response.json()
    assert data["status"] == "skipped"


def test_log_meal_not_found(client: TestClient, auth_headers):
    """Test logging a non-existent meal."""
    response = client.post(
        "/api/v1/logs",
        headers=auth_headers,
        json={"planned_meal_id": "nonexistent-id", "status": "eaten"},
    )
    assert response.status_code == 404


def test_get_date_meals(client: TestClient, auth_headers, accepted_plan_with_meals):
    """Test getting meals for a specific date."""
    target_date = date.today()
    response = client.get(
        f"/api/v1/logs/date/{target_date}", headers=auth_headers
    )
    assert response.status_code == 200
    data = response.json()
    assert data["date"] == str(target_date)
    assert len(data["meals"]) == 2


def test_get_logs_range(client: TestClient, auth_headers, accepted_plan_with_meals, db):
    """Test getting logs for a date range."""
    plan, meals = accepted_plan_with_meals

    # Log a meal
    log = MealLog(
        user_id=accepted_plan_with_meals[0].user_id,
        planned_meal_id=meals[0].id,
        log_date=date.today(),
        status=LogStatus.EATEN,
    )
    db.add(log)
    db.commit()

    start_date = date.today()
    end_date = date.today()

    response = client.get(
        f"/api/v1/logs/range?start_date={start_date}&end_date={end_date}",
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert len(data) >= 1


def test_get_logs_range_too_long(client: TestClient, auth_headers):
    """Test getting logs for too long a range fails."""
    from datetime import timedelta

    start_date = date.today()
    end_date = start_date + timedelta(days=100)

    response = client.get(
        f"/api/v1/logs/range?start_date={start_date}&end_date={end_date}",
        headers=auth_headers,
    )
    assert response.status_code == 400


def test_logs_unauthorized(client: TestClient):
    """Test accessing logs without authentication."""
    response = client.get("/api/v1/logs/today")
    assert response.status_code == 403
