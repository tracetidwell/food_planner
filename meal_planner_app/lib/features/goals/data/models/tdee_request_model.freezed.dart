// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tdee_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TdeeRequestModel _$TdeeRequestModelFromJson(Map<String, dynamic> json) {
  return _TdeeRequestModel.fromJson(json);
}

/// @nodoc
mixin _$TdeeRequestModel {
  int get age => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight_kg')
  double get weightKg => throw _privateConstructorUsedError;
  @JsonKey(name: 'height_cm')
  double get heightCm => throw _privateConstructorUsedError;
  Gender get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_level')
  ActivityLevel get activityLevel => throw _privateConstructorUsedError;
  GoalType get goal => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TdeeRequestModelCopyWith<TdeeRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TdeeRequestModelCopyWith<$Res> {
  factory $TdeeRequestModelCopyWith(
          TdeeRequestModel value, $Res Function(TdeeRequestModel) then) =
      _$TdeeRequestModelCopyWithImpl<$Res, TdeeRequestModel>;
  @useResult
  $Res call(
      {int age,
      @JsonKey(name: 'weight_kg') double weightKg,
      @JsonKey(name: 'height_cm') double heightCm,
      Gender gender,
      @JsonKey(name: 'activity_level') ActivityLevel activityLevel,
      GoalType goal});
}

/// @nodoc
class _$TdeeRequestModelCopyWithImpl<$Res, $Val extends TdeeRequestModel>
    implements $TdeeRequestModelCopyWith<$Res> {
  _$TdeeRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? age = null,
    Object? weightKg = null,
    Object? heightCm = null,
    Object? gender = null,
    Object? activityLevel = null,
    Object? goal = null,
  }) {
    return _then(_value.copyWith(
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      heightCm: null == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      activityLevel: null == activityLevel
          ? _value.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as ActivityLevel,
      goal: null == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as GoalType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TdeeRequestModelImplCopyWith<$Res>
    implements $TdeeRequestModelCopyWith<$Res> {
  factory _$$TdeeRequestModelImplCopyWith(_$TdeeRequestModelImpl value,
          $Res Function(_$TdeeRequestModelImpl) then) =
      __$$TdeeRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int age,
      @JsonKey(name: 'weight_kg') double weightKg,
      @JsonKey(name: 'height_cm') double heightCm,
      Gender gender,
      @JsonKey(name: 'activity_level') ActivityLevel activityLevel,
      GoalType goal});
}

/// @nodoc
class __$$TdeeRequestModelImplCopyWithImpl<$Res>
    extends _$TdeeRequestModelCopyWithImpl<$Res, _$TdeeRequestModelImpl>
    implements _$$TdeeRequestModelImplCopyWith<$Res> {
  __$$TdeeRequestModelImplCopyWithImpl(_$TdeeRequestModelImpl _value,
      $Res Function(_$TdeeRequestModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? age = null,
    Object? weightKg = null,
    Object? heightCm = null,
    Object? gender = null,
    Object? activityLevel = null,
    Object? goal = null,
  }) {
    return _then(_$TdeeRequestModelImpl(
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      heightCm: null == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      activityLevel: null == activityLevel
          ? _value.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as ActivityLevel,
      goal: null == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as GoalType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TdeeRequestModelImpl implements _TdeeRequestModel {
  const _$TdeeRequestModelImpl(
      {required this.age,
      @JsonKey(name: 'weight_kg') required this.weightKg,
      @JsonKey(name: 'height_cm') required this.heightCm,
      required this.gender,
      @JsonKey(name: 'activity_level') required this.activityLevel,
      required this.goal});

  factory _$TdeeRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TdeeRequestModelImplFromJson(json);

  @override
  final int age;
  @override
  @JsonKey(name: 'weight_kg')
  final double weightKg;
  @override
  @JsonKey(name: 'height_cm')
  final double heightCm;
  @override
  final Gender gender;
  @override
  @JsonKey(name: 'activity_level')
  final ActivityLevel activityLevel;
  @override
  final GoalType goal;

  @override
  String toString() {
    return 'TdeeRequestModel(age: $age, weightKg: $weightKg, heightCm: $heightCm, gender: $gender, activityLevel: $activityLevel, goal: $goal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TdeeRequestModelImpl &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.activityLevel, activityLevel) ||
                other.activityLevel == activityLevel) &&
            (identical(other.goal, goal) || other.goal == goal));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, age, weightKg, heightCm, gender, activityLevel, goal);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TdeeRequestModelImplCopyWith<_$TdeeRequestModelImpl> get copyWith =>
      __$$TdeeRequestModelImplCopyWithImpl<_$TdeeRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TdeeRequestModelImplToJson(
      this,
    );
  }
}

abstract class _TdeeRequestModel implements TdeeRequestModel {
  const factory _TdeeRequestModel(
      {required final int age,
      @JsonKey(name: 'weight_kg') required final double weightKg,
      @JsonKey(name: 'height_cm') required final double heightCm,
      required final Gender gender,
      @JsonKey(name: 'activity_level')
      required final ActivityLevel activityLevel,
      required final GoalType goal}) = _$TdeeRequestModelImpl;

  factory _TdeeRequestModel.fromJson(Map<String, dynamic> json) =
      _$TdeeRequestModelImpl.fromJson;

  @override
  int get age;
  @override
  @JsonKey(name: 'weight_kg')
  double get weightKg;
  @override
  @JsonKey(name: 'height_cm')
  double get heightCm;
  @override
  Gender get gender;
  @override
  @JsonKey(name: 'activity_level')
  ActivityLevel get activityLevel;
  @override
  GoalType get goal;
  @override
  @JsonKey(ignore: true)
  _$$TdeeRequestModelImplCopyWith<_$TdeeRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
