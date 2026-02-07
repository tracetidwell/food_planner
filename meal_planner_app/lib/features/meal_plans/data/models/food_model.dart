import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/food.dart';

part 'food_model.freezed.dart';
part 'food_model.g.dart';

/// Data model for food items
@freezed
class FoodModel with _$FoodModel {
  const FoodModel._();

  const factory FoodModel({
    required String food,
    @JsonKey(name: 'quantity_grams') double? quantityGrams,
    String? quantity,
  }) = _FoodModel;

  factory FoodModel.fromJson(Map<String, dynamic> json) =>
      _$FoodModelFromJson(json);

  /// Convert model to domain entity
  Food toEntity() {
    // If quantity string is provided, parse it for quantity and unit
    if (quantity != null && quantity!.isNotEmpty) {
      // Try to extract number and unit from quantity string
      // Examples: "2 eggs", "1 large", "6 oz", "1 cup"
      final parts = quantity!.trim().split(' ');
      if (parts.isNotEmpty) {
        final firstPart = parts[0];
        final numericValue = double.tryParse(firstPart);

        if (numericValue != null) {
          // First part is a number, rest is the unit
          final unitPart = parts.skip(1).join(' ');
          return Food(
            name: food,
            quantity: numericValue,
            unit: unitPart.isEmpty ? 'item' : unitPart,
            calories: 0,
            protein: 0,
            carbs: 0,
            fat: 0,
          );
        }
      }
      // If we can't parse it, just use the whole string as the unit
      return Food(
        name: food,
        quantity: 1,
        unit: quantity!,
        calories: 0,
        protein: 0,
        carbs: 0,
        fat: 0,
      );
    }

    // Fall back to quantity_grams
    return Food(
      name: food,
      quantity: quantityGrams ?? 0,
      unit: 'g',
      calories: 0, // Will be calculated from meal totals
      protein: 0,
      carbs: 0,
      fat: 0,
    );
  }
}

/// Extension to convert entity to model
extension FoodEntityX on Food {
  FoodModel toModel() {
    return FoodModel(
      food: name,
      quantityGrams: quantity,
    );
  }
}
