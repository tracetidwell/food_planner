import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/auth/domain/entities/user.dart';
import 'package:meal_planner_app/features/auth/domain/repositories/auth_repository.dart';

/// Use case for registering a new user
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  /// Execute registration
  ///
  /// Returns User entity on success
  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) async {
    // Validate inputs
    if (email.isEmpty) {
      return const Left(ValidationFailure('Email is required'));
    }
    if (password.isEmpty) {
      return const Left(ValidationFailure('Password is required'));
    }
    if (password.length < 8) {
      return const Left(
        ValidationFailure('Password must be at least 8 characters'),
      );
    }

    return await repository.register(email: email, password: password);
  }
}
