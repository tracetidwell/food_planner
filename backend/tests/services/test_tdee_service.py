"""
Tests for TDEE calculation service.
"""
import pytest
from app.services.tdee_service import TDEEService


def test_calculate_bmr_male():
    """Test BMR calculation for male."""
    bmr = TDEEService.calculate_bmr(
        age=30, weight_kg=80, height_cm=180, gender="male"
    )
    # Expected: 10*80 + 6.25*180 - 5*30 + 5 = 800 + 1125 - 150 + 5 = 1780
    assert bmr == 1780


def test_calculate_bmr_female():
    """Test BMR calculation for female."""
    bmr = TDEEService.calculate_bmr(
        age=28, weight_kg=60, height_cm=165, gender="female"
    )
    # Expected: 10*60 + 6.25*165 - 5*28 - 161 = 600 + 1031.25 - 140 - 161 = 1330.25 -> 1330
    assert bmr == 1330


def test_calculate_tdee_sedentary():
    """Test TDEE calculation for sedentary activity level."""
    bmr = 1500
    tdee = TDEEService.calculate_tdee(bmr=bmr, activity_level="sedentary")
    # Expected: 1500 * 1.2 = 1800
    assert tdee == 1800


def test_calculate_tdee_very_active():
    """Test TDEE calculation for very active level."""
    bmr = 1800
    tdee = TDEEService.calculate_tdee(bmr=bmr, activity_level="very_active")
    # Expected: 1800 * 1.725 = 3105
    assert tdee == 3105


def test_calculate_recommended_calories_cutting():
    """Test recommended calories for cutting goal."""
    tdee = 2000
    recommended = TDEEService.calculate_recommended_calories(tdee=tdee, goal="cutting")
    # Expected: 2000 - 500 = 1500
    assert recommended == 1500


def test_calculate_recommended_calories_maintenance():
    """Test recommended calories for maintenance goal."""
    tdee = 2200
    recommended = TDEEService.calculate_recommended_calories(
        tdee=tdee, goal="maintenance"
    )
    # Expected: 2200 + 0 = 2200
    assert recommended == 2200


def test_calculate_recommended_calories_bulking():
    """Test recommended calories for bulking goal."""
    tdee = 2500
    recommended = TDEEService.calculate_recommended_calories(tdee=tdee, goal="bulking")
    # Expected: 2500 + 500 = 3000
    assert recommended == 3000


def test_calculate_full():
    """Test full TDEE calculation."""
    result = TDEEService.calculate_full(
        age=25,
        weight_kg=70,
        height_cm=175,
        gender="male",
        activity_level="moderately_active",
        goal="cutting",
    )

    assert "bmr" in result
    assert "tdee" in result
    assert "recommended_calories" in result
    assert result["bmr"] > 0
    assert result["tdee"] > result["bmr"]
    assert result["recommended_calories"] == result["tdee"] - 500
    assert result["activity_level"] == "moderately_active"
    assert result["goal"] == "cutting"


def test_all_activity_levels():
    """Test that all activity levels are supported."""
    bmr = 1500
    activity_levels = [
        "sedentary",
        "lightly_active",
        "moderately_active",
        "very_active",
        "extra_active",
    ]

    for level in activity_levels:
        tdee = TDEEService.calculate_tdee(bmr=bmr, activity_level=level)
        assert tdee > bmr  # TDEE should always be higher than BMR
        assert tdee <= bmr * 2  # Sanity check


def test_all_goals():
    """Test that all goal types are supported."""
    tdee = 2000
    goals = ["cutting", "maintenance", "bulking"]

    for goal in goals:
        recommended = TDEEService.calculate_recommended_calories(tdee=tdee, goal=goal)
        assert recommended > 0
        if goal == "cutting":
            assert recommended < tdee
        elif goal == "maintenance":
            assert recommended == tdee
        elif goal == "bulking":
            assert recommended > tdee
