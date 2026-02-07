import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meal_planner_app/core/network/dio_client.dart';
import 'package:meal_planner_app/core/storage/secure_storage.dart';
import 'package:meal_planner_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:meal_planner_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:meal_planner_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:meal_planner_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:meal_planner_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:meal_planner_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:meal_planner_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:meal_planner_app/features/auth/presentation/providers/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

// Core providers
@riverpod
FlutterSecureStorage flutterSecureStorage(FlutterSecureStorageRef ref) {
  return const FlutterSecureStorage();
}

@riverpod
SecureStorage secureStorage(SecureStorageRef ref) {
  return SecureStorage(ref.watch(flutterSecureStorageProvider));
}

@riverpod
DioClient dioClient(DioClientRef ref) {
  return DioClient(storage: ref.watch(secureStorageProvider));
}

// Auth data sources
@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  return AuthRemoteDataSource(ref.watch(dioClientProvider).dio);
}

// Auth repository
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
}

// Auth use cases
@riverpod
LoginUseCase loginUseCase(LoginUseCaseRef ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
RegisterUseCase registerUseCase(RegisterUseCaseRef ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(GetCurrentUserUseCaseRef ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
LogoutUseCase logoutUseCase(LogoutUseCaseRef ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
}

// Auth state notifier
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _checkAuthStatus();
    return const AuthState.initial();
  }

  /// Check if user is authenticated on app start
  Future<void> _checkAuthStatus() async {
    try {
      final isAuth = await ref.read(authRepositoryProvider).isAuthenticated();

      if (isAuth) {
        final useCase = ref.read(getCurrentUserUseCaseProvider);
        final result = await useCase();

        result.fold(
          (failure) => state = const AuthState.unauthenticated(),
          (user) => state = AuthState.authenticated(user),
        );
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      // If there's any error during auth check, assume unauthenticated
      // This prevents app crashes on startup
      state = const AuthState.unauthenticated();
    }
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    state = const AuthState.loading();

    final useCase = ref.read(loginUseCaseProvider);
    final result = await useCase(email: email, password: password);

    await result.fold(
      (failure) async {
        state = AuthState.error(failure.message);
      },
      (token) async {
        // Token saved in repository, now get user
        await _checkAuthStatus();
      },
    );
  }

  /// Register a new user
  Future<void> register(String email, String password) async {
    state = const AuthState.loading();

    final useCase = ref.read(registerUseCaseProvider);
    final result = await useCase(email: email, password: password);

    result.fold(
      (failure) {
        state = AuthState.error(failure.message);
      },
      (user) {
        // User registered, now they need to login
        state = const AuthState.unauthenticated();
      },
    );
  }

  /// Logout the current user
  Future<void> logout() async {
    final useCase = ref.read(logoutUseCaseProvider);
    await useCase();
    state = const AuthState.unauthenticated();
  }

  /// Clear error state
  void clearError() {
    state = const AuthState.unauthenticated();
  }
}
