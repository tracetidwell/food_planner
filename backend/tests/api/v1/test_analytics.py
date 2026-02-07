"""
Tests for analytics endpoints.
"""
import pytest
from datetime import date
from fastapi.testclient import TestClient

from app.models.goal import NutritionGoal
from app.models.meal_plan import MealPlan, PlannedMeal
from app.models.log import MealLog
from app.core.constants import MacroFormat, PlanStatus, MealType, LogStatus


@pytest.fixture
def plan_with_logs(db, test_user):
    """Create meal plan with logged meals for testing analytics."""
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
        duration_days=1,
        status=PlanStatus.ACCEPTED,
    )
    db.add(plan)
    db.flush()

    # Create meals
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
        foods=[{"food": "Chicken", "quantity_grams": 200}],
        protein_grams=40.0,
        carb_grams=10.0,
        fat_grams=8.0,
        calories=272,
    )
    db.add_all([meal1, meal2])
    db.flush()

    # Log meals as eaten
    log1 = MealLog(
        user_id=test_user.id,
        planned_meal_id=meal1.id,
        log_date=date.today(),
        status=LogStatus.EATEN,
    )
    log2 = MealLog(
        user_id=test_user.id,
        planned_meal_id=meal2.id,
        log_date=date.today(),
        status=LogStatus.EATEN,
    )
    db.add_all([log1, log2])
    db.commit()

    return plan, [meal1, meal2]


def test_get_daily_totals(client: TestClient, auth_headers, plan_with_logs):
    """Test getting daily totals."""
    today = date.today()
    response = client.get(
        f"/api/v1/analytics/daily/{today}", headers=auth_headers
    )
    assert response.status_code == 200
    data = response.json()
    assert data["date"] == str(today)
    assert data["protein_grams"] == 50.0  # 10 + 40
    assert data["carb_grams"] == 60.0  # 50 + 10
    assert data["fat_grams"] == 13.0  # 5 + 8
    assert data["calories"] == 562  # 290 + 272
    assert data["meals_logged"] == 2


def test_get_daily_totals_no_logs(client: TestClient, auth_headers):
    """Test getting daily totals when no logs exist."""
    today = date.today()
    response = client.get(
        f"/api/v1/analytics/daily/{today}", headers=auth_headers
    )
    assert response.status_code == 200
    data = response.json()
    assert data["protein_grams"] == 0.0
    assert data["calories"] == 0
    assert data["meals_logged"] == 0


def test_get_summary_stats(client: TestClient, auth_headers, plan_with_logs):
    """Test getting summary statistics."""
    response = client.get("/api/v1/analytics/summary", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()

    # Check structure
    assert "seven_day_summary" in data
    assert "thirty_day_summary" in data
    assert "logging_consistency_percentage" in data

    # Check 7-day summary
    seven_day = data["seven_day_summary"]
    assert "avg_daily_calories" in seven_day
    assert "days_with_logs" in seven_day
    assert seven_day["total_days"] == 7

    # Check 30-day summary
    thirty_day = data["thirty_day_summary"]
    assert thirty_day["total_days"] == 30


def test_get_summary_stats_no_data(client: TestClient, auth_headers):
    """Test getting summary stats with no logged meals."""
    response = client.get("/api/v1/analytics/summary", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()

    seven_day = data["seven_day_summary"]
    assert seven_day["avg_daily_calories"] is None
    assert seven_day["days_with_logs"] == 0


def test_analytics_unauthorized(client: TestClient):
    """Test accessing analytics without authentication."""
    today = date.today()
    response = client.get(f"/api/v1/analytics/daily/{today}")
    assert response.status_code == 403
