import 'package:dio/dio.dart';
import 'package:meal_planner_app/features/profile/data/models/user_profile_model.dart';

/// Remote data source for user profile
class ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSource(this._dio);

  /// Get user profile
  Future<UserProfileModel> getProfile() async {
    final response = await _dio.get('/api/v1/profile');
    return UserProfileModel.fromJson(response.data);
  }

  /// Update user profile
  Future<UserProfileModel> updateProfile(Map<String, dynamic> body) async {
    final response = await _dio.put('/api/v1/profile', data: body);
    return UserProfileModel.fromJson(response.data);
  }

  /// Set custom OpenAI API key
  Future<void> setApiKey(String apiKey) async {
    await _dio.post(
      '/api/v1/profile/api-key',
      data: {'api_key': apiKey},
    );
  }

  /// Delete custom OpenAI API key
  Future<void> deleteApiKey() async {
    await _dio.delete('/api/v1/profile/api-key');
  }
}
