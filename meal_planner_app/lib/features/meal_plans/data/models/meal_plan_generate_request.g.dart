// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_generate_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealPlanGenerateRequestImpl _$$MealPlanGenerateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$MealPlanGenerateRequestImpl(
      startDate: json['start_date'] as String,
      durationDays: (json['duration_days'] as num).toInt(),
    );

Map<String, dynamic> _$$MealPlanGenerateRequestImplToJson(
        _$MealPlanGenerateRequestImpl instance) =>
    <String, dynamic>{
      'start_date': instance.startDate,
      'duration_days': instance.durationDays,
    };
