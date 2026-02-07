// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tdee_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TdeeResponseModel _$TdeeResponseModelFromJson(Map<String, dynamic> json) {
  return _TdeeResponseModel.fromJson(json);
}

/// @nodoc
mixin _$TdeeResponseModel {
  int get bmr => throw _privateConstructorUsedError;
  int get tdee => throw _privateConstructorUsedError;
  @JsonKey(name: 'recommended_calories')
  int get recommendedCalories => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_level')
  String get activityLevel => throw _privateConstructorUsedError;
  String get goal => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TdeeResponseModelCopyWith<TdeeResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TdeeResponseModelCopyWith<$Res> {
  factory $TdeeResponseModelCopyWith(
          TdeeResponseModel value, $Res Function(TdeeResponseModel) then) =
      _$TdeeResponseModelCopyWithImpl<$Res, TdeeResponseModel>;
  @useResult
  $Res call(
      {int bmr,
      int tdee,
      @JsonKey(name: 'recommended_calories') int recommendedCalories,
      @JsonKey(name: 'activity_level') String activityLevel,
      String goal});
}

/// @nodoc
class _$TdeeResponseModelCopyWithImpl<$Res, $Val extends TdeeResponseModel>
    implements $TdeeResponseModelCopyWith<$Res> {
  _$TdeeResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bmr = null,
    Object? tdee = null,
    Object? recommendedCalories = null,
    Object? activityLevel = null,
    Object? goal = null,
  }) {
    return _then(_value.copyWith(
      bmr: null == bmr
          ? _value.bmr
          : bmr // ignore: cast_nullable_to_non_nullable
              as int,
      tdee: null == tdee
          ? _value.tdee
          : tdee // ignore: cast_nullable_to_non_nullable
              as int,
      recommendedCalories: null == recommendedCalories
          ? _value.recommendedCalories
          : recommendedCalories // ignore: cast_nullable_to_non_nullable
              as int,
      activityLevel: null == activityLevel
          ? _value.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as String,
      goal: null == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TdeeResponseModelImplCopyWith<$Res>
    implements $TdeeResponseModelCopyWith<$Res> {
  factory _$$TdeeResponseModelImplCopyWith(_$TdeeResponseModelImpl value,
          $Res Function(_$TdeeResponseModelImpl) then) =
      __$$TdeeResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int bmr,
      int tdee,
      @JsonKey(name: 'recommended_calories') int recommendedCalories,
      @JsonKey(name: 'activity_level') String activityLevel,
      String goal});
}

/// @nodoc
class __$$TdeeResponseModelImplCopyWithImpl<$Res>
    extends _$TdeeResponseModelCopyWithImpl<$Res, _$TdeeResponseModelImpl>
    implements _$$TdeeResponseModelImplCopyWith<$Res> {
  __$$TdeeResponseModelImplCopyWithImpl(_$TdeeResponseModelImpl _value,
      $Res Function(_$TdeeResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bmr = null,
    Object? tdee = null,
    Object? recommendedCalories = null,
    Object? activityLevel = null,
    Object? goal = null,
  }) {
    return _then(_$TdeeResponseModelImpl(
      bmr: null == bmr
          ? _value.bmr
          : bmr // ignore: cast_nullable_to_non_nullable
              as int,
      tdee: null == tdee
          ? _value.tdee
          : tdee // ignore: cast_nullable_to_non_nullable
              as int,
      recommendedCalories: null == recommendedCalories
          ? _value.recommendedCalories
          : recommendedCalories // ignore: cast_nullable_to_non_nullable
              as int,
      activityLevel: null == activityLevel
          ? _value.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as String,
      goal: null == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TdeeResponseModelImpl extends _TdeeResponseModel {
  const _$TdeeResponseModelImpl(
      {required this.bmr,
      required this.tdee,
      @JsonKey(name: 'recommended_calories') required this.recommendedCalories,
      @JsonKey(name: 'activity_level') required this.activityLevel,
      required this.goal})
      : super._();

  factory _$TdeeResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TdeeResponseModelImplFromJson(json);

  @override
  final int bmr;
  @override
  final int tdee;
  @override
  @JsonKey(name: 'recommended_calories')
  final int recommendedCalories;
  @override
  @JsonKey(name: 'activity_level')
  final String activityLevel;
  @override
  final String goal;

  @override
  String toString() {
    return 'TdeeResponseModel(bmr: $bmr, tdee: $tdee, recommendedCalories: $recommendedCalories, activityLevel: $activityLevel, goal: $goal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TdeeResponseModelImpl &&
            (identical(other.bmr, bmr) || other.bmr == bmr) &&
            (identical(other.tdee, tdee) || other.tdee == tdee) &&
            (identical(other.recommendedCalories, recommendedCalories) ||
                other.recommendedCalories == recommendedCalories) &&
            (identical(other.activityLevel, activityLevel) ||
                other.activityLevel == activityLevel) &&
            (identical(other.goal, goal) || other.goal == goal));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, bmr, tdee, recommendedCalories, activityLevel, goal);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TdeeResponseModelImplCopyWith<_$TdeeResponseModelImpl> get copyWith =>
      __$$TdeeResponseModelImplCopyWithImpl<_$TdeeResponseModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TdeeResponseModelImplToJson(
      this,
    );
  }
}

abstract class _TdeeResponseModel extends TdeeResponseModel {
  const factory _TdeeResponseModel(
      {required final int bmr,
      required final int tdee,
      @JsonKey(name: 'recommended_calories')
      required final int recommendedCalories,
      @JsonKey(name: 'activity_level') required final String activityLevel,
      required final String goal}) = _$TdeeResponseModelImpl;
  const _TdeeResponseModel._() : super._();

  factory _TdeeResponseModel.fromJson(Map<String, dynamic> json) =
      _$TdeeResponseModelImpl.fromJson;

  @override
  int get bmr;
  @override
  int get tdee;
  @override
  @JsonKey(name: 'recommended_calories')
  int get recommendedCalories;
  @override
  @JsonKey(name: 'activity_level')
  String get activityLevel;
  @override
  String get goal;
  @override
  @JsonKey(ignore: true)
  _$$TdeeResponseModelImplCopyWith<_$TdeeResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
