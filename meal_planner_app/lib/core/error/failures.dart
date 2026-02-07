import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure from server/API
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure due to network connectivity
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Failure due to cache/local storage
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Failure due to validation
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Failure due to authentication
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

/// Failure due to authorization
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized access']);
}

/// Failure when resource not found
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Failure due to timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timed out']);
}

/// Unknown/unexpected failure
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}
