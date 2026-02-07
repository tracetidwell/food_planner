import 'package:freezed_annotation/freezed_annotation.dart';

part 'regenerate_meal_request.freezed.dart';
part 'regenerate_meal_request.g.dart';

/// Request model for regenerating a meal
@freezed
class RegenerateMealRequest with _$RegenerateMealRequest {
  const factory RegenerateMealRequest({
    @JsonKey(name: 'planned_meal_id') required String plannedMealId,
  }) = _RegenerateMealRequest;

  factory RegenerateMealRequest.fromJson(Map<String, dynamic> json) =>
      _$RegenerateMealRequestFromJson(json);
}
