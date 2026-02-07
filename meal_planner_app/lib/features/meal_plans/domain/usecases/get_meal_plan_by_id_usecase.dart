import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/meal_plan.dart';
import 'package:meal_planner_app/features/meal_plans/domain/repositories/meal_plans_repository.dart';

/// Use case for retrieving a single meal plan by ID
class GetMealPlanByIdUseCase {
  final MealPlansRepository repository;

  GetMealPlanByIdUseCase(this.repository);

  Future<Either<Failure, MealPlan>> call(String id) async {
    // Validation
    if (id.isEmpty) {
      return const Left(ValidationFailure('Meal plan ID is required'));
    }

    return await repository.getMealPlanById(id);
  }
}
