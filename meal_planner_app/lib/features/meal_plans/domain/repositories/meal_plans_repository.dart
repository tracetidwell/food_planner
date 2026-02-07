import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/grocery_list.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/meal_plan.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/planned_meal.dart';

/// Repository interface for meal plan operations
abstract class MealPlansRepository {
  /// Generate a new meal plan
  Future<Either<Failure, MealPlan>> generateMealPlan({
    required DateTime startDate,
    required int durationDays,
  });

  /// Get list of user's meal plans
  Future<Either<Failure, List<MealPlan>>> getMealPlans({
    int skip = 0,
    int limit = 20,
  });

  /// Get a specific meal plan by ID with all meals
  Future<Either<Failure, MealPlan>> getMealPlanById(String id);

  /// Accept a meal plan (triggers grocery list generation)
  Future<Either<Failure, void>> acceptMealPlan(String id);

  /// Regenerate a specific meal within a plan
  Future<Either<Failure, PlannedMeal>> regenerateMeal({
    required String mealPlanId,
    required String plannedMealId,
  });

  /// Delete a meal plan
  Future<Either<Failure, void>> deleteMealPlan(String id);

  /// Get grocery list for an accepted meal plan
  Future<Either<Failure, GroceryList>> getGroceryList(String mealPlanId);
}
