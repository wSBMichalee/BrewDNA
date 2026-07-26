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
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/auth/presentation/bloc/auth_cubit.dart' as _i52;
import '../../features/beer/data/repositories/mock_beer_repository.dart' as _i2;
import '../../features/beer/data/repositories/supabase_scan_repository.dart'
    as _i347;
import '../../features/beer/domain/repositories/i_beer_repository.dart'
    as _i425;
import '../../features/beer/domain/repositories/i_scan_repository.dart' as _i83;
import '../../features/beer/presentation/bloc/beer_cubit.dart' as _i378;
import '../../features/beer/presentation/bloc/scan_cubit.dart' as _i1012;
import '../../features/onboarding/presentation/bloc/onboarding_cubit.dart'
    as _i153;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i52.AuthCubit>(() => _i52.AuthCubit());
    gh.factory<_i153.OnboardingCubit>(() => _i153.OnboardingCubit());
    gh.lazySingleton<_i454.SupabaseClient>(() => appModule.supabase);
    gh.lazySingleton<_i425.IBeerRepository>(() => _i2.MockBeerRepository());
    gh.lazySingleton<_i83.IScanRepository>(
      () => _i347.SupabaseScanRepository(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i378.BeerCubit>(
      () => _i378.BeerCubit(gh<_i425.IBeerRepository>()),
    );
    gh.factory<_i1012.ScanCubit>(
      () => _i1012.ScanCubit(gh<_i83.IScanRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
