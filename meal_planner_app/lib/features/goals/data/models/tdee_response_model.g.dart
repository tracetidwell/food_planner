// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tdee_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TdeeResponseModelImpl _$$TdeeResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TdeeResponseModelImpl(
      bmr: (json['bmr'] as num).toInt(),
      tdee: (json['tdee'] as num).toInt(),
      recommendedCalories: (json['recommended_calories'] as num).toInt(),
      activityLevel: json['activity_level'] as String,
      goal: json['goal'] as String,
    );

Map<String, dynamic> _$$TdeeResponseModelImplToJson(
        _$TdeeResponseModelImpl instance) =>
    <String, dynamic>{
      'bmr': instance.bmr,
      'tdee': instance.tdee,
      'recommended_calories': instance.recommendedCalories,
      'activity_level': instance.activityLevel,
      'goal': instance.goal,
    };
