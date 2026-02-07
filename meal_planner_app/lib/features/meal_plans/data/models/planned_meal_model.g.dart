// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planned_meal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlannedMealModelImpl _$$PlannedMealModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PlannedMealModelImpl(
      id: json['id'] as String,
      mealPlanId: json['meal_plan_id'] as String,
      dayIndex: (json['day_index'] as num).toInt(),
      mealType: json['meal_type'] as String,
      name: json['name'] as String,
      foods: (json['foods'] as List<dynamic>)
          .map((e) => FoodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      proteinGrams: (json['protein_grams'] as num).toDouble(),
      carbGrams: (json['carb_grams'] as num).toDouble(),
      fatGrams: (json['fat_grams'] as num).toDouble(),
      calories: (json['calories'] as num).toInt(),
    );

Map<String, dynamic> _$$PlannedMealModelImplToJson(
        _$PlannedMealModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meal_plan_id': instance.mealPlanId,
      'day_index': instance.dayIndex,
      'meal_type': instance.mealType,
      'name': instance.name,
      'foods': instance.foods,
      'protein_grams': instance.proteinGrams,
      'carb_grams': instance.carbGrams,
      'fat_grams': instance.fatGrams,
      'calories': instance.calories,
    };
