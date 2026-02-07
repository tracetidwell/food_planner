import 'package:dartz/dartz.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/features/auth/domain/repositories/auth_repository.dart';

/// Use case for logging out the current user
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  /// Execute logout
  ///
  /// Clears authentication token and user data
  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
