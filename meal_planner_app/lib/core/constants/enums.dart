import 'package:json_annotation/json_annotation.dart';

/// Macro format for nutrition goals
enum MacroFormat {
  @JsonValue('percentage')
  percentage,

  @JsonValue('absolute')
  absolute,
}

/// Meal plan status
enum PlanStatus {
  @JsonValue('pending')
  pending,

  @JsonValue('accepted')
  accepted,

  @JsonValue('archived')
  archived,
}

/// Meal log status
enum LogStatus {
  @JsonValue('eaten')
  eaten,

  @JsonValue('skipped')
  skipped,
}

/// Type of meal
enum MealType {
  @JsonValue('meal')
  meal,

  @JsonValue('snack')
  snack,
}

/// Gender for TDEE calculation
enum Gender {
  @JsonValue('male')
  male,

  @JsonValue('female')
  female,
}

/// Activity level for TDEE calculation
enum ActivityLevel {
  @JsonValue('sedentary')
  sedentary,

  @JsonValue('lightly_active')
  lightlyActive,

  @JsonValue('moderately_active')
  moderatelyActive,

  @JsonValue('very_active')
  veryActive,

  @JsonValue('extra_active')
  extraActive,
}

/// Goal type for TDEE calculation
enum GoalType {
  @JsonValue('lose_weight')
  loseWeight,

  @JsonValue('maintain')
  maintain,

  @JsonValue('gain_weight')
  gainWeight,
}

/// Extension to get display names for enums
extension ActivityLevelExtension on ActivityLevel {
  String get displayName {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Sedentary';
      case ActivityLevel.lightlyActive:
        return 'Lightly Active';
      case ActivityLevel.moderatelyActive:
        return 'Moderately Active';
      case ActivityLevel.veryActive:
        return 'Very Active';
      case ActivityLevel.extraActive:
        return 'Extra Active';
    }
  }

  String get description {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Little or no exercise';
      case ActivityLevel.lightlyActive:
        return 'Exercise 1-3 times/week';
      case ActivityLevel.moderatelyActive:
        return 'Exercise 4-5 times/week';
      case ActivityLevel.veryActive:
        return 'Daily exercise or intense 3-4 times/week';
      case ActivityLevel.extraActive:
        return 'Intense exercise 6-7 times/week';
    }
  }
}

extension GoalTypeExtension on GoalType {
  String get displayName {
    switch (this) {
      case GoalType.loseWeight:
        return 'Lose Weight';
      case GoalType.maintain:
        return 'Maintain Weight';
      case GoalType.gainWeight:
        return 'Gain Weight';
    }
  }
}
