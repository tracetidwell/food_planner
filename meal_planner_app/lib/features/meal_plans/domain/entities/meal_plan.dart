import 'package:equatable/equatable.dart';
import 'package:meal_planner_app/core/constants/enums.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/planned_meal.dart';

/// Meal plan entity
class MealPlan extends Equatable {
  final String id;
  final String userId;
  final String goalId;
  final DateTime startDate;
  final DateTime endDate;
  final PlanStatus status;
  final List<PlannedMeal>? meals;
  final DateTime createdAt;

  const MealPlan({
    required this.id,
    required this.userId,
    required this.goalId,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.meals,
    required this.createdAt,
  });

  int get durationInDays => endDate.difference(startDate).inDays + 1;

  bool get isPending => status == PlanStatus.pending;
  bool get isAccepted => status == PlanStatus.accepted;
  bool get isArchived => status == PlanStatus.archived;

  @override
  List<Object?> get props => [
        id,
        userId,
        goalId,
        startDate,
        endDate,
        status,
        meals,
        createdAt,
      ];

  @override
  String toString() => 'MealPlan(id: $id, duration: $durationInDays days, status: $status)';
}
