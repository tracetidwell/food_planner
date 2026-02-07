import 'package:meal_planner_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:meal_planner_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:meal_planner_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:meal_planner_app/features/profile/domain/entities/user_profile.dart';
import 'package:meal_planner_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:meal_planner_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:meal_planner_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

// Data sources
@riverpod
ProfileRemoteDataSource profileRemoteDataSource(ProfileRemoteDataSourceRef ref) {
  return ProfileRemoteDataSource(ref.watch(dioClientProvider).dio);
}

// Repository
@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
  );
}

// Use cases
@riverpod
GetProfileUseCase getProfileUseCase(GetProfileUseCaseRef ref) {
  return GetProfileUseCase(ref.watch(profileRepositoryProvider));
}

@riverpod
UpdateProfileUseCase updateProfileUseCase(UpdateProfileUseCaseRef ref) {
  return UpdateProfileUseCase(ref.watch(profileRepositoryProvider));
}

// Profile state provider
@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<UserProfile?> build() async {
    return await _loadProfile();
  }

  Future<UserProfile?> _loadProfile() async {
    final useCase = ref.read(getProfileUseCaseProvider);
    final result = await useCase();

    return result.fold(
      (failure) => null, // Profile might not exist yet
      (profile) => profile,
    );
  }

  Future<bool> updateProfile({
    String? foodPreferences,
    int? mealsPerDay,
    int? snacksPerDay,
  }) async {
    state = const AsyncLoading();

    final useCase = ref.read(updateProfileUseCaseProvider);
    final result = await useCase(
      foodPreferences: foodPreferences,
      mealsPerDay: mealsPerDay,
      snacksPerDay: snacksPerDay,
    );

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return false;
      },
      (profile) {
        state = AsyncData(profile);
        return true;
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadProfile());
  }
}
