import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/grocery_list.dart';
import 'package:meal_planner_app/features/meal_plans/domain/repositories/meal_plans_repository.dart';

/// Use case for retrieving grocery list for a meal plan
class GetGroceryListUseCase {
  final MealPlansRepository repository;

  GetGroceryListUseCase(this.repository);

  Future<Either<Failure, GroceryList>> call(String mealPlanId) async {
    // Validation
    if (mealPlanId.isEmpty) {
      return const Left(ValidationFailure('Meal plan ID is required'));
    }

    return await repository.getGroceryList(mealPlanId);
  }
}
