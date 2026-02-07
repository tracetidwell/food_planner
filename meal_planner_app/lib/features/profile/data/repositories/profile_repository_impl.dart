import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/core/network/network_exceptions.dart';
import 'package:meal_planner_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:meal_planner_app/features/profile/domain/entities/user_profile.dart';
import 'package:meal_planner_app/features/profile/domain/repositories/profile_repository.dart';

/// Implementation of ProfileRepository
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final model = await remoteDataSource.getProfile();
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile({
    String? foodPreferences,
    int? mealsPerDay,
    int? snacksPerDay,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (foodPreferences != null) body['food_preferences'] = foodPreferences;
      if (mealsPerDay != null) body['meals_per_day'] = mealsPerDay;
      if (snacksPerDay != null) body['snacks_per_day'] = snacksPerDay;

      final model = await remoteDataSource.updateProfile(body);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setApiKey(String apiKey) async {
    try {
      await remoteDataSource.setApiKey(apiKey);
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteApiKey() async {
    try {
      await remoteDataSource.deleteApiKey();
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
