// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileModelImpl(
      userId: json['user_id'] as String,
      foodPreferences: json['food_preferences'] as String?,
      mealsPerDay: (json['meals_per_day'] as num?)?.toInt(),
      snacksPerDay: (json['snacks_per_day'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$UserProfileModelImplToJson(
        _$UserProfileModelImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'food_preferences': instance.foodPreferences,
      'meals_per_day': instance.mealsPerDay,
      'snacks_per_day': instance.snacksPerDay,
    };
