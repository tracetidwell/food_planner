import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/meal_plan.dart';
import 'package:meal_planner_app/features/meal_plans/domain/repositories/meal_plans_repository.dart';

/// Use case for retrieving list of meal plans
class GetMealPlansUseCase {
  final MealPlansRepository repository;

  GetMealPlansUseCase(this.repository);

  Future<Either<Failure, List<MealPlan>>> call({
    int skip = 0,
    int limit = 20,
  }) async {
    // Validation
    if (skip < 0) {
      return const Left(ValidationFailure('Skip must be non-negative'));
    }

    if (limit <= 0) {
      return const Left(ValidationFailure('Limit must be positive'));
    }

    return await repository.getMealPlans(skip: skip, limit: limit);
  }
}
