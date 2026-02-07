// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_plan_generate_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MealPlanGenerateRequest _$MealPlanGenerateRequestFromJson(
    Map<String, dynamic> json) {
  return _MealPlanGenerateRequest.fromJson(json);
}

/// @nodoc
mixin _$MealPlanGenerateRequest {
  @JsonKey(name: 'start_date')
  String get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_days')
  int get durationDays => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MealPlanGenerateRequestCopyWith<MealPlanGenerateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealPlanGenerateRequestCopyWith<$Res> {
  factory $MealPlanGenerateRequestCopyWith(MealPlanGenerateRequest value,
          $Res Function(MealPlanGenerateRequest) then) =
      _$MealPlanGenerateRequestCopyWithImpl<$Res, MealPlanGenerateRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'duration_days') int durationDays});
}

/// @nodoc
class _$MealPlanGenerateRequestCopyWithImpl<$Res,
        $Val extends MealPlanGenerateRequest>
    implements $MealPlanGenerateRequestCopyWith<$Res> {
  _$MealPlanGenerateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? durationDays = null,
  }) {
    return _then(_value.copyWith(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      durationDays: null == durationDays
          ? _value.durationDays
          : durationDays // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MealPlanGenerateRequestImplCopyWith<$Res>
    implements $MealPlanGenerateRequestCopyWith<$Res> {
  factory _$$MealPlanGenerateRequestImplCopyWith(
          _$MealPlanGenerateRequestImpl value,
          $Res Function(_$MealPlanGenerateRequestImpl) then) =
      __$$MealPlanGenerateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'duration_days') int durationDays});
}

/// @nodoc
class __$$MealPlanGenerateRequestImplCopyWithImpl<$Res>
    extends _$MealPlanGenerateRequestCopyWithImpl<$Res,
        _$MealPlanGenerateRequestImpl>
    implements _$$MealPlanGenerateRequestImplCopyWith<$Res> {
  __$$MealPlanGenerateRequestImplCopyWithImpl(
      _$MealPlanGenerateRequestImpl _value,
      $Res Function(_$MealPlanGenerateRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? durationDays = null,
  }) {
    return _then(_$MealPlanGenerateRequestImpl(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      durationDays: null == durationDays
          ? _value.durationDays
          : durationDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MealPlanGenerateRequestImpl implements _MealPlanGenerateRequest {
  const _$MealPlanGenerateRequestImpl(
      {@JsonKey(name: 'start_date') required this.startDate,
      @JsonKey(name: 'duration_days') required this.durationDays});

  factory _$MealPlanGenerateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealPlanGenerateRequestImplFromJson(json);

  @override
  @JsonKey(name: 'start_date')
  final String startDate;
  @override
  @JsonKey(name: 'duration_days')
  final int durationDays;

  @override
  String toString() {
    return 'MealPlanGenerateRequest(startDate: $startDate, durationDays: $durationDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealPlanGenerateRequestImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.durationDays, durationDays) ||
                other.durationDays == durationDays));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, startDate, durationDays);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MealPlanGenerateRequestImplCopyWith<_$MealPlanGenerateRequestImpl>
      get copyWith => __$$MealPlanGenerateRequestImplCopyWithImpl<
          _$MealPlanGenerateRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealPlanGenerateRequestImplToJson(
      this,
    );
  }
}

abstract class _MealPlanGenerateRequest implements MealPlanGenerateRequest {
  const factory _MealPlanGenerateRequest(
          {@JsonKey(name: 'start_date') required final String startDate,
          @JsonKey(name: 'duration_days') required final int durationDays}) =
      _$MealPlanGenerateRequestImpl;

  factory _MealPlanGenerateRequest.fromJson(Map<String, dynamic> json) =
      _$MealPlanGenerateRequestImpl.fromJson;

  @override
  @JsonKey(name: 'start_date')
  String get startDate;
  @override
  @JsonKey(name: 'duration_days')
  int get durationDays;
  @override
  @JsonKey(ignore: true)
  _$$MealPlanGenerateRequestImplCopyWith<_$MealPlanGenerateRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
