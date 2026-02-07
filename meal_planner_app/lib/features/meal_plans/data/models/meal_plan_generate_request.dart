import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_plan_generate_request.freezed.dart';
part 'meal_plan_generate_request.g.dart';

/// Request model for generating a meal plan
@freezed
class MealPlanGenerateRequest with _$MealPlanGenerateRequest {
  const factory MealPlanGenerateRequest({
    @JsonKey(name: 'start_date') required String startDate,
    @JsonKey(name: 'duration_days') required int durationDays,
  }) = _MealPlanGenerateRequest;

  factory MealPlanGenerateRequest.fromJson(Map<String, dynamic> json) =>
      _$MealPlanGenerateRequestFromJson(json);
}
