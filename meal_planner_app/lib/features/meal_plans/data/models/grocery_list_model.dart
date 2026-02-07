import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/grocery_list.dart';

part 'grocery_list_model.freezed.dart';
part 'grocery_list_model.g.dart';

/// Data model for grocery list items
@freezed
class GroceryItemModel with _$GroceryItemModel {
  const GroceryItemModel._();

  const factory GroceryItemModel({
    required String food,
    required double quantity,
    required String unit,
    required String category,
  }) = _GroceryItemModel;

  factory GroceryItemModel.fromJson(Map<String, dynamic> json) =>
      _$GroceryItemModelFromJson(json);

  /// Convert model to domain entity
  GroceryItem toEntity() {
    return GroceryItem(
      name: food,
      quantity: quantity,
      unit: unit,
      category: category,
    );
  }
}

/// Data model for grocery lists
@freezed
class GroceryListModel with _$GroceryListModel {
  const GroceryListModel._();

  const factory GroceryListModel({
    required String id,
    @JsonKey(name: 'meal_plan_id') required String mealPlanId,
    required List<GroceryItemModel> items,
    @JsonKey(name: 'generated_at') required DateTime generatedAt,
  }) = _GroceryListModel;

  factory GroceryListModel.fromJson(Map<String, dynamic> json) =>
      _$GroceryListModelFromJson(json);

  /// Convert model to domain entity
  GroceryList toEntity() {
    return GroceryList(
      id: id,
      mealPlanId: mealPlanId,
      items: items.map((i) => i.toEntity()).toList(),
      generatedAt: generatedAt,
    );
  }
}

/// Extension to convert entity to model
extension GroceryItemEntityX on GroceryItem {
  GroceryItemModel toModel() {
    return GroceryItemModel(
      food: name,
      quantity: quantity,
      unit: unit,
      category: category,
    );
  }
}

extension GroceryListEntityX on GroceryList {
  GroceryListModel toModel() {
    return GroceryListModel(
      id: id,
      mealPlanId: mealPlanId,
      items: items.map((i) => i.toModel()).toList(),
      generatedAt: generatedAt,
    );
  }
}
