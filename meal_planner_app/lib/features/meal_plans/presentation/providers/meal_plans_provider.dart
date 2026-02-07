import 'package:meal_planner_app/core/network/dio_client.dart';
import 'package:meal_planner_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:meal_planner_app/features/goals/domain/repositories/goals_repository.dart';
import 'package:meal_planner_app/features/goals/presentation/providers/goals_provider.dart';
import 'package:meal_planner_app/features/meal_plans/data/datasources/meal_plans_remote_datasource.dart';
import 'package:meal_planner_app/features/meal_plans/data/repositories/meal_plans_repository_impl.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/grocery_list.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/meal_plan.dart';
import 'package:meal_planner_app/features/meal_plans/domain/repositories/meal_plans_repository.dart';
import 'package:meal_planner_app/features/meal_plans/domain/usecases/accept_meal_plan_usecase.dart';
import 'package:meal_planner_app/features/meal_plans/domain/usecases/generate_meal_plan_usecase.dart';
import 'package:meal_planner_app/features/meal_plans/domain/usecases/get_grocery_list_usecase.dart';
import 'package:meal_planner_app/features/meal_plans/domain/usecases/get_meal_plan_by_id_usecase.dart';
import 'package:meal_planner_app/features/meal_plans/domain/usecases/get_meal_plans_usecase.dart';
import 'package:meal_planner_app/features/meal_plans/domain/usecases/regenerate_meal_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meal_plans_provider.g.dart';

// ============================================================================
// Data Source Providers
// ============================================================================

/// Provider for meal plans remote data source
@riverpod
MealPlansRemoteDataSource mealPlansRemoteDataSource(
  MealPlansRemoteDataSourceRef ref,
) {
  return MealPlansRemoteDataSource(ref.watch(dioClientProvider).dio);
}

// ============================================================================
// Repository Providers
// ============================================================================

/// Provider for meal plans repository
@riverpod
MealPlansRepository mealPlansRepository(MealPlansRepositoryRef ref) {
  return MealPlansRepositoryImpl(
    remoteDataSource: ref.watch(mealPlansRemoteDataSourceProvider),
  );
}

// ============================================================================
// Use Case Providers
// ============================================================================

/// Provider for generate meal plan use case
@riverpod
GenerateMealPlanUseCase generateMealPlanUseCase(
  GenerateMealPlanUseCaseRef ref,
) {
  return GenerateMealPlanUseCase(
    ref.watch(mealPlansRepositoryProvider),
    ref.watch(goalsRepositoryProvider),
  );
}

/// Provider for get meal plans use case
@riverpod
GetMealPlansUseCase getMealPlansUseCase(GetMealPlansUseCaseRef ref) {
  return GetMealPlansUseCase(ref.watch(mealPlansRepositoryProvider));
}

/// Provider for get meal plan by ID use case
@riverpod
GetMealPlanByIdUseCase getMealPlanByIdUseCase(
  GetMealPlanByIdUseCaseRef ref,
) {
  return GetMealPlanByIdUseCase(ref.watch(mealPlansRepositoryProvider));
}

/// Provider for accept meal plan use case
@riverpod
AcceptMealPlanUseCase acceptMealPlanUseCase(AcceptMealPlanUseCaseRef ref) {
  return AcceptMealPlanUseCase(ref.watch(mealPlansRepositoryProvider));
}

/// Provider for regenerate meal use case
@riverpod
RegenerateMealUseCase regenerateMealUseCase(RegenerateMealUseCaseRef ref) {
  return RegenerateMealUseCase(ref.watch(mealPlansRepositoryProvider));
}

/// Provider for get grocery list use case
@riverpod
GetGroceryListUseCase getGroceryListUseCase(GetGroceryListUseCaseRef ref) {
  return GetGroceryListUseCase(ref.watch(mealPlansRepositoryProvider));
}

// ============================================================================
// State Notifiers
// ============================================================================

/// State notifier for meal plan generation flow
@riverpod
class MealPlanGeneration extends _$MealPlanGeneration {
  @override
  AsyncValue<MealPlan?> build() {
    return const AsyncValue.data(null);
  }

  /// Generate a new meal plan
  Future<MealPlan?> generateMealPlan({
    required DateTime startDate,
    required int durationDays,
  }) async {
    state = const AsyncValue.loading();

    final useCase = ref.read(generateMealPlanUseCaseProvider);
    final result = await useCase(
      startDate: startDate,
      durationDays: durationDays,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return null;
      },
      (mealPlan) {
        state = AsyncValue.data(mealPlan);
        return mealPlan;
      },
    );
  }

  /// Regenerate a specific meal in the current plan
  Future<bool> regenerateMeal({
    required String mealPlanId,
    required String plannedMealId,
  }) async {
    final currentPlan = state.value;
    if (currentPlan == null) return false;

    final useCase = ref.read(regenerateMealUseCaseProvider);
    final result = await useCase(
      mealPlanId: mealPlanId,
      plannedMealId: plannedMealId,
    );

    return result.fold(
      (failure) {
        // Keep current plan, just show error
        return false;
      },
      (updatedMeal) {
        // Refresh the meal plan to get updated data
        _refreshMealPlan(mealPlanId);
        return true;
      },
    );
  }

  /// Refresh a meal plan after regenerating a meal
  Future<void> _refreshMealPlan(String mealPlanId) async {
    final useCase = ref.read(getMealPlanByIdUseCaseProvider);
    final result = await useCase(mealPlanId);

    result.fold(
      (failure) {
        // Keep current state on error
      },
      (mealPlan) {
        state = AsyncValue.data(mealPlan);
      },
    );
  }

  /// Accept a meal plan
  Future<bool> acceptMealPlan(String mealPlanId) async {
    final useCase = ref.read(acceptMealPlanUseCaseProvider);
    final result = await useCase(mealPlanId);

    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }

  /// Reset state to initial
  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// State notifier for grocery list
@riverpod
class GroceryListState extends _$GroceryListState {
  @override
  AsyncValue<GroceryList?> build() {
    return const AsyncValue.data(null);
  }

  /// Load grocery list for a meal plan
  Future<bool> loadGroceryList(String mealPlanId) async {
    state = const AsyncValue.loading();

    final useCase = ref.read(getGroceryListUseCaseProvider);
    final result = await useCase(mealPlanId);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (groceryList) {
        state = AsyncValue.data(groceryList);
        return true;
      },
    );
  }

  /// Reset state to initial
  void reset() {
    state = const AsyncValue.data(null);
  }
}
