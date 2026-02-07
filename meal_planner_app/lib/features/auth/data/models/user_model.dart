import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meal_planner_app/features/auth/domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Model for user data from API
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convert model to entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      createdAt: createdAt,
    );
  }
}

/// Extension to convert entity to model
extension UserEntityX on User {
  UserModel toModel() {
    return UserModel(
      id: id,
      email: email,
      createdAt: createdAt,
    );
  }
}
