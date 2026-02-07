// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NutritionGoalModelImpl _$$NutritionGoalModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionGoalModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      macroFormat: $enumDecode(_$MacroFormatEnumMap, json['macro_format']),
      proteinTarget: (json['protein_target'] as num).toDouble(),
      carbTarget: (json['carb_target'] as num).toDouble(),
      fatTarget: (json['fat_target'] as num).toDouble(),
      calorieTarget: (json['daily_calories'] as num).toInt(),
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$NutritionGoalModelImplToJson(
        _$NutritionGoalModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'macro_format': _$MacroFormatEnumMap[instance.macroFormat]!,
      'protein_target': instance.proteinTarget,
      'carb_target': instance.carbTarget,
      'fat_target': instance.fatTarget,
      'daily_calories': instance.calorieTarget,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$MacroFormatEnumMap = {
  MacroFormat.percentage: 'percentage',
  MacroFormat.absolute: 'absolute',
};
