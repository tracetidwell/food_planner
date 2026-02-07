import 'package:equatable/equatable.dart';

/// Grocery list item
class GroceryItem extends Equatable {
  final String name;
  final double quantity;
  final String unit;
  final String category;

  const GroceryItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
  });

  @override
  List<Object> get props => [name, quantity, unit, category];

  @override
  String toString() => 'GroceryItem($name: $quantity $unit)';
}

/// Grocery list entity
class GroceryList extends Equatable {
  final String id;
  final String mealPlanId;
  final List<GroceryItem> items;
  final DateTime generatedAt;

  const GroceryList({
    required this.id,
    required this.mealPlanId,
    required this.items,
    required this.generatedAt,
  });

  Map<String, List<GroceryItem>> get itemsByCategory {
    final Map<String, List<GroceryItem>> categorized = {};
    for (final item in items) {
      categorized.putIfAbsent(item.category, () => []).add(item);
    }
    return categorized;
  }

  @override
  List<Object> get props => [id, mealPlanId, items, generatedAt];

  @override
  String toString() => 'GroceryList(id: $id, items: ${items.length})';
}
