import 'package:equatable/equatable.dart';

/// Food item entity
class Food extends Equatable {
  final String name;
  final double quantity;
  final String unit;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  const Food({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  List<Object> get props => [name, quantity, unit, calories, protein, carbs, fat];

  @override
  String toString() => 'Food(name: $name, $quantity $unit, $calories kcal)';
}
