import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/constants/enums.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/goals/domain/entities/nutrition_goal.dart';
import 'package:meal_planner_app/features/goals/domain/entities/tdee_result.dart';

/// Repository interface for nutrition goals
abstract class GoalsRepository {
  /// Get active nutrition goal
  Future<Either<Failure, NutritionGoal>> getGoals();

  /// Create or update nutrition goal
  Future<Either<Failure, NutritionGoal>> createGoal({
    required MacroFormat macroFormat,
    required double proteinTarget,
    required double carbTarget,
    required double fatTarget,
    required int calorieTarget,
  });

  /// Calculate TDEE
  Future<Either<Failure, TdeeResult>> calculateTdee({
    required int age,
    required double weightKg,
    required double heightCm,
    required Gender gender,
    required ActivityLevel activityLevel,
    required GoalType goal,
  });
}
