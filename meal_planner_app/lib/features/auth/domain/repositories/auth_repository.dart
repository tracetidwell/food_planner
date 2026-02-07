import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/auth/domain/entities/user.dart';

/// Repository interface for authentication
abstract class AuthRepository {
  /// Register a new user
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
  });

  /// Login with email and password
  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  });

  /// Get current authenticated user
  Future<Either<Failure, User>> getCurrentUser();

  /// Logout the current user
  Future<Either<Failure, void>> logout();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
