import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meal_planner_app/core/constants/enums.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/core/network/network_exceptions.dart';
import 'package:meal_planner_app/features/goals/data/datasources/goals_remote_datasource.dart';
import 'package:meal_planner_app/features/goals/data/models/tdee_request_model.dart';
import 'package:meal_planner_app/features/goals/domain/entities/nutrition_goal.dart';
import 'package:meal_planner_app/features/goals/domain/entities/tdee_result.dart';
import 'package:meal_planner_app/features/goals/domain/repositories/goals_repository.dart';

/// Implementation of GoalsRepository
class GoalsRepositoryImpl implements GoalsRepository {
  final GoalsRemoteDataSource remoteDataSource;

  GoalsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, NutritionGoal>> getGoals() async {
    try {
      final model = await remoteDataSource.getGoals();
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NutritionGoal>> createGoal({
    required MacroFormat macroFormat,
    required double proteinTarget,
    required double carbTarget,
    required double fatTarget,
    required int calorieTarget,
  }) async {
    try {
      final body = {
        'macro_format': macroFormat.name,
        'protein_target': proteinTarget,
        'carb_target': carbTarget,
        'fat_target': fatTarget,
        'daily_calories': calorieTarget,
      };

      final model = await remoteDataSource.createGoal(body);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TdeeResult>> calculateTdee({
    required int age,
    required double weightKg,
    required double heightCm,
    required Gender gender,
    required ActivityLevel activityLevel,
    required GoalType goal,
  }) async {
    try {
      final request = TdeeRequestModel(
        age: age,
        weightKg: weightKg,
        heightCm: heightCm,
        gender: gender,
        activityLevel: activityLevel,
        goal: goal,
      );

      final model = await remoteDataSource.calculateTdee(request);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
