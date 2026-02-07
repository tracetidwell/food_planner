import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meal_planner_app/core/constants/enums.dart';
import 'package:meal_planner_app/features/meal_plans/data/models/planned_meal_model.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/meal_plan.dart';

part 'meal_plan_model.freezed.dart';
part 'meal_plan_model.g.dart';

/// Data model for meal plans
@freezed
class MealPlanModel with _$MealPlanModel {
  const MealPlanModel._();

  const factory MealPlanModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'goal_id') String? goalId,
    @JsonKey(name: 'start_date') required String startDate,
    @JsonKey(name: 'duration_days') required int durationDays,
    required PlanStatus status,
    @JsonKey(name: 'generated_at') required DateTime generatedAt,
    @JsonKey(name: 'accepted_at') DateTime? acceptedAt,
    @JsonKey(name: 'planned_meals') List<PlannedMealModel>? plannedMeals,
  }) = _MealPlanModel;

  factory MealPlanModel.fromJson(Map<String, dynamic> json) =>
      _$MealPlanModelFromJson(json);

  /// Convert model to domain entity
  MealPlan toEntity() {
    final start = DateTime.parse(startDate);
    final end = start.add(Duration(days: durationDays - 1));

    return MealPlan(
      id: id,
      userId: userId,
      goalId: goalId ?? '',
      startDate: start,
      endDate: end,
      status: status,
      meals: plannedMeals?.map((m) => m.toEntity()).toList(),
      createdAt: generatedAt,
    );
  }
}

/// Extension to convert entity to model
extension MealPlanEntityX on MealPlan {
  MealPlanModel toModel() {
    return MealPlanModel(
      id: id,
      userId: userId,
      goalId: goalId,
      startDate: startDate.toIso8601String().split('T')[0], // YYYY-MM-DD
      durationDays: durationInDays,
      status: status,
      generatedAt: createdAt,
      acceptedAt: null,
      plannedMeals: meals?.map((m) => m.toModel()).toList(),
    );
  }
}
