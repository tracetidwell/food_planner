import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meal_planner_app/features/meal_plans/data/models/food_model.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/planned_meal.dart';

part 'planned_meal_model.freezed.dart';
part 'planned_meal_model.g.dart';

/// Data model for planned meals
@freezed
class PlannedMealModel with _$PlannedMealModel {
  const PlannedMealModel._();

  const factory PlannedMealModel({
    required String id,
    @JsonKey(name: 'meal_plan_id') required String mealPlanId,
    @JsonKey(name: 'day_index') required int dayIndex,
    @JsonKey(name: 'meal_type') required String mealType,
    required String name,
    required List<FoodModel> foods,
    @JsonKey(name: 'protein_grams') required double proteinGrams,
    @JsonKey(name: 'carb_grams') required double carbGrams,
    @JsonKey(name: 'fat_grams') required double fatGrams,
    required int calories,
  }) = _PlannedMealModel;

  factory PlannedMealModel.fromJson(Map<String, dynamic> json) =>
      _$PlannedMealModelFromJson(json);

  /// Convert model to domain entity
  PlannedMeal toEntity() {
    return PlannedMeal(
      id: id,
      mealPlanId: mealPlanId,
      dayIndex: dayIndex,
      mealType: mealType,
      name: name,
      description: null,
      foods: foods.map((f) => f.toEntity()).toList(),
      calories: calories,
      protein: proteinGrams,
      carbs: carbGrams,
      fat: fatGrams,
      createdAt: DateTime.now(), // Backend doesn't return this
    );
  }
}

/// Extension to convert entity to model
extension PlannedMealEntityX on PlannedMeal {
  PlannedMealModel toModel() {
    return PlannedMealModel(
      id: id,
      mealPlanId: mealPlanId,
      dayIndex: dayIndex,
      mealType: mealType,
      name: name,
      foods: foods.map((f) => f.toModel()).toList(),
      proteinGrams: protein,
      carbGrams: carbs,
      fatGrams: fat,
      calories: calories,
    );
  }
}
