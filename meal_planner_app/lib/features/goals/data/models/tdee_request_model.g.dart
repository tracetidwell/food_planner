// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tdee_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TdeeRequestModelImpl _$$TdeeRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TdeeRequestModelImpl(
      age: (json['age'] as num).toInt(),
      weightKg: (json['weight_kg'] as num).toDouble(),
      heightCm: (json['height_cm'] as num).toDouble(),
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      activityLevel:
          $enumDecode(_$ActivityLevelEnumMap, json['activity_level']),
      goal: $enumDecode(_$GoalTypeEnumMap, json['goal']),
    );

Map<String, dynamic> _$$TdeeRequestModelImplToJson(
        _$TdeeRequestModelImpl instance) =>
    <String, dynamic>{
      'age': instance.age,
      'weight_kg': instance.weightKg,
      'height_cm': instance.heightCm,
      'gender': _$GenderEnumMap[instance.gender]!,
      'activity_level': _$ActivityLevelEnumMap[instance.activityLevel]!,
      'goal': _$GoalTypeEnumMap[instance.goal]!,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
};

const _$ActivityLevelEnumMap = {
  ActivityLevel.sedentary: 'sedentary',
  ActivityLevel.lightlyActive: 'lightly_active',
  ActivityLevel.moderatelyActive: 'moderately_active',
  ActivityLevel.veryActive: 'very_active',
  ActivityLevel.extraActive: 'extra_active',
};

const _$GoalTypeEnumMap = {
  GoalType.loseWeight: 'lose_weight',
  GoalType.maintain: 'maintain',
  GoalType.gainWeight: 'gain_weight',
};
