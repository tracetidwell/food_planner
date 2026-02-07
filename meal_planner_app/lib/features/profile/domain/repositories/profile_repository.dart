import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/profile/domain/entities/user_profile.dart';

/// Repository interface for user profile
abstract class ProfileRepository {
  /// Get user profile
  Future<Either<Failure, UserProfile>> getProfile();

  /// Update user profile
  Future<Either<Failure, UserProfile>> updateProfile({
    String? foodPreferences,
    int? mealsPerDay,
    int? snacksPerDay,
  });

  /// Set custom OpenAI API key
  Future<Either<Failure, void>> setApiKey(String apiKey);

  /// Delete custom OpenAI API key
  Future<Either<Failure, void>> deleteApiKey();
}
