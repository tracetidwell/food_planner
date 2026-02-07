import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/profile/domain/entities/user_profile.dart';
import 'package:meal_planner_app/features/profile/domain/repositories/profile_repository.dart';

/// Use case for updating user profile
class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> call({
    String? foodPreferences,
    int? mealsPerDay,
    int? snacksPerDay,
  }) async {
    return await repository.updateProfile(
      foodPreferences: foodPreferences,
      mealsPerDay: mealsPerDay,
      snacksPerDay: snacksPerDay,
    );
  }
}
