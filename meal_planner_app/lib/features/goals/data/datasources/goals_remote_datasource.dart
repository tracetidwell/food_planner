import 'package:dio/dio.dart';
import 'package:meal_planner_app/features/goals/data/models/nutrition_goal_model.dart';
import 'package:meal_planner_app/features/goals/data/models/tdee_request_model.dart';
import 'package:meal_planner_app/features/goals/data/models/tdee_response_model.dart';

/// Remote data source for nutrition goals
class GoalsRemoteDataSource {
  final Dio _dio;

  GoalsRemoteDataSource(this._dio);

  /// Get active nutrition goal
  Future<NutritionGoalModel> getGoals() async {
    final response = await _dio.get('/api/v1/goals');
    return NutritionGoalModel.fromJson(response.data);
  }

  /// Create or update nutrition goal
  Future<NutritionGoalModel> createGoal(Map<String, dynamic> body) async {
    final response = await _dio.post('/api/v1/goals', data: body);
    return NutritionGoalModel.fromJson(response.data);
  }

  /// Calculate TDEE
  Future<TdeeResponseModel> calculateTdee(TdeeRequestModel request) async {
    final response = await _dio.post(
      '/api/v1/goals/calculate-tdee',
      data: request.toJson(),
    );
    return TdeeResponseModel.fromJson(response.data);
  }
}
