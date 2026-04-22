import 'package:meal_planner_app/core/constants/enums.dart';
import 'package:meal_planner_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:meal_planner_app/features/goals/data/datasources/goals_remote_datasource.dart';
import 'package:meal_planner_app/features/goals/data/repositories/goals_repository_impl.dart';
import 'package:meal_planner_app/features/goals/domain/entities/nutrition_goal.dart';
import 'package:meal_planner_app/features/goals/domain/entities/tdee_result.dart';
import 'package:meal_planner_app/features/goals/domain/repositories/goals_repository.dart';
import 'package:meal_planner_app/features/goals/domain/usecases/calculate_tdee_usecase.dart';
import 'package:meal_planner_app/features/goals/domain/usecases/create_goal_usecase.dart';
import 'package:meal_planner_app/features/goals/domain/usecases/get_goals_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'goals_provider.g.dart';

// Goals data sources
@riverpod
GoalsRemoteDataSource goalsRemoteDataSource(GoalsRemoteDataSourceRef ref) {
  return GoalsRemoteDataSource(ref.watch(dioClientProvider).dio);
}

// Goals repository
@riverpod
GoalsRepository goalsRepository(GoalsRepositoryRef ref) {
  return GoalsRepositoryImpl(
    remoteDataSource: ref.watch(goalsRemoteDataSourceProvider),
  );
}

// Goals use cases
@riverpod
CalculateTdeeUseCase calculateTdeeUseCase(CalculateTdeeUseCaseRef ref) {
  return CalculateTdeeUseCase(ref.watch(goalsRepositoryProvider));
}

@riverpod
CreateGoalUseCase createGoalUseCase(CreateGoalUseCaseRef ref) {
  return CreateGoalUseCase(ref.watch(goalsRepositoryProvider));
}

@riverpod
GetGoalsUseCase getGoalsUseCase(GetGoalsUseCaseRef ref) {
  return GetGoalsUseCase(ref.watch(goalsRepositoryProvider));
}

// Goals state notifier
@riverpod
class Goals extends _$Goals {
  @override
  Future<NutritionGoal?> build() async {
    return await _loadActiveGoal();
  }

  Future<NutritionGoal?> _loadActiveGoal() async {
    final useCase = ref.read(getGoalsUseCaseProvider);
    final result = await useCase();
    return result.fold(
      (failure) => null,
      (goal) => goal,
    );
  }

  Future<bool> createGoal({
    required MacroFormat macroFormat,
    required double proteinTarget,
    required double carbTarget,
    required double fatTarget,
    required int calorieTarget,
  }) async {
    state = const AsyncValue.loading();

    final useCase = ref.read(createGoalUseCaseProvider);
    final result = await useCase(
      macroFormat: macroFormat,
      proteinTarget: proteinTarget,
      carbTarget: carbTarget,
      fatTarget: fatTarget,
      calorieTarget: calorieTarget,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (goal) {
        state = AsyncValue.data(goal);
        return true;
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadActiveGoal());
  }
}

// TDEE calculation state notifier
@riverpod
class Tdee extends _$Tdee {
  @override
  TdeeResult? build() {
    return null;
  }

  Future<TdeeResult?> calculateTdee({
    required int age,
    required double weightKg,
    required double heightCm,
    required Gender gender,
    required ActivityLevel activityLevel,
    required GoalType goal,
  }) async {
    try {
      final useCase = ref.read(calculateTdeeUseCaseProvider);
      final result = await useCase(
        age: age,
        weightKg: weightKg,
        heightCm: heightCm,
        gender: gender,
        activityLevel: activityLevel,
        goal: goal,
      );

      return result.fold(
        (failure) {
          state = null;
          return null;
        },
        (tdeeResult) {
          state = tdeeResult;
          return tdeeResult;
        },
      );
    } catch (e, stackTrace) {
      state = null;
      return null;
    }
  }

  void reset() {
    state = null;
  }
}
