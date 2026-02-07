import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meal_planner_app/core/constants/enums.dart';
import 'package:meal_planner_app/features/goals/domain/entities/nutrition_goal.dart';

part 'nutrition_goal_model.freezed.dart';
part 'nutrition_goal_model.g.dart';

/// Model for nutrition goal data from API
@freezed
class NutritionGoalModel with _$NutritionGoalModel {
  const NutritionGoalModel._();

  const factory NutritionGoalModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'macro_format') required MacroFormat macroFormat,
    @JsonKey(name: 'protein_target') required double proteinTarget,
    @JsonKey(name: 'carb_target') required double carbTarget,
    @JsonKey(name: 'fat_target') required double fatTarget,
    @JsonKey(name: 'daily_calories') required int calorieTarget,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _NutritionGoalModel;

  factory NutritionGoalModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionGoalModelFromJson(json);

  /// Convert model to entity
  NutritionGoal toEntity() {
    return NutritionGoal(
      id: id,
      userId: userId,
      macroFormat: macroFormat,
      proteinTarget: proteinTarget,
      carbTarget: carbTarget,
      fatTarget: fatTarget,
      calorieTarget: calorieTarget,
      isActive: isActive,
      createdAt: createdAt,
    );
  }
}
