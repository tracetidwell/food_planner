// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plans_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealPlansRemoteDataSourceHash() =>
    r'd84902b9c26ce1444dce5e0e10c1282ea1b33ffa';

/// Provider for meal plans remote data source
///
/// Copied from [mealPlansRemoteDataSource].
@ProviderFor(mealPlansRemoteDataSource)
final mealPlansRemoteDataSourceProvider =
    AutoDisposeProvider<MealPlansRemoteDataSource>.internal(
  mealPlansRemoteDataSource,
  name: r'mealPlansRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mealPlansRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MealPlansRemoteDataSourceRef
    = AutoDisposeProviderRef<MealPlansRemoteDataSource>;
String _$mealPlansRepositoryHash() =>
    r'5ed0c8d5d9df7dda6663e1bc21e06c22db1968c5';

/// Provider for meal plans repository
///
/// Copied from [mealPlansRepository].
@ProviderFor(mealPlansRepository)
final mealPlansRepositoryProvider =
    AutoDisposeProvider<MealPlansRepository>.internal(
  mealPlansRepository,
  name: r'mealPlansRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mealPlansRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MealPlansRepositoryRef = AutoDisposeProviderRef<MealPlansRepository>;
String _$generateMealPlanUseCaseHash() =>
    r'b9483e81099de139a0dc990b2296470d99ed0973';

/// Provider for generate meal plan use case
///
/// Copied from [generateMealPlanUseCase].
@ProviderFor(generateMealPlanUseCase)
final generateMealPlanUseCaseProvider =
    AutoDisposeProvider<GenerateMealPlanUseCase>.internal(
  generateMealPlanUseCase,
  name: r'generateMealPlanUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$generateMealPlanUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GenerateMealPlanUseCaseRef
    = AutoDisposeProviderRef<GenerateMealPlanUseCase>;
String _$getMealPlansUseCaseHash() =>
    r'f39dd156ff77c705a4360880f178ec72802e7a3d';

/// Provider for get meal plans use case
///
/// Copied from [getMealPlansUseCase].
@ProviderFor(getMealPlansUseCase)
final getMealPlansUseCaseProvider =
    AutoDisposeProvider<GetMealPlansUseCase>.internal(
  getMealPlansUseCase,
  name: r'getMealPlansUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getMealPlansUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetMealPlansUseCaseRef = AutoDisposeProviderRef<GetMealPlansUseCase>;
String _$getMealPlanByIdUseCaseHash() =>
    r'c3bb394a6e6f54fa707ff95df78d56acd62d4486';

/// Provider for get meal plan by ID use case
///
/// Copied from [getMealPlanByIdUseCase].
@ProviderFor(getMealPlanByIdUseCase)
final getMealPlanByIdUseCaseProvider =
    AutoDisposeProvider<GetMealPlanByIdUseCase>.internal(
  getMealPlanByIdUseCase,
  name: r'getMealPlanByIdUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getMealPlanByIdUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetMealPlanByIdUseCaseRef
    = AutoDisposeProviderRef<GetMealPlanByIdUseCase>;
String _$acceptMealPlanUseCaseHash() =>
    r'b59b91b396355c839b7da5c3c54f9007e220fbfa';

/// Provider for accept meal plan use case
///
/// Copied from [acceptMealPlanUseCase].
@ProviderFor(acceptMealPlanUseCase)
final acceptMealPlanUseCaseProvider =
    AutoDisposeProvider<AcceptMealPlanUseCase>.internal(
  acceptMealPlanUseCase,
  name: r'acceptMealPlanUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$acceptMealPlanUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AcceptMealPlanUseCaseRef
    = AutoDisposeProviderRef<AcceptMealPlanUseCase>;
String _$regenerateMealUseCaseHash() =>
    r'a1eb9c881245a147083ed84be2e10d769def65e4';

/// Provider for regenerate meal use case
///
/// Copied from [regenerateMealUseCase].
@ProviderFor(regenerateMealUseCase)
final regenerateMealUseCaseProvider =
    AutoDisposeProvider<RegenerateMealUseCase>.internal(
  regenerateMealUseCase,
  name: r'regenerateMealUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$regenerateMealUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RegenerateMealUseCaseRef
    = AutoDisposeProviderRef<RegenerateMealUseCase>;
String _$getGroceryListUseCaseHash() =>
    r'29c407b230279226058595c132d5750524503cb6';

/// Provider for get grocery list use case
///
/// Copied from [getGroceryListUseCase].
@ProviderFor(getGroceryListUseCase)
final getGroceryListUseCaseProvider =
    AutoDisposeProvider<GetGroceryListUseCase>.internal(
  getGroceryListUseCase,
  name: r'getGroceryListUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getGroceryListUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetGroceryListUseCaseRef
    = AutoDisposeProviderRef<GetGroceryListUseCase>;
String _$mealPlanGenerationHash() =>
    r'8a0dab1b73c9361df953afbc18764c7b3721824a';

/// State notifier for meal plan generation flow
///
/// Copied from [MealPlanGeneration].
@ProviderFor(MealPlanGeneration)
final mealPlanGenerationProvider = AutoDisposeNotifierProvider<
    MealPlanGeneration, AsyncValue<MealPlan?>>.internal(
  MealPlanGeneration.new,
  name: r'mealPlanGenerationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mealPlanGenerationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MealPlanGeneration = AutoDisposeNotifier<AsyncValue<MealPlan?>>;
String _$groceryListStateHash() => r'533a36c81a88f03e6c85b90e7dfea7cf710db62a';

/// State notifier for grocery list
///
/// Copied from [GroceryListState].
@ProviderFor(GroceryListState)
final groceryListStateProvider = AutoDisposeNotifierProvider<GroceryListState,
    AsyncValue<GroceryList?>>.internal(
  GroceryListState.new,
  name: r'groceryListStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$groceryListStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GroceryListState = AutoDisposeNotifier<AsyncValue<GroceryList?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
