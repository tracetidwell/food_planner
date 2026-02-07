// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrition_goal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NutritionGoalModel _$NutritionGoalModelFromJson(Map<String, dynamic> json) {
  return _NutritionGoalModel.fromJson(json);
}

/// @nodoc
mixin _$NutritionGoalModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'macro_format')
  MacroFormat get macroFormat => throw _privateConstructorUsedError;
  @JsonKey(name: 'protein_target')
  double get proteinTarget => throw _privateConstructorUsedError;
  @JsonKey(name: 'carb_target')
  double get carbTarget => throw _privateConstructorUsedError;
  @JsonKey(name: 'fat_target')
  double get fatTarget => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_calories')
  int get calorieTarget => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NutritionGoalModelCopyWith<NutritionGoalModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionGoalModelCopyWith<$Res> {
  factory $NutritionGoalModelCopyWith(
          NutritionGoalModel value, $Res Function(NutritionGoalModel) then) =
      _$NutritionGoalModelCopyWithImpl<$Res, NutritionGoalModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'macro_format') MacroFormat macroFormat,
      @JsonKey(name: 'protein_target') double proteinTarget,
      @JsonKey(name: 'carb_target') double carbTarget,
      @JsonKey(name: 'fat_target') double fatTarget,
      @JsonKey(name: 'daily_calories') int calorieTarget,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$NutritionGoalModelCopyWithImpl<$Res, $Val extends NutritionGoalModel>
    implements $NutritionGoalModelCopyWith<$Res> {
  _$NutritionGoalModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? macroFormat = null,
    Object? proteinTarget = null,
    Object? carbTarget = null,
    Object? fatTarget = null,
    Object? calorieTarget = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      macroFormat: null == macroFormat
          ? _value.macroFormat
          : macroFormat // ignore: cast_nullable_to_non_nullable
              as MacroFormat,
      proteinTarget: null == proteinTarget
          ? _value.proteinTarget
          : proteinTarget // ignore: cast_nullable_to_non_nullable
              as double,
      carbTarget: null == carbTarget
          ? _value.carbTarget
          : carbTarget // ignore: cast_nullable_to_non_nullable
              as double,
      fatTarget: null == fatTarget
          ? _value.fatTarget
          : fatTarget // ignore: cast_nullable_to_non_nullable
              as double,
      calorieTarget: null == calorieTarget
          ? _value.calorieTarget
          : calorieTarget // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionGoalModelImplCopyWith<$Res>
    implements $NutritionGoalModelCopyWith<$Res> {
  factory _$$NutritionGoalModelImplCopyWith(_$NutritionGoalModelImpl value,
          $Res Function(_$NutritionGoalModelImpl) then) =
      __$$NutritionGoalModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'macro_format') MacroFormat macroFormat,
      @JsonKey(name: 'protein_target') double proteinTarget,
      @JsonKey(name: 'carb_target') double carbTarget,
      @JsonKey(name: 'fat_target') double fatTarget,
      @JsonKey(name: 'daily_calories') int calorieTarget,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$NutritionGoalModelImplCopyWithImpl<$Res>
    extends _$NutritionGoalModelCopyWithImpl<$Res, _$NutritionGoalModelImpl>
    implements _$$NutritionGoalModelImplCopyWith<$Res> {
  __$$NutritionGoalModelImplCopyWithImpl(_$NutritionGoalModelImpl _value,
      $Res Function(_$NutritionGoalModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? macroFormat = null,
    Object? proteinTarget = null,
    Object? carbTarget = null,
    Object? fatTarget = null,
    Object? calorieTarget = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_$NutritionGoalModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      macroFormat: null == macroFormat
          ? _value.macroFormat
          : macroFormat // ignore: cast_nullable_to_non_nullable
              as MacroFormat,
      proteinTarget: null == proteinTarget
          ? _value.proteinTarget
          : proteinTarget // ignore: cast_nullable_to_non_nullable
              as double,
      carbTarget: null == carbTarget
          ? _value.carbTarget
          : carbTarget // ignore: cast_nullable_to_non_nullable
              as double,
      fatTarget: null == fatTarget
          ? _value.fatTarget
          : fatTarget // ignore: cast_nullable_to_non_nullable
              as double,
      calorieTarget: null == calorieTarget
          ? _value.calorieTarget
          : calorieTarget // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionGoalModelImpl extends _NutritionGoalModel {
  const _$NutritionGoalModelImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'macro_format') required this.macroFormat,
      @JsonKey(name: 'protein_target') required this.proteinTarget,
      @JsonKey(name: 'carb_target') required this.carbTarget,
      @JsonKey(name: 'fat_target') required this.fatTarget,
      @JsonKey(name: 'daily_calories') required this.calorieTarget,
      @JsonKey(name: 'is_active') required this.isActive,
      @JsonKey(name: 'created_at') required this.createdAt})
      : super._();

  factory _$NutritionGoalModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionGoalModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'macro_format')
  final MacroFormat macroFormat;
  @override
  @JsonKey(name: 'protein_target')
  final double proteinTarget;
  @override
  @JsonKey(name: 'carb_target')
  final double carbTarget;
  @override
  @JsonKey(name: 'fat_target')
  final double fatTarget;
  @override
  @JsonKey(name: 'daily_calories')
  final int calorieTarget;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'NutritionGoalModel(id: $id, userId: $userId, macroFormat: $macroFormat, proteinTarget: $proteinTarget, carbTarget: $carbTarget, fatTarget: $fatTarget, calorieTarget: $calorieTarget, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionGoalModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.macroFormat, macroFormat) ||
                other.macroFormat == macroFormat) &&
            (identical(other.proteinTarget, proteinTarget) ||
                other.proteinTarget == proteinTarget) &&
            (identical(other.carbTarget, carbTarget) ||
                other.carbTarget == carbTarget) &&
            (identical(other.fatTarget, fatTarget) ||
                other.fatTarget == fatTarget) &&
            (identical(other.calorieTarget, calorieTarget) ||
                other.calorieTarget == calorieTarget) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, macroFormat,
      proteinTarget, carbTarget, fatTarget, calorieTarget, isActive, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionGoalModelImplCopyWith<_$NutritionGoalModelImpl> get copyWith =>
      __$$NutritionGoalModelImplCopyWithImpl<_$NutritionGoalModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionGoalModelImplToJson(
      this,
    );
  }
}

abstract class _NutritionGoalModel extends NutritionGoalModel {
  const factory _NutritionGoalModel(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'macro_format') required final MacroFormat macroFormat,
          @JsonKey(name: 'protein_target') required final double proteinTarget,
          @JsonKey(name: 'carb_target') required final double carbTarget,
          @JsonKey(name: 'fat_target') required final double fatTarget,
          @JsonKey(name: 'daily_calories') required final int calorieTarget,
          @JsonKey(name: 'is_active') required final bool isActive,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$NutritionGoalModelImpl;
  const _NutritionGoalModel._() : super._();

  factory _NutritionGoalModel.fromJson(Map<String, dynamic> json) =
      _$NutritionGoalModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'macro_format')
  MacroFormat get macroFormat;
  @override
  @JsonKey(name: 'protein_target')
  double get proteinTarget;
  @override
  @JsonKey(name: 'carb_target')
  double get carbTarget;
  @override
  @JsonKey(name: 'fat_target')
  double get fatTarget;
  @override
  @JsonKey(name: 'daily_calories')
  int get calorieTarget;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$NutritionGoalModelImplCopyWith<_$NutritionGoalModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
