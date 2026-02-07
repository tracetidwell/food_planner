import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/planned_meal.dart';
import 'package:meal_planner_app/features/meal_plans/domain/repositories/meal_plans_repository.dart';

/// Use case for regenerating a specific meal
class RegenerateMealUseCase {
  final MealPlansRepository repository;

  RegenerateMealUseCase(this.repository);

  Future<Either<Failure, PlannedMeal>> call({
    required String mealPlanId,
    required String plannedMealId,
  }) async {
    // Validation
    if (mealPlanId.isEmpty) {
      return const Left(ValidationFailure('Meal plan ID is required'));
    }

    if (plannedMealId.isEmpty) {
      return const Left(ValidationFailure('Planned meal ID is required'));
    }

    return await repository.regenerateMeal(
      mealPlanId: mealPlanId,
      plannedMealId: plannedMealId,
    );
  }
}
