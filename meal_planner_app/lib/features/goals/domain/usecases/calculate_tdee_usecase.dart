import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/constants/enums.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/goals/domain/entities/tdee_result.dart';
import 'package:meal_planner_app/features/goals/domain/repositories/goals_repository.dart';

/// Use case for calculating TDEE
class CalculateTdeeUseCase {
  final GoalsRepository repository;

  CalculateTdeeUseCase(this.repository);

  Future<Either<Failure, TdeeResult>> call({
    required int age,
    required double weightKg,
    required double heightCm,
    required Gender gender,
    required ActivityLevel activityLevel,
    required GoalType goal,
  }) async {
    // Validate inputs
    if (age <= 0 || age > 120) {
      return const Left(ValidationFailure('Please enter a valid age (1-120)'));
    }
    if (weightKg <= 0 || weightKg > 500) {
      return const Left(ValidationFailure('Please enter a valid weight (1-500 kg)'));
    }
    if (heightCm <= 0 || heightCm > 300) {
      return const Left(ValidationFailure('Please enter a valid height (1-300 cm)'));
    }

    return await repository.calculateTdee(
      age: age,
      weightKg: weightKg,
      heightCm: heightCm,
      gender: gender,
      activityLevel: activityLevel,
      goal: goal,
    );
  }
}
