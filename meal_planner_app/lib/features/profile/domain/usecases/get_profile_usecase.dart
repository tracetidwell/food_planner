import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/profile/domain/entities/user_profile.dart';
import 'package:meal_planner_app/features/profile/domain/repositories/profile_repository.dart';

/// Use case for getting user profile
class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> call() async {
    return await repository.getProfile();
  }
}
