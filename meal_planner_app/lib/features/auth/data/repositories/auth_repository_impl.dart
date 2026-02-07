import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/core/network/network_exceptions.dart';
import 'package:meal_planner_app/core/storage/secure_storage.dart';
import 'package:meal_planner_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:meal_planner_app/features/auth/domain/entities/user.dart';
import 'package:meal_planner_app/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorage secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.register({
        'email': email,
        'password': password,
      });

      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  }) async {
    try {
      final tokenModel = await remoteDataSource.login(email, password);

      // Save token to secure storage
      await secureStorage.saveToken(tokenModel.accessToken);

      return Right(tokenModel.accessToken);
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Clear all stored data
      await secureStorage.clearAll();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await secureStorage.hasToken();
  }
}
