import 'package:dio/dio.dart';
import 'package:meal_planner_app/core/error/exceptions.dart';
import 'package:meal_planner_app/core/error/failures.dart';

/// Utility class to convert DioException to custom exceptions and failures
class NetworkExceptions {
  /// Convert DioException to custom exception
  static AppException dioExceptionToException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        return _handleStatusCode(error);

      case DioExceptionType.cancel:
        return const AppException('Request cancelled');

      case DioExceptionType.unknown:
        if (error.error != null && error.error.toString().contains('SocketException')) {
          return const NetworkException();
        }
        return AppException(error.message ?? 'Unknown error occurred');

      default:
        return AppException(error.message ?? 'Unexpected error occurred');
    }
  }

  /// Convert DioException to Failure
  static Failure dioExceptionToFailure(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        return _handleStatusCodeFailure(error);

      case DioExceptionType.cancel:
        return const ServerFailure('Request cancelled');

      case DioExceptionType.unknown:
        if (error.error != null && error.error.toString().contains('SocketException')) {
          return const NetworkFailure();
        }
        return ServerFailure(error.message ?? 'Unknown error occurred');

      default:
        return ServerFailure(error.message ?? 'Unexpected error occurred');
    }
  }

  /// Handle HTTP status codes and return appropriate exception
  static AppException _handleStatusCode(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    String message = 'Server error occurred';
    if (data is Map && data.containsKey('detail')) {
      message = data['detail'].toString();
    } else if (error.response?.statusMessage != null) {
      message = error.response!.statusMessage!;
    }

    switch (statusCode) {
      case 400:
        return ServerException(message, statusCode);
      case 401:
        return const AuthException();
      case 403:
        return const UnauthorizedException('Forbidden');
      case 404:
        return NotFoundException(message, statusCode);
      case 422:
        return ValidationException(message, statusCode);
      case 500:
      case 502:
      case 503:
        return ServerException('Server error. Please try again later.', statusCode);
      default:
        return ServerException(message, statusCode);
    }
  }

  /// Handle HTTP status codes and return appropriate failure
  static Failure _handleStatusCodeFailure(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    String message = 'Server error occurred';
    if (data is Map && data.containsKey('detail')) {
      message = data['detail'].toString();
    } else if (error.response?.statusMessage != null) {
      message = error.response!.statusMessage!;
    }

    switch (statusCode) {
      case 400:
        return ValidationFailure(message);
      case 401:
        return const AuthFailure();
      case 403:
        return const UnauthorizedFailure('Forbidden');
      case 404:
        return NotFoundFailure(message);
      case 422:
        return ValidationFailure(message);
      case 500:
      case 502:
      case 503:
        return const ServerFailure('Server error. Please try again later.');
      default:
        return ServerFailure(message);
    }
  }
}
