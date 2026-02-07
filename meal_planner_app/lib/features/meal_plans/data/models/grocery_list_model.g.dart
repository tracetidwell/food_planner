// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroceryItemModelImpl _$$GroceryItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$GroceryItemModelImpl(
      food: json['food'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      category: json['category'] as String,
    );

Map<String, dynamic> _$$GroceryItemModelImplToJson(
        _$GroceryItemModelImpl instance) =>
    <String, dynamic>{
      'food': instance.food,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'category': instance.category,
    };

_$GroceryListModelImpl _$$GroceryListModelImplFromJson(
        Map<String, dynamic> json) =>
    _$GroceryListModelImpl(
      id: json['id'] as String,
      mealPlanId: json['meal_plan_id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => GroceryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      generatedAt: DateTime.parse(json['generated_at'] as String),
    );

Map<String, dynamic> _$$GroceryListModelImplToJson(
        _$GroceryListModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meal_plan_id': instance.mealPlanId,
      'items': instance.items,
      'generated_at': instance.generatedAt.toIso8601String(),
    };
