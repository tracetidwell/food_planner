"""
Meal plan generation and management service.
"""
from datetime import datetime
from typing import Optional, List
from sqlalchemy.orm import Session

from app.models.meal_plan import MealPlan, PlannedMeal
from app.models.goal import NutritionGoal
from app.models.user import UserProfile
from app.services.openai_service import OpenAIService
from app.crud.goal import goal as goal_crud
from app.crud.meal_plan import planned_meal as planned_meal_crud
from app.core.constants import PlanStatus, MealType, MacroFormat
from app.core.exceptions import ActiveGoalNotFound, OpenAIAPIError


class MealPlanService:
    """Service for meal plan operations."""

    @staticmethod
    def _validate_meal_plan(
        meal_plan_data: dict,
        daily_calories_target: int,
        meals_per_day: int,
        snacks_per_day: int,
        duration_days: int,
    ) -> List[str]:
        """
        Validate a meal plan meets requirements.
        Returns list of validation errors (empty if valid).
        """
        errors = []

        # Calorie tolerance: ±5%
        min_calories = int(daily_calories_target * 0.95)
        max_calories = int(daily_calories_target * 1.05)

        days = meal_plan_data.get("days", [])

        # Check correct number of days
        if len(days) != duration_days:
            errors.append(f"Expected {duration_days} days, got {len(days)}")

        # Validate each day
        for day_data in days:
            day_num = day_data.get("day", "?")
            meals = day_data.get("meals", [])

            # Count meal types
            meal_count = sum(1 for m in meals if m.get("type") == "meal")
            snack_count = sum(1 for m in meals if m.get("type") == "snack")

            # Check meal/snack counts
            if meal_count != meals_per_day:
                errors.append(
                    f"Day {day_num}: Expected {meals_per_day} meals, got {meal_count}"
                )
            if snack_count != snacks_per_day:
                errors.append(
                    f"Day {day_num}: Expected {snacks_per_day} snacks, got {snack_count}"
                )

            # Calculate daily calories from macros (more accurate than OpenAI's calorie field)
            # Protein: 4 cal/g, Carbs: 4 cal/g, Fat: 9 cal/g
            daily_calories = 0
            for m in meals:
                protein = m.get("protein_grams", 0)
                carbs = m.get("carb_grams", 0)
                fat = m.get("fat_grams", 0)
                calculated_cals = int(protein * 4 + carbs * 4 + fat * 9)
                daily_calories += calculated_cals

            # Check calorie target
            if daily_calories < min_calories:
                errors.append(
                    f"Day {day_num}: Calories too low ({daily_calories} < {min_calories})"
                )
            elif daily_calories > max_calories:
                errors.append(
                    f"Day {day_num}: Calories too high ({daily_calories} > {max_calories})"
                )

        return errors

    @staticmethod
    def generate_meal_plan(
        db: Session,
        *,
        user_id: str,
        start_date,
        duration_days: int,
        custom_api_key: Optional[str] = None
    ) -> MealPlan:
        """
        Generate a new meal plan for a user.

        Uses user's active goal and preferences to generate the plan via OpenAI.
        """
        # Get user's active goal
        active_goal = goal_crud.get_active_goal(db, user_id=user_id)
        if not active_goal:
            raise ActiveGoalNotFound("No active nutrition goal found")

        # Get user profile for preferences
        profile = db.query(UserProfile).filter(UserProfile.user_id == user_id).first()
        if not profile:
            raise ValueError("User profile not found")

        # Convert macros to grams if needed
        if active_goal.macro_format == MacroFormat.PERCENTAGE:
            protein_grams, carb_grams, fat_grams = goal_crud.convert_macros_to_grams(
                daily_calories=active_goal.daily_calories,
                protein=active_goal.protein_target,
                carbs=active_goal.carb_target,
                fat=active_goal.fat_target,
                format=MacroFormat.PERCENTAGE,
            )
        else:
            protein_grams = active_goal.protein_target
            carb_grams = active_goal.carb_target
            fat_grams = active_goal.fat_target

        # Initialize OpenAI service
        openai_service = OpenAIService(api_key=custom_api_key)

        # Try to generate a valid meal plan (with retries)
        max_attempts = 3
        meal_plan_data = None
        validation_errors = []

        for attempt in range(1, max_attempts + 1):
            print(f"[INFO] Generating meal plan (attempt {attempt}/{max_attempts})")

            # Generate meal plan via OpenAI
            # On retry attempts, pass the previous response and validation errors
            meal_plan_data = openai_service.generate_meal_plan(
                daily_calories=active_goal.daily_calories,
                protein_grams=protein_grams,
                carb_grams=carb_grams,
                fat_grams=fat_grams,
                meals_per_day=profile.meals_per_day,
                snacks_per_day=profile.snacks_per_day,
                food_preferences=profile.food_preferences or "",
                duration_days=duration_days,
                previous_attempt=meal_plan_data if attempt > 1 else None,
                validation_errors=validation_errors if attempt > 1 else None,
            )

            # Validate the meal plan
            validation_errors = MealPlanService._validate_meal_plan(
                meal_plan_data=meal_plan_data,
                daily_calories_target=active_goal.daily_calories,
                meals_per_day=profile.meals_per_day,
                snacks_per_day=profile.snacks_per_day,
                duration_days=duration_days,
            )

            if not validation_errors:
                print(f"[INFO] Meal plan validation passed on attempt {attempt}")
                break
            else:
                print(f"[WARNING] Attempt {attempt} failed validation: {'; '.join(validation_errors)}")
                if attempt < max_attempts:
                    print(f"[INFO] Retrying...")

        # If still invalid after all attempts, raise error
        if validation_errors:
            error_msg = f"Failed to generate valid meal plan after {max_attempts} attempts. Last errors: " + "; ".join(validation_errors)
            raise ValueError(error_msg)

        # Create meal plan in database
        db_plan = MealPlan(
            user_id=user_id,
            goal_id=active_goal.id,
            start_date=start_date,
            duration_days=duration_days,
            status=PlanStatus.PENDING,
        )
        db.add(db_plan)
        db.flush()

        # Create planned meals
        for day_data in meal_plan_data.get("days", []):
            day_index = day_data["day"] - 1  # Convert to 0-based

            for meal_data in day_data.get("meals", []):
                meal_type = MealType.MEAL if meal_data["type"] == "meal" else MealType.SNACK

                # Calculate calories from macros (4 cal/g for protein and carbs, 9 cal/g for fat)
                protein = meal_data["protein_grams"]
                carbs = meal_data["carb_grams"]
                fat = meal_data["fat_grams"]
                calculated_calories = int(protein * 4 + carbs * 4 + fat * 9)

                db_meal = PlannedMeal(
                    meal_plan_id=db_plan.id,
                    day_index=day_index,
                    meal_type=meal_type,
                    meal_index=meal_data["index"],
                    name=meal_data["name"],
                    foods=meal_data["foods"],
                    protein_grams=protein,
                    carb_grams=carbs,
                    fat_grams=fat,
                    calories=calculated_calories,
                )
                db.add(db_meal)

        db.commit()
        db.refresh(db_plan)
        return db_plan

    @staticmethod
    def regenerate_meal(
        db: Session,
        *,
        meal_id: str,
        user_id: str,
        custom_api_key: Optional[str] = None
    ) -> PlannedMeal:
        """
        Regenerate a single meal in a meal plan.
        """
        # Get the existing meal
        existing_meal = planned_meal_crud.get_meal(db, meal_id=meal_id)
        if not existing_meal:
            raise ValueError("Meal not found")

        # Get user profile for preferences
        profile = db.query(UserProfile).filter(UserProfile.user_id == user_id).first()

        # Get the meal plan to get the goal
        meal_plan = db.query(MealPlan).filter(MealPlan.id == existing_meal.meal_plan_id).first()
        active_goal = db.query(NutritionGoal).filter(NutritionGoal.id == meal_plan.goal_id).first()

        # Calculate target macros for this meal (divide daily by number of meals)
        total_items = profile.meals_per_day + profile.snacks_per_day
        target_calories = active_goal.daily_calories // total_items

        if active_goal.macro_format == MacroFormat.PERCENTAGE:
            protein_grams, carb_grams, fat_grams = goal_crud.convert_macros_to_grams(
                daily_calories=active_goal.daily_calories,
                protein=active_goal.protein_target,
                carbs=active_goal.carb_target,
                fat=active_goal.fat_target,
                format=MacroFormat.PERCENTAGE,
            )
        else:
            protein_grams = active_goal.protein_target
            carb_grams = active_goal.carb_target
            fat_grams = active_goal.fat_target

        target_protein = protein_grams / total_items
        target_carbs = carb_grams / total_items
        target_fat = fat_grams / total_items

        # Initialize OpenAI service
        openai_service = OpenAIService(api_key=custom_api_key)

        # Regenerate meal
        meal_data = openai_service.regenerate_single_meal(
            meal_type=existing_meal.meal_type.value,
            meal_index=existing_meal.meal_index,
            daily_calories=active_goal.daily_calories,
            target_protein=target_protein,
            target_carbs=target_carbs,
            target_fat=target_fat,
            target_calories=target_calories,
            food_preferences=profile.food_preferences or "",
        )

        # Calculate calories from macros (4 cal/g for protein and carbs, 9 cal/g for fat)
        protein = meal_data["protein_grams"]
        carbs = meal_data["carb_grams"]
        fat = meal_data["fat_grams"]
        calculated_calories = int(protein * 4 + carbs * 4 + fat * 9)

        # Update the meal
        existing_meal.name = meal_data["name"]
        existing_meal.foods = meal_data["foods"]
        existing_meal.protein_grams = protein
        existing_meal.carb_grams = carbs
        existing_meal.fat_grams = fat
        existing_meal.calories = calculated_calories

        db.commit()
        db.refresh(existing_meal)
        return existing_meal


meal_plan_service = MealPlanService()
