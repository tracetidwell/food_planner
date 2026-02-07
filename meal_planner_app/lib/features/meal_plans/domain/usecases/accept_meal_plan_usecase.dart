import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/meal_plans/domain/repositories/meal_plans_repository.dart';

/// Use case for accepting a meal plan
class AcceptMealPlanUseCase {
  final MealPlansRepository repository;

  AcceptMealPlanUseCase(this.repository);

  Future<Either<Failure, void>> call(String mealPlanId) async {
    // Validation
    if (mealPlanId.isEmpty) {
      return const Left(ValidationFailure('Meal plan ID is required'));
    }

    return await repository.acceptMealPlan(mealPlanId);
  }
}
