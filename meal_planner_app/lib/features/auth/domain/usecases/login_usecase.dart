import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/auth/domain/repositories/auth_repository.dart';

/// Use case for logging in a user
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Execute login
  ///
  /// Returns JWT token on success
  Future<Either<Failure, String>> call({
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

    return await repository.login(email: email, password: password);
  }
}
