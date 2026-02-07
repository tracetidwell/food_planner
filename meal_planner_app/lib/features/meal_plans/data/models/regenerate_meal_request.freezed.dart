// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'regenerate_meal_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegenerateMealRequest _$RegenerateMealRequestFromJson(
    Map<String, dynamic> json) {
  return _RegenerateMealRequest.fromJson(json);
}

/// @nodoc
mixin _$RegenerateMealRequest {
  @JsonKey(name: 'planned_meal_id')
  String get plannedMealId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegenerateMealRequestCopyWith<RegenerateMealRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegenerateMealRequestCopyWith<$Res> {
  factory $RegenerateMealRequestCopyWith(RegenerateMealRequest value,
          $Res Function(RegenerateMealRequest) then) =
      _$RegenerateMealRequestCopyWithImpl<$Res, RegenerateMealRequest>;
  @useResult
  $Res call({@JsonKey(name: 'planned_meal_id') String plannedMealId});
}

/// @nodoc
class _$RegenerateMealRequestCopyWithImpl<$Res,
        $Val extends RegenerateMealRequest>
    implements $RegenerateMealRequestCopyWith<$Res> {
  _$RegenerateMealRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plannedMealId = null,
  }) {
    return _then(_value.copyWith(
      plannedMealId: null == plannedMealId
          ? _value.plannedMealId
          : plannedMealId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegenerateMealRequestImplCopyWith<$Res>
    implements $RegenerateMealRequestCopyWith<$Res> {
  factory _$$RegenerateMealRequestImplCopyWith(
          _$RegenerateMealRequestImpl value,
          $Res Function(_$RegenerateMealRequestImpl) then) =
      __$$RegenerateMealRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'planned_meal_id') String plannedMealId});
}

/// @nodoc
class __$$RegenerateMealRequestImplCopyWithImpl<$Res>
    extends _$RegenerateMealRequestCopyWithImpl<$Res,
        _$RegenerateMealRequestImpl>
    implements _$$RegenerateMealRequestImplCopyWith<$Res> {
  __$$RegenerateMealRequestImplCopyWithImpl(_$RegenerateMealRequestImpl _value,
      $Res Function(_$RegenerateMealRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plannedMealId = null,
  }) {
    return _then(_$RegenerateMealRequestImpl(
      plannedMealId: null == plannedMealId
          ? _value.plannedMealId
          : plannedMealId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegenerateMealRequestImpl implements _RegenerateMealRequest {
  const _$RegenerateMealRequestImpl(
      {@JsonKey(name: 'planned_meal_id') required this.plannedMealId});

  factory _$RegenerateMealRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegenerateMealRequestImplFromJson(json);

  @override
  @JsonKey(name: 'planned_meal_id')
  final String plannedMealId;

  @override
  String toString() {
    return 'RegenerateMealRequest(plannedMealId: $plannedMealId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegenerateMealRequestImpl &&
            (identical(other.plannedMealId, plannedMealId) ||
                other.plannedMealId == plannedMealId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, plannedMealId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegenerateMealRequestImplCopyWith<_$RegenerateMealRequestImpl>
      get copyWith => __$$RegenerateMealRequestImplCopyWithImpl<
          _$RegenerateMealRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegenerateMealRequestImplToJson(
      this,
    );
  }
}

abstract class _RegenerateMealRequest implements RegenerateMealRequest {
  const factory _RegenerateMealRequest(
      {@JsonKey(name: 'planned_meal_id')
      required final String plannedMealId}) = _$RegenerateMealRequestImpl;

  factory _RegenerateMealRequest.fromJson(Map<String, dynamic> json) =
      _$RegenerateMealRequestImpl.fromJson;

  @override
  @JsonKey(name: 'planned_meal_id')
  String get plannedMealId;
  @override
  @JsonKey(ignore: true)
  _$$RegenerateMealRequestImplCopyWith<_$RegenerateMealRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
