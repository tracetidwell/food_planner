import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/goals/domain/entities/nutrition_goal.dart';
import 'package:meal_planner_app/features/goals/domain/repositories/goals_repository.dart';

/// Use case for getting active nutrition goal
class GetGoalsUseCase {
  final GoalsRepository repository;

  GetGoalsUseCase(this.repository);

  Future<Either<Failure, NutritionGoal>> call() async {
    return await repository.getGoals();
  }
}
