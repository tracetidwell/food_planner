// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileRemoteDataSourceHash() =>
    r'80e78fe64d5a603f73ed5638f5409a97845ea3d3';

/// See also [profileRemoteDataSource].
@ProviderFor(profileRemoteDataSource)
final profileRemoteDataSourceProvider =
    AutoDisposeProvider<ProfileRemoteDataSource>.internal(
  profileRemoteDataSource,
  name: r'profileRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProfileRemoteDataSourceRef
    = AutoDisposeProviderRef<ProfileRemoteDataSource>;
String _$profileRepositoryHash() => r'858de64cdb5515063be0feb81924a25db6b466a4';

/// See also [profileRepository].
@ProviderFor(profileRepository)
final profileRepositoryProvider =
    AutoDisposeProvider<ProfileRepository>.internal(
  profileRepository,
  name: r'profileRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProfileRepositoryRef = AutoDisposeProviderRef<ProfileRepository>;
String _$getProfileUseCaseHash() => r'f31e08c20f14aecedfe9a2f7a166c2c259fc7471';

/// See also [getProfileUseCase].
@ProviderFor(getProfileUseCase)
final getProfileUseCaseProvider =
    AutoDisposeProvider<GetProfileUseCase>.internal(
  getProfileUseCase,
  name: r'getProfileUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getProfileUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetProfileUseCaseRef = AutoDisposeProviderRef<GetProfileUseCase>;
String _$updateProfileUseCaseHash() =>
    r'7fac24abef86dc05f3b10d7d57b3286781ee416c';

/// See also [updateProfileUseCase].
@ProviderFor(updateProfileUseCase)
final updateProfileUseCaseProvider =
    AutoDisposeProvider<UpdateProfileUseCase>.internal(
  updateProfileUseCase,
  name: r'updateProfileUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateProfileUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UpdateProfileUseCaseRef = AutoDisposeProviderRef<UpdateProfileUseCase>;
String _$profileNotifierHash() => r'5b57f88b5ae012f4c250dd789294b7839a296f5d';

/// See also [ProfileNotifier].
@ProviderFor(ProfileNotifier)
final profileNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ProfileNotifier, UserProfile?>.internal(
  ProfileNotifier.new,
  name: r'profileNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileNotifier = AutoDisposeAsyncNotifier<UserProfile?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
