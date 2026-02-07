import 'package:dio/dio.dart';
import 'package:meal_planner_app/core/constants/app_constants.dart';
import 'package:meal_planner_app/core/storage/secure_storage.dart';

/// Interceptor that adds JWT authentication to requests
class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;

  AuthInterceptor(this._storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token from secure storage
    final token = await _storage.getToken();

    // Add authorization header if token exists
    if (token != null && token.isNotEmpty) {
      options.headers[AppConstants.authHeaderKey] =
          '${AppConstants.bearerPrefix} $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - token expired
    if (err.response?.statusCode == 401) {
      // Token is invalid or expired
      // The auth provider will handle logout
    }

    handler.next(err);
  }
}
