// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodModelImpl _$$FoodModelImplFromJson(Map<String, dynamic> json) =>
    _$FoodModelImpl(
      food: json['food'] as String,
      quantityGrams: (json['quantity_grams'] as num?)?.toDouble(),
      quantity: json['quantity'] as String?,
    );

Map<String, dynamic> _$$FoodModelImplToJson(_$FoodModelImpl instance) =>
    <String, dynamic>{
      'food': instance.food,
      'quantity_grams': instance.quantityGrams,
      'quantity': instance.quantity,
    };
