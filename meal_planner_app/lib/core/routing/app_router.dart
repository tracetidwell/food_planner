import 'package:go_router/go_router.dart';
import 'package:meal_planner_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:meal_planner_app/features/auth/presentation/providers/auth_state.dart';
import 'package:meal_planner_app/features/auth/presentation/screens/login_screen.dart';
import 'package:meal_planner_app/features/auth/presentation/screens/register_screen.dart';
import 'package:meal_planner_app/features/goals/presentation/screens/create_goal_screen.dart';
import 'package:meal_planner_app/features/goals/presentation/screens/tdee_calculator_screen.dart';
import 'package:meal_planner_app/features/home/presentation/screens/home_screen.dart';
import 'package:meal_planner_app/features/meal_plans/presentation/screens/grocery_list_screen.dart';
import 'package:meal_planner_app/features/meal_plans/presentation/screens/meal_plan_config_screen.dart';
import 'package:meal_planner_app/features/meal_plans/presentation/screens/meal_plan_review_screen.dart';
import 'package:meal_planner_app/features/meal_plans/presentation/screens/meal_plans_list_screen.dart';
import 'package:meal_planner_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Router provider
@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authState is AuthStateAuthenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      // If not authenticated and trying to access protected route
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // If authenticated and trying to access auth routes
      if (isAuthenticated && isAuthRoute) {
        return '/';
      }

      // No redirect needed
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Home route
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),

      // Goals routes
      GoRoute(
        path: '/goals/tdee-calculator',
        builder: (context, state) => const TdeeCalculatorScreen(),
      ),
      GoRoute(
        path: '/goals/create',
        builder: (context, state) {
          final suggestedCalories = state.extra as int?;
          return CreateGoalScreen(suggestedCalories: suggestedCalories);
        },
      ),

      // Profile route
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // Meal Plans routes
      GoRoute(
        path: '/meal-plans',
        builder: (context, state) => const MealPlansListScreen(),
      ),
      GoRoute(
        path: '/meal-plans/configure',
        builder: (context, state) => const MealPlanConfigScreen(),
      ),
      GoRoute(
        path: '/meal-plans/review/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MealPlanReviewScreen(mealPlanId: id);
        },
      ),
      GoRoute(
        path: '/meal-plans/:id/grocery-list',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return GroceryListScreen(mealPlanId: id);
        },
      ),
    ],
  );
}
