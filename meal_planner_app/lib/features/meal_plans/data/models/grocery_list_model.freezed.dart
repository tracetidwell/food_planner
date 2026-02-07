// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grocery_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GroceryItemModel _$GroceryItemModelFromJson(Map<String, dynamic> json) {
  return _GroceryItemModel.fromJson(json);
}

/// @nodoc
mixin _$GroceryItemModel {
  String get food => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GroceryItemModelCopyWith<GroceryItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroceryItemModelCopyWith<$Res> {
  factory $GroceryItemModelCopyWith(
          GroceryItemModel value, $Res Function(GroceryItemModel) then) =
      _$GroceryItemModelCopyWithImpl<$Res, GroceryItemModel>;
  @useResult
  $Res call({String food, double quantity, String unit, String category});
}

/// @nodoc
class _$GroceryItemModelCopyWithImpl<$Res, $Val extends GroceryItemModel>
    implements $GroceryItemModelCopyWith<$Res> {
  _$GroceryItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? food = null,
    Object? quantity = null,
    Object? unit = null,
    Object? category = null,
  }) {
    return _then(_value.copyWith(
      food: null == food
          ? _value.food
          : food // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroceryItemModelImplCopyWith<$Res>
    implements $GroceryItemModelCopyWith<$Res> {
  factory _$$GroceryItemModelImplCopyWith(_$GroceryItemModelImpl value,
          $Res Function(_$GroceryItemModelImpl) then) =
      __$$GroceryItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String food, double quantity, String unit, String category});
}

/// @nodoc
class __$$GroceryItemModelImplCopyWithImpl<$Res>
    extends _$GroceryItemModelCopyWithImpl<$Res, _$GroceryItemModelImpl>
    implements _$$GroceryItemModelImplCopyWith<$Res> {
  __$$GroceryItemModelImplCopyWithImpl(_$GroceryItemModelImpl _value,
      $Res Function(_$GroceryItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? food = null,
    Object? quantity = null,
    Object? unit = null,
    Object? category = null,
  }) {
    return _then(_$GroceryItemModelImpl(
      food: null == food
          ? _value.food
          : food // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroceryItemModelImpl extends _GroceryItemModel {
  const _$GroceryItemModelImpl(
      {required this.food,
      required this.quantity,
      required this.unit,
      required this.category})
      : super._();

  factory _$GroceryItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroceryItemModelImplFromJson(json);

  @override
  final String food;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  final String category;

  @override
  String toString() {
    return 'GroceryItemModel(food: $food, quantity: $quantity, unit: $unit, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroceryItemModelImpl &&
            (identical(other.food, food) || other.food == food) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, food, quantity, unit, category);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroceryItemModelImplCopyWith<_$GroceryItemModelImpl> get copyWith =>
      __$$GroceryItemModelImplCopyWithImpl<_$GroceryItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroceryItemModelImplToJson(
      this,
    );
  }
}

abstract class _GroceryItemModel extends GroceryItemModel {
  const factory _GroceryItemModel(
      {required final String food,
      required final double quantity,
      required final String unit,
      required final String category}) = _$GroceryItemModelImpl;
  const _GroceryItemModel._() : super._();

  factory _GroceryItemModel.fromJson(Map<String, dynamic> json) =
      _$GroceryItemModelImpl.fromJson;

  @override
  String get food;
  @override
  double get quantity;
  @override
  String get unit;
  @override
  String get category;
  @override
  @JsonKey(ignore: true)
  _$$GroceryItemModelImplCopyWith<_$GroceryItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroceryListModel _$GroceryListModelFromJson(Map<String, dynamic> json) {
  return _GroceryListModel.fromJson(json);
}

/// @nodoc
mixin _$GroceryListModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'meal_plan_id')
  String get mealPlanId => throw _privateConstructorUsedError;
  List<GroceryItemModel> get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_at')
  DateTime get generatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GroceryListModelCopyWith<GroceryListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroceryListModelCopyWith<$Res> {
  factory $GroceryListModelCopyWith(
          GroceryListModel value, $Res Function(GroceryListModel) then) =
      _$GroceryListModelCopyWithImpl<$Res, GroceryListModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'meal_plan_id') String mealPlanId,
      List<GroceryItemModel> items,
      @JsonKey(name: 'generated_at') DateTime generatedAt});
}

/// @nodoc
class _$GroceryListModelCopyWithImpl<$Res, $Val extends GroceryListModel>
    implements $GroceryListModelCopyWith<$Res> {
  _$GroceryListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mealPlanId = null,
    Object? items = null,
    Object? generatedAt = null,
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
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<GroceryItemModel>,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroceryListModelImplCopyWith<$Res>
    implements $GroceryListModelCopyWith<$Res> {
  factory _$$GroceryListModelImplCopyWith(_$GroceryListModelImpl value,
          $Res Function(_$GroceryListModelImpl) then) =
      __$$GroceryListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'meal_plan_id') String mealPlanId,
      List<GroceryItemModel> items,
      @JsonKey(name: 'generated_at') DateTime generatedAt});
}

/// @nodoc
class __$$GroceryListModelImplCopyWithImpl<$Res>
    extends _$GroceryListModelCopyWithImpl<$Res, _$GroceryListModelImpl>
    implements _$$GroceryListModelImplCopyWith<$Res> {
  __$$GroceryListModelImplCopyWithImpl(_$GroceryListModelImpl _value,
      $Res Function(_$GroceryListModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mealPlanId = null,
    Object? items = null,
    Object? generatedAt = null,
  }) {
    return _then(_$GroceryListModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mealPlanId: null == mealPlanId
          ? _value.mealPlanId
          : mealPlanId // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<GroceryItemModel>,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroceryListModelImpl extends _GroceryListModel {
  const _$GroceryListModelImpl(
      {required this.id,
      @JsonKey(name: 'meal_plan_id') required this.mealPlanId,
      required final List<GroceryItemModel> items,
      @JsonKey(name: 'generated_at') required this.generatedAt})
      : _items = items,
        super._();

  factory _$GroceryListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroceryListModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'meal_plan_id')
  final String mealPlanId;
  final List<GroceryItemModel> _items;
  @override
  List<GroceryItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey(name: 'generated_at')
  final DateTime generatedAt;

  @override
  String toString() {
    return 'GroceryListModel(id: $id, mealPlanId: $mealPlanId, items: $items, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroceryListModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mealPlanId, mealPlanId) ||
                other.mealPlanId == mealPlanId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, mealPlanId,
      const DeepCollectionEquality().hash(_items), generatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroceryListModelImplCopyWith<_$GroceryListModelImpl> get copyWith =>
      __$$GroceryListModelImplCopyWithImpl<_$GroceryListModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroceryListModelImplToJson(
      this,
    );
  }
}

abstract class _GroceryListModel extends GroceryListModel {
  const factory _GroceryListModel(
          {required final String id,
          @JsonKey(name: 'meal_plan_id') required final String mealPlanId,
          required final List<GroceryItemModel> items,
          @JsonKey(name: 'generated_at') required final DateTime generatedAt}) =
      _$GroceryListModelImpl;
  const _GroceryListModel._() : super._();

  factory _GroceryListModel.fromJson(Map<String, dynamic> json) =
      _$GroceryListModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'meal_plan_id')
  String get mealPlanId;
  @override
  List<GroceryItemModel> get items;
  @override
  @JsonKey(name: 'generated_at')
  DateTime get generatedAt;
  @override
  @JsonKey(ignore: true)
  _$$GroceryListModelImplCopyWith<_$GroceryListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
