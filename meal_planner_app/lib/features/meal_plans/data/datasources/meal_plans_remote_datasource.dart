import 'package:dio/dio.dart';
import 'package:meal_planner_app/features/meal_plans/data/models/grocery_list_model.dart';
import 'package:meal_planner_app/features/meal_plans/data/models/meal_plan_generate_request.dart';
import 'package:meal_planner_app/features/meal_plans/data/models/meal_plan_model.dart';
import 'package:meal_planner_app/features/meal_plans/data/models/planned_meal_model.dart';
import 'package:meal_planner_app/features/meal_plans/data/models/regenerate_meal_request.dart';

/// Remote data source for meal plan operations
class MealPlansRemoteDataSource {
  final Dio _dio;

  MealPlansRemoteDataSource(this._dio);

  /// Generate a new meal plan
  Future<MealPlanModel> generateMealPlan(
    MealPlanGenerateRequest request,
  ) async {
    final response = await _dio.post(
      '/api/v1/meal-plans/generate',
      data: request.toJson(),
      options: Options(receiveTimeout: const Duration(seconds: 180)),
    );
    return MealPlanModel.fromJson(response.data);
  }

  /// Get list of user's meal plans
  Future<List<MealPlanModel>> getMealPlans({
    required int skip,
    required int limit,
  }) async {
    final response = await _dio.get(
      '/api/v1/meal-plans',
      queryParameters: {'skip': skip, 'limit': limit},
    );
    return (response.data as List)
        .map((json) => MealPlanModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get a specific meal plan by ID
  Future<MealPlanModel> getMealPlanById(String id) async {
    final response = await _dio.get('/api/v1/meal-plans/$id');
    return MealPlanModel.fromJson(response.data);
  }

  /// Accept a meal plan (triggers grocery list generation)
  Future<void> acceptMealPlan(String id) async {
    await _dio.post('/api/v1/meal-plans/$id/accept');
  }

  /// Regenerate a specific meal within a plan
  Future<PlannedMealModel> regenerateMeal({
    required String mealPlanId,
    required RegenerateMealRequest request,
  }) async {
    final response = await _dio.post(
      '/api/v1/meal-plans/$mealPlanId/regenerate-meal',
      data: request.toJson(),
      options: Options(receiveTimeout: const Duration(seconds: 120)),
    );
    return PlannedMealModel.fromJson(response.data);
  }

  /// Delete a meal plan
  Future<void> deleteMealPlan(String id) async {
    await _dio.delete('/api/v1/meal-plans/$id');
  }

  /// Get grocery list for a meal plan
  Future<GroceryListModel> getGroceryList(String mealPlanId) async {
    final response = await _dio.get('/api/v1/meal-plans/$mealPlanId/grocery-list');
    return GroceryListModel.fromJson(response.data);
  }
}
