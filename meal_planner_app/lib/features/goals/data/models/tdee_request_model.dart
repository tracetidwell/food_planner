import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meal_planner_app/core/constants/enums.dart';

part 'tdee_request_model.freezed.dart';
part 'tdee_request_model.g.dart';

/// Model for TDEE calculation request
@freezed
class TdeeRequestModel with _$TdeeRequestModel {
  const factory TdeeRequestModel({
    required int age,
    @JsonKey(name: 'weight_kg') required double weightKg,
    @JsonKey(name: 'height_cm') required double heightCm,
    required Gender gender,
    @JsonKey(name: 'activity_level') required ActivityLevel activityLevel,
    required GoalType goal,
  }) = _TdeeRequestModel;

  factory TdeeRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TdeeRequestModelFromJson(json);
}
