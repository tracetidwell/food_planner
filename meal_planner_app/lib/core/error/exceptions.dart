/// Base class for all custom exceptions
class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  @override
  String toString() => 'AppException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Exception thrown when server returns an error
class ServerException extends AppException {
  const ServerException(super.message, [super.statusCode]);
}

/// Exception thrown when there's no internet connection
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

/// Exception thrown when cache operation fails
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Exception thrown when authentication fails
class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed', super.statusCode]);
}

/// Exception thrown when user is unauthorized
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized access', super.statusCode = 401]);
}

/// Exception thrown when resource is not found
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found', super.statusCode = 404]);
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  const ValidationException(super.message, [super.statusCode = 422]);
}

/// Exception thrown when request times out
class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Request timed out']);
}
