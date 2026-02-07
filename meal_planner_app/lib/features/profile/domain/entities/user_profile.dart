import 'package:equatable/equatable.dart';

/// User profile entity
class UserProfile extends Equatable {
  final String userId;
  final String? foodPreferences;
  final int? mealsPerDay;
  final int? snacksPerDay;

  const UserProfile({
    required this.userId,
    this.foodPreferences,
    this.mealsPerDay,
    this.snacksPerDay,
  });

  @override
  List<Object?> get props => [userId, foodPreferences, mealsPerDay, snacksPerDay];

  @override
  String toString() => 'UserProfile(userId: $userId, mealsPerDay: $mealsPerDay, snacksPerDay: $snacksPerDay)';
}
