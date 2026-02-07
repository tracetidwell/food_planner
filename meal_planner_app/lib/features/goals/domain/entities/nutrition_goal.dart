import 'package:equatable/equatable.dart';
import 'package:meal_planner_app/core/constants/enums.dart';

/// Nutrition goal entity
class NutritionGoal extends Equatable {
  final String id;
  final String userId;
  final MacroFormat macroFormat;
  final double proteinTarget;
  final double carbTarget;
  final double fatTarget;
  final int calorieTarget;
  final bool isActive;
  final DateTime createdAt;

  const NutritionGoal({
    required this.id,
    required this.userId,
    required this.macroFormat,
    required this.proteinTarget,
    required this.carbTarget,
    required this.fatTarget,
    required this.calorieTarget,
    required this.isActive,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
        id,
        userId,
        macroFormat,
        proteinTarget,
        carbTarget,
        fatTarget,
        calorieTarget,
        isActive,
        createdAt,
      ];

  @override
  String toString() => 'NutritionGoal(id: $id, calories: $calorieTarget, format: $macroFormat)';
}
