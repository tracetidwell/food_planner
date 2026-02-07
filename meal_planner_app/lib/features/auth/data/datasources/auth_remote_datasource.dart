import 'package:dio/dio.dart';
import 'package:meal_planner_app/features/auth/data/models/token_model.dart';
import 'package:meal_planner_app/features/auth/data/models/user_model.dart';

/// Remote data source for authentication
class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  /// Register a new user
  Future<UserModel> register(Map<String, dynamic> body) async {
    final response = await _dio.post(
      '/api/v1/auth/register',
      data: body,
    );
    return UserModel.fromJson(response.data);
  }

  /// Login with email and password
  Future<TokenModel> login(String email, String password) async {
    final response = await _dio.post(
      '/api/v1/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    return TokenModel.fromJson(response.data);
  }

  /// Get current authenticated user
  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get('/api/v1/auth/me');
    return UserModel.fromJson(response.data);
  }
}
