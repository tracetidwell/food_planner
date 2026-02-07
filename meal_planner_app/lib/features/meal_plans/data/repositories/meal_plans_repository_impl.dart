import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meal_planner_app/core/error/failures.dart';
import 'package:meal_planner_app/core/network/network_exceptions.dart';
import 'package:meal_planner_app/features/meal_plans/data/datasources/meal_plans_remote_datasource.dart';
import 'package:meal_planner_app/features/meal_plans/data/models/meal_plan_generate_request.dart';
import 'package:meal_planner_app/features/meal_plans/data/models/regenerate_meal_request.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/grocery_list.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/meal_plan.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/planned_meal.dart';
import 'package:meal_planner_app/features/meal_plans/domain/repositories/meal_plans_repository.dart';

/// Implementation of meal plans repository
class MealPlansRepositoryImpl implements MealPlansRepository {
  final MealPlansRemoteDataSource remoteDataSource;

  MealPlansRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MealPlan>> generateMealPlan({
    required DateTime startDate,
    required int durationDays,
  }) async {
    try {
      final request = MealPlanGenerateRequest(
        startDate: startDate.toIso8601String().split('T')[0], // YYYY-MM-DD
        durationDays: durationDays,
      );
      print('[DEBUG] Calling remote data source for meal plan generation');
      final model = await remoteDataSource.generateMealPlan(request);
      print('[DEBUG] Got model from API: ${model.id}');
      print('[DEBUG] Model has ${model.plannedMeals?.length ?? 0} planned meals');
      final entity = model.toEntity();
      print('[DEBUG] Converted to entity: ${entity.id}');
      print('[DEBUG] Entity has ${entity.meals?.length ?? 0} meals');
      return Right(entity);
    } on DioException catch (e) {
      print('[ERROR] DioException in generateMealPlan: $e');
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      print('[ERROR] Exception in generateMealPlan: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MealPlan>>> getMealPlans({
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final models = await remoteDataSource.getMealPlans(
        skip: skip,
        limit: limit,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MealPlan>> getMealPlanById(String id) async {
    try {
      final model = await remoteDataSource.getMealPlanById(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> acceptMealPlan(String id) async {
    try {
      await remoteDataSource.acceptMealPlan(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PlannedMeal>> regenerateMeal({
    required String mealPlanId,
    required String plannedMealId,
  }) async {
    try {
      final request = RegenerateMealRequest(plannedMealId: plannedMealId);
      final model = await remoteDataSource.regenerateMeal(
        mealPlanId: mealPlanId,
        request: request,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMealPlan(String id) async {
    try {
      await remoteDataSource.deleteMealPlan(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GroceryList>> getGroceryList(String mealPlanId) async {
    try {
      final model = await remoteDataSource.getGroceryList(mealPlanId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(NetworkExceptions.dioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
