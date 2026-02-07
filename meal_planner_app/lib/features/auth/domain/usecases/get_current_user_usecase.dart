import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/auth/domain/entities/user.dart';
import 'package:meal_planner_app/features/auth/domain/repositories/auth_repository.dart';

/// Use case for getting the current authenticated user
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  /// Execute get current user
  ///
  /// Returns User entity on success
  Future<Either<Failure, User>> call() async {
    return await repository.getCurrentUser();
  }
}
