// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealPlanModelImpl _$$MealPlanModelImplFromJson(Map<String, dynamic> json) =>
    _$MealPlanModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      goalId: json['goal_id'] as String?,
      startDate: json['start_date'] as String,
      durationDays: (json['duration_days'] as num).toInt(),
      status: $enumDecode(_$PlanStatusEnumMap, json['status']),
      generatedAt: DateTime.parse(json['generated_at'] as String),
      acceptedAt: json['accepted_at'] == null
          ? null
          : DateTime.parse(json['accepted_at'] as String),
      plannedMeals: (json['planned_meals'] as List<dynamic>?)
          ?.map((e) => PlannedMealModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MealPlanModelImplToJson(_$MealPlanModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'goal_id': instance.goalId,
      'start_date': instance.startDate,
      'duration_days': instance.durationDays,
      'status': _$PlanStatusEnumMap[instance.status]!,
      'generated_at': instance.generatedAt.toIso8601String(),
      'accepted_at': instance.acceptedAt?.toIso8601String(),
      'planned_meals': instance.plannedMeals,
    };

const _$PlanStatusEnumMap = {
  PlanStatus.pending: 'pending',
  PlanStatus.accepted: 'accepted',
  PlanStatus.archived: 'archived',
};
