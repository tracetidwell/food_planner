// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) {
  return _UserProfileModel.fromJson(json);
}

/// @nodoc
mixin _$UserProfileModel {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_preferences')
  String? get foodPreferences => throw _privateConstructorUsedError;
  @JsonKey(name: 'meals_per_day')
  int? get mealsPerDay => throw _privateConstructorUsedError;
  @JsonKey(name: 'snacks_per_day')
  int? get snacksPerDay => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileModelCopyWith<UserProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileModelCopyWith<$Res> {
  factory $UserProfileModelCopyWith(
          UserProfileModel value, $Res Function(UserProfileModel) then) =
      _$UserProfileModelCopyWithImpl<$Res, UserProfileModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'food_preferences') String? foodPreferences,
      @JsonKey(name: 'meals_per_day') int? mealsPerDay,
      @JsonKey(name: 'snacks_per_day') int? snacksPerDay});
}

/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res, $Val extends UserProfileModel>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? foodPreferences = freezed,
    Object? mealsPerDay = freezed,
    Object? snacksPerDay = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      foodPreferences: freezed == foodPreferences
          ? _value.foodPreferences
          : foodPreferences // ignore: cast_nullable_to_non_nullable
              as String?,
      mealsPerDay: freezed == mealsPerDay
          ? _value.mealsPerDay
          : mealsPerDay // ignore: cast_nullable_to_non_nullable
              as int?,
      snacksPerDay: freezed == snacksPerDay
          ? _value.snacksPerDay
          : snacksPerDay // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileModelImplCopyWith<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  factory _$$UserProfileModelImplCopyWith(_$UserProfileModelImpl value,
          $Res Function(_$UserProfileModelImpl) then) =
      __$$UserProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'food_preferences') String? foodPreferences,
      @JsonKey(name: 'meals_per_day') int? mealsPerDay,
      @JsonKey(name: 'snacks_per_day') int? snacksPerDay});
}

/// @nodoc
class __$$UserProfileModelImplCopyWithImpl<$Res>
    extends _$UserProfileModelCopyWithImpl<$Res, _$UserProfileModelImpl>
    implements _$$UserProfileModelImplCopyWith<$Res> {
  __$$UserProfileModelImplCopyWithImpl(_$UserProfileModelImpl _value,
      $Res Function(_$UserProfileModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? foodPreferences = freezed,
    Object? mealsPerDay = freezed,
    Object? snacksPerDay = freezed,
  }) {
    return _then(_$UserProfileModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      foodPreferences: freezed == foodPreferences
          ? _value.foodPreferences
          : foodPreferences // ignore: cast_nullable_to_non_nullable
              as String?,
      mealsPerDay: freezed == mealsPerDay
          ? _value.mealsPerDay
          : mealsPerDay // ignore: cast_nullable_to_non_nullable
              as int?,
      snacksPerDay: freezed == snacksPerDay
          ? _value.snacksPerDay
          : snacksPerDay // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileModelImpl extends _UserProfileModel {
  const _$UserProfileModelImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'food_preferences') this.foodPreferences,
      @JsonKey(name: 'meals_per_day') this.mealsPerDay,
      @JsonKey(name: 'snacks_per_day') this.snacksPerDay})
      : super._();

  factory _$UserProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'food_preferences')
  final String? foodPreferences;
  @override
  @JsonKey(name: 'meals_per_day')
  final int? mealsPerDay;
  @override
  @JsonKey(name: 'snacks_per_day')
  final int? snacksPerDay;

  @override
  String toString() {
    return 'UserProfileModel(userId: $userId, foodPreferences: $foodPreferences, mealsPerDay: $mealsPerDay, snacksPerDay: $snacksPerDay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.foodPreferences, foodPreferences) ||
                other.foodPreferences == foodPreferences) &&
            (identical(other.mealsPerDay, mealsPerDay) ||
                other.mealsPerDay == mealsPerDay) &&
            (identical(other.snacksPerDay, snacksPerDay) ||
                other.snacksPerDay == snacksPerDay));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, foodPreferences, mealsPerDay, snacksPerDay);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      __$$UserProfileModelImplCopyWithImpl<_$UserProfileModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileModelImplToJson(
      this,
    );
  }
}

abstract class _UserProfileModel extends UserProfileModel {
  const factory _UserProfileModel(
          {@JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'food_preferences') final String? foodPreferences,
          @JsonKey(name: 'meals_per_day') final int? mealsPerDay,
          @JsonKey(name: 'snacks_per_day') final int? snacksPerDay}) =
      _$UserProfileModelImpl;
  const _UserProfileModel._() : super._();

  factory _UserProfileModel.fromJson(Map<String, dynamic> json) =
      _$UserProfileModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'food_preferences')
  String? get foodPreferences;
  @override
  @JsonKey(name: 'meals_per_day')
  int? get mealsPerDay;
  @override
  @JsonKey(name: 'snacks_per_day')
  int? get snacksPerDay;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
