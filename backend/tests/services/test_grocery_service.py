"""
Tests for grocery list generation service.
"""
import pytest
from app.services.grocery_service import GroceryService
from app.models.meal_plan import MealPlan, PlannedMeal
from app.models.goal import NutritionGoal
from app.core.constants import MacroFormat, PlanStatus, MealType
from datetime import date


def test_categorize_food_protein():
    """Test food categorization for protein."""
    assert GroceryService.categorize_food("Chicken breast") == "Protein"
    assert GroceryService.categorize_food("Salmon fillet") == "Protein"
    assert GroceryService.categorize_food("Beef steak") == "Protein"


def test_categorize_food_vegetables():
    """Test food categorization for vegetables."""
    assert GroceryService.categorize_food("Broccoli") == "Vegetables"
    assert GroceryService.categorize_food("Spinach leaves") == "Vegetables"
    assert GroceryService.categorize_food("Bell pepper") == "Vegetables"


def test_categorize_food_grains():
    """Test food categorization for grains."""
    assert GroceryService.categorize_food("Brown rice") == "Grains"
    assert GroceryService.categorize_food("Whole wheat pasta") == "Grains"
    assert GroceryService.categorize_food("Oats") == "Grains"


def test_categorize_food_other():
    """Test food categorization for unknown foods."""
    assert GroceryService.categorize_food("Mystery food") == "Other"


def test_generate_grocery_list(db, test_user):
    """Test generating a grocery list from a meal plan."""
    # Create goal and plan
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

    # Add meals with foods
    meal1 = PlannedMeal(
        meal_plan_id=plan.id,
        day_index=0,
        meal_type=MealType.MEAL,
        meal_index=1,
        name="Breakfast",
        foods=[
            {"food": "Chicken breast", "quantity_grams": 200},
            {"food": "Brown rice", "quantity_grams": 150},
        ],
        protein_grams=50.0,
        carb_grams=40.0,
        fat_grams=5.0,
        calories=400,
    )
    meal2 = PlannedMeal(
        meal_plan_id=plan.id,
        day_index=0,
        meal_type=MealType.MEAL,
        meal_index=2,
        name="Lunch",
        foods=[
            {"food": "Chicken breast", "quantity_grams": 150},  # Same as breakfast
            {"food": "Broccoli", "quantity_grams": 100},
        ],
        protein_grams=40.0,
        carb_grams=10.0,
        fat_grams=3.0,
        calories=250,
    )
    db.add_all([meal1, meal2])
    db.commit()
    db.refresh(plan)

    # Generate grocery list
    grocery_list = GroceryService.generate_grocery_list(db, meal_plan=plan)

    assert grocery_list is not None
    assert len(grocery_list.items) == 3  # Chicken (aggregated), rice, broccoli

    # Check that chicken was aggregated
    chicken_items = [
        item for item in grocery_list.items if item["food"] == "Chicken breast"
    ]
    assert len(chicken_items) == 1
    assert chicken_items[0]["total_quantity_grams"] == 350.0  # 200 + 150

    # Check categorization
    for item in grocery_list.items:
        assert "category" in item
        assert item["category"] != ""


def test_generate_grocery_list_empty_plan(db, test_user):
    """Test generating a grocery list from an empty meal plan."""
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
    db.commit()
    db.refresh(plan)

    # Generate grocery list for empty plan
    grocery_list = GroceryService.generate_grocery_list(db, meal_plan=plan)

    assert grocery_list is not None
    assert len(grocery_list.items) == 0


def test_grocery_list_sorting(db, test_user):
    """Test that grocery list items are sorted by category."""
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

    # Add meal with various food categories
    meal = PlannedMeal(
        meal_plan_id=plan.id,
        day_index=0,
        meal_type=MealType.MEAL,
        meal_index=1,
        name="Mixed meal",
        foods=[
            {"food": "Broccoli", "quantity_grams": 100},  # Vegetables
            {"food": "Chicken breast", "quantity_grams": 200},  # Protein
            {"food": "Brown rice", "quantity_grams": 150},  # Grains
            {"food": "Apple", "quantity_grams": 120},  # Fruits
        ],
        protein_grams=50.0,
        carb_grams=60.0,
        fat_grams=5.0,
        calories=500,
    )
    db.add(meal)
    db.commit()
    db.refresh(plan)

    grocery_list = GroceryService.generate_grocery_list(db, meal_plan=plan)

    # Items should be grouped by category
    categories = [item["category"] for item in grocery_list.items]
    # Check that items are sorted (categories should be grouped together)
    assert categories == sorted(categories)
