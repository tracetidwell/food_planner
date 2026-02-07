import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/goals/domain/repositories/goals_repository.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/meal_plan.dart';
import 'package:meal_planner_app/features/meal_plans/domain/repositories/meal_plans_repository.dart';

/// Use case for generating a new meal plan
class GenerateMealPlanUseCase {
  final MealPlansRepository mealPlansRepository;
  final GoalsRepository goalsRepository;

  GenerateMealPlanUseCase(
    this.mealPlansRepository,
    this.goalsRepository,
  );

  Future<Either<Failure, MealPlan>> call({
    required DateTime startDate,
    required int durationDays,
  }) async {
    // Validation: start date not in the past
    final today = DateTime.now();
    final startDateOnly = DateTime(startDate.year, startDate.month, startDate.day);
    final todayOnly = DateTime(today.year, today.month, today.day);

    if (startDateOnly.isBefore(todayOnly)) {
      return const Left(ValidationFailure('Start date cannot be in the past'));
    }

    // Validation: duration between 1-14 days
    if (durationDays < 1 || durationDays > 14) {
      return const Left(ValidationFailure('Duration must be between 1 and 14 days'));
    }

    // Check if user has an active nutrition goal
    final goalResult = await goalsRepository.getGoals();

    final hasGoal = goalResult.fold(
      (failure) => false,
      (goal) => true,
    );

    if (!hasGoal) {
      return const Left(ValidationFailure('Please set a nutrition goal before generating a meal plan'));
    }

    // All validations passed, generate the meal plan
    return await mealPlansRepository.generateMealPlan(
      startDate: startDate,
      durationDays: durationDays,
    );
  }
}
