// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_plan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MealPlanModel _$MealPlanModelFromJson(Map<String, dynamic> json) {
  return _MealPlanModel.fromJson(json);
}

/// @nodoc
mixin _$MealPlanModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'goal_id')
  String? get goalId => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  String get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_days')
  int get durationDays => throw _privateConstructorUsedError;
  PlanStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_at')
  DateTime get generatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'accepted_at')
  DateTime? get acceptedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'planned_meals')
  List<PlannedMealModel>? get plannedMeals =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MealPlanModelCopyWith<MealPlanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealPlanModelCopyWith<$Res> {
  factory $MealPlanModelCopyWith(
          MealPlanModel value, $Res Function(MealPlanModel) then) =
      _$MealPlanModelCopyWithImpl<$Res, MealPlanModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'goal_id') String? goalId,
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'duration_days') int durationDays,
      PlanStatus status,
      @JsonKey(name: 'generated_at') DateTime generatedAt,
      @JsonKey(name: 'accepted_at') DateTime? acceptedAt,
      @JsonKey(name: 'planned_meals') List<PlannedMealModel>? plannedMeals});
}

/// @nodoc
class _$MealPlanModelCopyWithImpl<$Res, $Val extends MealPlanModel>
    implements $MealPlanModelCopyWith<$Res> {
  _$MealPlanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? goalId = freezed,
    Object? startDate = null,
    Object? durationDays = null,
    Object? status = null,
    Object? generatedAt = null,
    Object? acceptedAt = freezed,
    Object? plannedMeals = freezed,
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
      goalId: freezed == goalId
          ? _value.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      durationDays: null == durationDays
          ? _value.durationDays
          : durationDays // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlanStatus,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      plannedMeals: freezed == plannedMeals
          ? _value.plannedMeals
          : plannedMeals // ignore: cast_nullable_to_non_nullable
              as List<PlannedMealModel>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MealPlanModelImplCopyWith<$Res>
    implements $MealPlanModelCopyWith<$Res> {
  factory _$$MealPlanModelImplCopyWith(
          _$MealPlanModelImpl value, $Res Function(_$MealPlanModelImpl) then) =
      __$$MealPlanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'goal_id') String? goalId,
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'duration_days') int durationDays,
      PlanStatus status,
      @JsonKey(name: 'generated_at') DateTime generatedAt,
      @JsonKey(name: 'accepted_at') DateTime? acceptedAt,
      @JsonKey(name: 'planned_meals') List<PlannedMealModel>? plannedMeals});
}

/// @nodoc
class __$$MealPlanModelImplCopyWithImpl<$Res>
    extends _$MealPlanModelCopyWithImpl<$Res, _$MealPlanModelImpl>
    implements _$$MealPlanModelImplCopyWith<$Res> {
  __$$MealPlanModelImplCopyWithImpl(
      _$MealPlanModelImpl _value, $Res Function(_$MealPlanModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? goalId = freezed,
    Object? startDate = null,
    Object? durationDays = null,
    Object? status = null,
    Object? generatedAt = null,
    Object? acceptedAt = freezed,
    Object? plannedMeals = freezed,
  }) {
    return _then(_$MealPlanModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      goalId: freezed == goalId
          ? _value.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      durationDays: null == durationDays
          ? _value.durationDays
          : durationDays // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlanStatus,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      plannedMeals: freezed == plannedMeals
          ? _value._plannedMeals
          : plannedMeals // ignore: cast_nullable_to_non_nullable
              as List<PlannedMealModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MealPlanModelImpl extends _MealPlanModel {
  const _$MealPlanModelImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'goal_id') this.goalId,
      @JsonKey(name: 'start_date') required this.startDate,
      @JsonKey(name: 'duration_days') required this.durationDays,
      required this.status,
      @JsonKey(name: 'generated_at') required this.generatedAt,
      @JsonKey(name: 'accepted_at') this.acceptedAt,
      @JsonKey(name: 'planned_meals')
      final List<PlannedMealModel>? plannedMeals})
      : _plannedMeals = plannedMeals,
        super._();

  factory _$MealPlanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealPlanModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'goal_id')
  final String? goalId;
  @override
  @JsonKey(name: 'start_date')
  final String startDate;
  @override
  @JsonKey(name: 'duration_days')
  final int durationDays;
  @override
  final PlanStatus status;
  @override
  @JsonKey(name: 'generated_at')
  final DateTime generatedAt;
  @override
  @JsonKey(name: 'accepted_at')
  final DateTime? acceptedAt;
  final List<PlannedMealModel>? _plannedMeals;
  @override
  @JsonKey(name: 'planned_meals')
  List<PlannedMealModel>? get plannedMeals {
    final value = _plannedMeals;
    if (value == null) return null;
    if (_plannedMeals is EqualUnmodifiableListView) return _plannedMeals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'MealPlanModel(id: $id, userId: $userId, goalId: $goalId, startDate: $startDate, durationDays: $durationDays, status: $status, generatedAt: $generatedAt, acceptedAt: $acceptedAt, plannedMeals: $plannedMeals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealPlanModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.durationDays, durationDays) ||
                other.durationDays == durationDays) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            const DeepCollectionEquality()
                .equals(other._plannedMeals, _plannedMeals));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      goalId,
      startDate,
      durationDays,
      status,
      generatedAt,
      acceptedAt,
      const DeepCollectionEquality().hash(_plannedMeals));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MealPlanModelImplCopyWith<_$MealPlanModelImpl> get copyWith =>
      __$$MealPlanModelImplCopyWithImpl<_$MealPlanModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealPlanModelImplToJson(
      this,
    );
  }
}

abstract class _MealPlanModel extends MealPlanModel {
  const factory _MealPlanModel(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'goal_id') final String? goalId,
      @JsonKey(name: 'start_date') required final String startDate,
      @JsonKey(name: 'duration_days') required final int durationDays,
      required final PlanStatus status,
      @JsonKey(name: 'generated_at') required final DateTime generatedAt,
      @JsonKey(name: 'accepted_at') final DateTime? acceptedAt,
      @JsonKey(name: 'planned_meals')
      final List<PlannedMealModel>? plannedMeals}) = _$MealPlanModelImpl;
  const _MealPlanModel._() : super._();

  factory _MealPlanModel.fromJson(Map<String, dynamic> json) =
      _$MealPlanModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'goal_id')
  String? get goalId;
  @override
  @JsonKey(name: 'start_date')
  String get startDate;
  @override
  @JsonKey(name: 'duration_days')
  int get durationDays;
  @override
  PlanStatus get status;
  @override
  @JsonKey(name: 'generated_at')
  DateTime get generatedAt;
  @override
  @JsonKey(name: 'accepted_at')
  DateTime? get acceptedAt;
  @override
  @JsonKey(name: 'planned_meals')
  List<PlannedMealModel>? get plannedMeals;
  @override
  @JsonKey(ignore: true)
  _$$MealPlanModelImplCopyWith<_$MealPlanModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
