import 'package:hive_flutter/hive_flutter.dart';
import 'package:meal_planner_app/core/constants/app_constants.dart';

/// Manager for Hive local storage initialization and access
class CacheManager {
  static bool _initialized = false;

  /// Initialize Hive and register all adapters
  static Future<void> init() async {
    if (_initialized) return;

    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters (will be uncommented as models are created)
    // Hive.registerAdapter(MealPlanModelAdapter());
    // Hive.registerAdapter(PlannedMealModelAdapter());
    // Hive.registerAdapter(FoodItemModelAdapter());
    // Hive.registerAdapter(MealLogModelAdapter());
    // Hive.registerAdapter(UserProfileModelAdapter());

    // Open boxes
    await openBoxes();

    _initialized = true;
  }

  /// Open all Hive boxes
  static Future<void> openBoxes() async {
    // Open boxes (will be uncommented as models are created)
    // await Hive.openBox(AppConstants.mealPlansBoxName);
    // await Hive.openBox(AppConstants.mealLogsBoxName);
    // await Hive.openBox(AppConstants.userProfileBoxName);
  }

  /// Get meal plans box
  static Box getMealPlansBox() {
    return Hive.box(AppConstants.mealPlansBoxName);
  }

  /// Get meal logs box
  static Box getMealLogsBox() {
    return Hive.box(AppConstants.mealLogsBoxName);
  }

  /// Get user profile box
  static Box getUserProfileBox() {
    return Hive.box(AppConstants.userProfileBoxName);
  }

  /// Clear all cached data
  static Future<void> clearAll() async {
    if (!_initialized) return;

    try {
      final mealPlansBox = getMealPlansBox();
      await mealPlansBox.clear();
    } catch (e) {
      // Box not opened yet
    }

    try {
      final mealLogsBox = getMealLogsBox();
      await mealLogsBox.clear();
    } catch (e) {
      // Box not opened yet
    }

    try {
      final userProfileBox = getUserProfileBox();
      await userProfileBox.clear();
    } catch (e) {
      // Box not opened yet
    }
  }

  /// Delete all Hive data from disk
  static Future<void> deleteFromDisk() async {
    if (!_initialized) return;

    await Hive.deleteFromDisk();
    _initialized = false;
  }

  /// Close all boxes
  static Future<void> closeAll() async {
    if (!_initialized) return;

    await Hive.close();
    _initialized = false;
  }
}
