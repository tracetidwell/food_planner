import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner_app/app.dart';
import 'package:meal_planner_app/core/storage/cache_manager.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for offline storage
  // Note: Adapter registration is commented out until models are generated
  await CacheManager.init();

  // Run the app with ProviderScope for Riverpod
  runApp(
    const ProviderScope(
      child: MealPlannerApp(),
    ),
  );
}
