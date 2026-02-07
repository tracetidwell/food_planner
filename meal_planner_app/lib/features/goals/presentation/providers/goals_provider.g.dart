// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$goalsRemoteDataSourceHash() =>
    r'ca89eb2e4013fc80545ee55e7867985a84950e19';

/// See also [goalsRemoteDataSource].
@ProviderFor(goalsRemoteDataSource)
final goalsRemoteDataSourceProvider =
    AutoDisposeProvider<GoalsRemoteDataSource>.internal(
  goalsRemoteDataSource,
  name: r'goalsRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$goalsRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GoalsRemoteDataSourceRef
    = AutoDisposeProviderRef<GoalsRemoteDataSource>;
String _$goalsRepositoryHash() => r'86947255b13608a0f9a3775a47150821122d98d2';

/// See also [goalsRepository].
@ProviderFor(goalsRepository)
final goalsRepositoryProvider = AutoDisposeProvider<GoalsRepository>.internal(
  goalsRepository,
  name: r'goalsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$goalsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GoalsRepositoryRef = AutoDisposeProviderRef<GoalsRepository>;
String _$calculateTdeeUseCaseHash() =>
    r'de867906c0ac14e191e3f1c333844a838d7fa89b';

/// See also [calculateTdeeUseCase].
@ProviderFor(calculateTdeeUseCase)
final calculateTdeeUseCaseProvider =
    AutoDisposeProvider<CalculateTdeeUseCase>.internal(
  calculateTdeeUseCase,
  name: r'calculateTdeeUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$calculateTdeeUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CalculateTdeeUseCaseRef = AutoDisposeProviderRef<CalculateTdeeUseCase>;
String _$createGoalUseCaseHash() => r'27016e43fa919233de082c07ad4f47aa572537d0';

/// See also [createGoalUseCase].
@ProviderFor(createGoalUseCase)
final createGoalUseCaseProvider =
    AutoDisposeProvider<CreateGoalUseCase>.internal(
  createGoalUseCase,
  name: r'createGoalUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createGoalUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CreateGoalUseCaseRef = AutoDisposeProviderRef<CreateGoalUseCase>;
String _$getGoalsUseCaseHash() => r'f6316ed175f13c46edc99d418ed8b5d616ec6c6c';

/// See also [getGoalsUseCase].
@ProviderFor(getGoalsUseCase)
final getGoalsUseCaseProvider = AutoDisposeProvider<GetGoalsUseCase>.internal(
  getGoalsUseCase,
  name: r'getGoalsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getGoalsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetGoalsUseCaseRef = AutoDisposeProviderRef<GetGoalsUseCase>;
String _$goalsHash() => r'0d62d52773b1bdd007fd4693b7d637707346490c';

/// See also [Goals].
@ProviderFor(Goals)
final goalsProvider =
    AutoDisposeAsyncNotifierProvider<Goals, NutritionGoal?>.internal(
  Goals.new,
  name: r'goalsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$goalsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Goals = AutoDisposeAsyncNotifier<NutritionGoal?>;
String _$tdeeHash() => r'c13586322b690e6d3a62014787182dc3dcc17e94';

/// See also [Tdee].
@ProviderFor(Tdee)
final tdeeProvider = AutoDisposeNotifierProvider<Tdee, TdeeResult?>.internal(
  Tdee.new,
  name: r'tdeeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tdeeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Tdee = AutoDisposeNotifier<TdeeResult?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
