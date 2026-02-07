/// Application-wide constants
class AppConstants {
  AppConstants._();

  // Storage keys
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';

  // Hive box names
  static const String mealPlansBoxName = 'meal_plans';
  static const String mealLogsBoxName = 'meal_logs';
  static const String userProfileBoxName = 'user_profile';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 100;
  static const int minMealsPerDay = 1;
  static const int maxMealsPerDay = 6;
  static const int minSnacksPerDay = 0;
  static const int maxSnacksPerDay = 4;

  // Meal plan
  static const int minPlanDurationDays = 1;
  static const int maxPlanDurationDays = 14;

  // API
  static const String authHeaderKey = 'Authorization';
  static const String bearerPrefix = 'Bearer';

  // Date formats
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String displayDateFormat = 'EEEE, MMMM d, y';
  static const String shortDateFormat = 'MMM d, y';
}
