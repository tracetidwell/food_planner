import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meal_planner_app/features/goals/domain/entities/tdee_result.dart';

part 'tdee_response_model.freezed.dart';
part 'tdee_response_model.g.dart';

/// Model for TDEE calculation response from API
@freezed
class TdeeResponseModel with _$TdeeResponseModel {
  const TdeeResponseModel._();

  const factory TdeeResponseModel({
    required int bmr,
    required int tdee,
    @JsonKey(name: 'recommended_calories') required int recommendedCalories,
    @JsonKey(name: 'activity_level') required String activityLevel,
    required String goal,
  }) = _TdeeResponseModel;

  factory TdeeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TdeeResponseModelFromJson(json);

  /// Convert model to entity
  TdeeResult toEntity() {
    return TdeeResult(
      tdee: tdee,
      recommendedCalories: recommendedCalories,
      maintenanceCalories: tdee, // TDEE is the maintenance calories
    );
  }
}
