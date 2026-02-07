import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/constants/enums.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/goals/domain/entities/nutrition_goal.dart';
import 'package:meal_planner_app/features/goals/domain/repositories/goals_repository.dart';

/// Use case for creating/updating nutrition goal
class CreateGoalUseCase {
  final GoalsRepository repository;

  CreateGoalUseCase(this.repository);

  Future<Either<Failure, NutritionGoal>> call({
    required MacroFormat macroFormat,
    required double proteinTarget,
    required double carbTarget,
    required double fatTarget,
    required int calorieTarget,
  }) async {
    // Validate inputs
    if (calorieTarget <= 0) {
      return const Left(ValidationFailure('Calorie target must be greater than 0'));
    }

    if (macroFormat == MacroFormat.percentage) {
      final total = proteinTarget + carbTarget + fatTarget;
      if ((total - 100).abs() > 0.1) {
        return const Left(ValidationFailure('Macro percentages must add up to 100%'));
      }
    }

    return await repository.createGoal(
      macroFormat: macroFormat,
      proteinTarget: proteinTarget,
      carbTarget: carbTarget,
      fatTarget: fatTarget,
      calorieTarget: calorieTarget,
    );
  }
}
