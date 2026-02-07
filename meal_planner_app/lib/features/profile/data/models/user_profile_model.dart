import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meal_planner_app/features/profile/domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

/// Model for user profile data from API
@freezed
class UserProfileModel with _$UserProfileModel {
  const UserProfileModel._();

  const factory UserProfileModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'food_preferences') String? foodPreferences,
    @JsonKey(name: 'meals_per_day') int? mealsPerDay,
    @JsonKey(name: 'snacks_per_day') int? snacksPerDay,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  /// Convert model to entity
  UserProfile toEntity() {
    return UserProfile(
      userId: userId,
      foodPreferences: foodPreferences,
      mealsPerDay: mealsPerDay,
      snacksPerDay: snacksPerDay,
    );
  }
}
