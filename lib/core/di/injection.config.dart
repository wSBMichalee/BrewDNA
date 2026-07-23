// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/presentation/bloc/auth_cubit.dart' as _i52;
import '../../features/beer/data/repositories/mock_beer_repository.dart' as _i2;
import '../../features/beer/domain/repositories/i_beer_repository.dart'
    as _i425;
import '../../features/onboarding/presentation/bloc/onboarding_cubit.dart'
    as _i153;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i52.AuthCubit>(() => _i52.AuthCubit());
    gh.factory<_i153.OnboardingCubit>(() => _i153.OnboardingCubit());
    gh.lazySingleton<_i425.IBeerRepository>(() => _i2.MockBeerRepository());
    return this;
  }
}
