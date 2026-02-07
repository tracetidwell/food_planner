// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planned_meal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlannedMealModel _$PlannedMealModelFromJson(Map<String, dynamic> json) {
  return _PlannedMealModel.fromJson(json);
}

/// @nodoc
mixin _$PlannedMealModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'meal_plan_id')
  String get mealPlanId => throw _privateConstructorUsedError;
  @JsonKey(name: 'day_index')
  int get dayIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'meal_type')
  String get mealType => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<FoodModel> get foods => throw _privateConstructorUsedError;
  @JsonKey(name: 'protein_grams')
  double get proteinGrams => throw _privateConstructorUsedError;
  @JsonKey(name: 'carb_grams')
  double get carbGrams => throw _privateConstructorUsedError;
  @JsonKey(name: 'fat_grams')
  double get fatGrams => throw _privateConstructorUsedError;
  int get calories => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlannedMealModelCopyWith<PlannedMealModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlannedMealModelCopyWith<$Res> {
  factory $PlannedMealModelCopyWith(
          PlannedMealModel value, $Res Function(PlannedMealModel) then) =
      _$PlannedMealModelCopyWithImpl<$Res, PlannedMealModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'meal_plan_id') String mealPlanId,
      @JsonKey(name: 'day_index') int dayIndex,
      @JsonKey(name: 'meal_type') String mealType,
      String name,
      List<FoodModel> foods,
      @JsonKey(name: 'protein_grams') double proteinGrams,
      @JsonKey(name: 'carb_grams') double carbGrams,
      @JsonKey(name: 'fat_grams') double fatGrams,
      int calories});
}

/// @nodoc
class _$PlannedMealModelCopyWithImpl<$Res, $Val extends PlannedMealModel>
    implements $PlannedMealModelCopyWith<$Res> {
  _$PlannedMealModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mealPlanId = null,
    Object? dayIndex = null,
    Object? mealType = null,
    Object? name = null,
    Object? foods = null,
    Object? proteinGrams = null,
    Object? carbGrams = null,
    Object? fatGrams = null,
    Object? calories = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mealPlanId: null == mealPlanId
          ? _value.mealPlanId
          : mealPlanId // ignore: cast_nullable_to_non_nullable
              as String,
      dayIndex: null == dayIndex
          ? _value.dayIndex
          : dayIndex // ignore: cast_nullable_to_non_nullable
              as int,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      foods: null == foods
          ? _value.foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodModel>,
      proteinGrams: null == proteinGrams
          ? _value.proteinGrams
          : proteinGrams // ignore: cast_nullable_to_non_nullable
              as double,
      carbGrams: null == carbGrams
          ? _value.carbGrams
          : carbGrams // ignore: cast_nullable_to_non_nullable
              as double,
      fatGrams: null == fatGrams
          ? _value.fatGrams
          : fatGrams // ignore: cast_nullable_to_non_nullable
              as double,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlannedMealModelImplCopyWith<$Res>
    implements $PlannedMealModelCopyWith<$Res> {
  factory _$$PlannedMealModelImplCopyWith(_$PlannedMealModelImpl value,
          $Res Function(_$PlannedMealModelImpl) then) =
      __$$PlannedMealModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'meal_plan_id') String mealPlanId,
      @JsonKey(name: 'day_index') int dayIndex,
      @JsonKey(name: 'meal_type') String mealType,
      String name,
      List<FoodModel> foods,
      @JsonKey(name: 'protein_grams') double proteinGrams,
      @JsonKey(name: 'carb_grams') double carbGrams,
      @JsonKey(name: 'fat_grams') double fatGrams,
      int calories});
}

/// @nodoc
class __$$PlannedMealModelImplCopyWithImpl<$Res>
    extends _$PlannedMealModelCopyWithImpl<$Res, _$PlannedMealModelImpl>
    implements _$$PlannedMealModelImplCopyWith<$Res> {
  __$$PlannedMealModelImplCopyWithImpl(_$PlannedMealModelImpl _value,
      $Res Function(_$PlannedMealModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mealPlanId = null,
    Object? dayIndex = null,
    Object? mealType = null,
    Object? name = null,
    Object? foods = null,
    Object? proteinGrams = null,
    Object? carbGrams = null,
    Object? fatGrams = null,
    Object? calories = null,
  }) {
    return _then(_$PlannedMealModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mealPlanId: null == mealPlanId
          ? _value.mealPlanId
          : mealPlanId // ignore: cast_nullable_to_non_nullable
              as String,
      dayIndex: null == dayIndex
          ? _value.dayIndex
          : dayIndex // ignore: cast_nullable_to_non_nullable
              as int,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      foods: null == foods
          ? _value._foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodModel>,
      proteinGrams: null == proteinGrams
          ? _value.proteinGrams
          : proteinGrams // ignore: cast_nullable_to_non_nullable
              as double,
      carbGrams: null == carbGrams
          ? _value.carbGrams
          : carbGrams // ignore: cast_nullable_to_non_nullable
              as double,
      fatGrams: null == fatGrams
          ? _value.fatGrams
          : fatGrams // ignore: cast_nullable_to_non_nullable
              as double,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlannedMealModelImpl extends _PlannedMealModel {
  const _$PlannedMealModelImpl(
      {required this.id,
      @JsonKey(name: 'meal_plan_id') required this.mealPlanId,
      @JsonKey(name: 'day_index') required this.dayIndex,
      @JsonKey(name: 'meal_type') required this.mealType,
      required this.name,
      required final List<FoodModel> foods,
      @JsonKey(name: 'protein_grams') required this.proteinGrams,
      @JsonKey(name: 'carb_grams') required this.carbGrams,
      @JsonKey(name: 'fat_grams') required this.fatGrams,
      required this.calories})
      : _foods = foods,
        super._();

  factory _$PlannedMealModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlannedMealModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'meal_plan_id')
  final String mealPlanId;
  @override
  @JsonKey(name: 'day_index')
  final int dayIndex;
  @override
  @JsonKey(name: 'meal_type')
  final String mealType;
  @override
  final String name;
  final List<FoodModel> _foods;
  @override
  List<FoodModel> get foods {
    if (_foods is EqualUnmodifiableListView) return _foods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foods);
  }

  @override
  @JsonKey(name: 'protein_grams')
  final double proteinGrams;
  @override
  @JsonKey(name: 'carb_grams')
  final double carbGrams;
  @override
  @JsonKey(name: 'fat_grams')
  final double fatGrams;
  @override
  final int calories;

  @override
  String toString() {
    return 'PlannedMealModel(id: $id, mealPlanId: $mealPlanId, dayIndex: $dayIndex, mealType: $mealType, name: $name, foods: $foods, proteinGrams: $proteinGrams, carbGrams: $carbGrams, fatGrams: $fatGrams, calories: $calories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlannedMealModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mealPlanId, mealPlanId) ||
                other.mealPlanId == mealPlanId) &&
            (identical(other.dayIndex, dayIndex) ||
                other.dayIndex == dayIndex) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._foods, _foods) &&
            (identical(other.proteinGrams, proteinGrams) ||
                other.proteinGrams == proteinGrams) &&
            (identical(other.carbGrams, carbGrams) ||
                other.carbGrams == carbGrams) &&
            (identical(other.fatGrams, fatGrams) ||
                other.fatGrams == fatGrams) &&
            (identical(other.calories, calories) ||
                other.calories == calories));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      mealPlanId,
      dayIndex,
      mealType,
      name,
      const DeepCollectionEquality().hash(_foods),
      proteinGrams,
      carbGrams,
      fatGrams,
      calories);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlannedMealModelImplCopyWith<_$PlannedMealModelImpl> get copyWith =>
      __$$PlannedMealModelImplCopyWithImpl<_$PlannedMealModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlannedMealModelImplToJson(
      this,
    );
  }
}

abstract class _PlannedMealModel extends PlannedMealModel {
  const factory _PlannedMealModel(
      {required final String id,
      @JsonKey(name: 'meal_plan_id') required final String mealPlanId,
      @JsonKey(name: 'day_index') required final int dayIndex,
      @JsonKey(name: 'meal_type') required final String mealType,
      required final String name,
      required final List<FoodModel> foods,
      @JsonKey(name: 'protein_grams') required final double proteinGrams,
      @JsonKey(name: 'carb_grams') required final double carbGrams,
      @JsonKey(name: 'fat_grams') required final double fatGrams,
      required final int calories}) = _$PlannedMealModelImpl;
  const _PlannedMealModel._() : super._();

  factory _PlannedMealModel.fromJson(Map<String, dynamic> json) =
      _$PlannedMealModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'meal_plan_id')
  String get mealPlanId;
  @override
  @JsonKey(name: 'day_index')
  int get dayIndex;
  @override
  @JsonKey(name: 'meal_type')
  String get mealType;
  @override
  String get name;
  @override
  List<FoodModel> get foods;
  @override
  @JsonKey(name: 'protein_grams')
  double get proteinGrams;
  @override
  @JsonKey(name: 'carb_grams')
  double get carbGrams;
  @override
  @JsonKey(name: 'fat_grams')
  double get fatGrams;
  @override
  int get calories;
  @override
  @JsonKey(ignore: true)
  _$$PlannedMealModelImplCopyWith<_$PlannedMealModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
