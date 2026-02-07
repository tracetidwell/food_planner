import 'package:equatable/equatable.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/food.dart';

/// Planned meal entity
class PlannedMeal extends Equatable {
  final String id;
  final String mealPlanId;
  final int dayIndex;
  final String mealType;
  final String name;
  final String? description;
  final List<Food> foods;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime createdAt;

  const PlannedMeal({
    required this.id,
    required this.mealPlanId,
    required this.dayIndex,
    required this.mealType,
    required this.name,
    this.description,
    required this.foods,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        mealPlanId,
        dayIndex,
        mealType,
        name,
        description,
        foods,
        calories,
        protein,
        carbs,
        fat,
        createdAt,
      ];

  @override
  String toString() => 'PlannedMeal(id: $id, name: $name, day: $dayIndex, type: $mealType)';
}
