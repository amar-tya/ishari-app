// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import 'core/network/network_info.dart' as _i75;
import 'features/auth/data/datasources/auth_local_datasource.dart' as _i1043;
import 'features/auth/data/datasources/auth_remote_datasource.dart' as _i588;
import 'features/auth/data/repositories/auth_repository_impl.dart' as _i111;
import 'features/auth/domain/repositories/auth_repository.dart' as _i1015;
import 'features/auth/domain/usecases/get_current_user.dart' as _i191;
import 'features/auth/domain/usecases/sign_in_with_google.dart' as _i648;
import 'features/auth/domain/usecases/sign_out.dart' as _i872;
import 'features/auth/presentation/bloc/auth_bloc.dart' as _i363;
import 'injection_container.dart' as _i809;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt initDependencies(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
  gh.lazySingleton<_i161.InternetConnection>(
    () => registerModule.internetConnection,
  );
  gh.lazySingleton<_i558.FlutterSecureStorage>(
    () => registerModule.secureStorage,
  );
  gh.lazySingleton<_i588.AuthRemoteDataSource>(
    () => _i588.AuthRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
  );
  gh.lazySingleton<_i75.NetworkInfo>(
    () => _i75.NetworkInfoImpl(gh<_i161.InternetConnection>()),
  );
  gh.lazySingleton<_i1043.AuthLocalDataSource>(
    () => _i1043.AuthLocalDataSourceImpl(gh<_i558.FlutterSecureStorage>()),
  );
  gh.lazySingleton<_i1015.AuthRepository>(
    () => _i111.AuthRepositoryImpl(
      gh<_i588.AuthRemoteDataSource>(),
      gh<_i1043.AuthLocalDataSource>(),
      gh<_i75.NetworkInfo>(),
    ),
  );
  gh.lazySingleton<_i191.GetCurrentUser>(
    () => _i191.GetCurrentUser(gh<_i1015.AuthRepository>()),
  );
  gh.lazySingleton<_i648.SignInWithGoogle>(
    () => _i648.SignInWithGoogle(gh<_i1015.AuthRepository>()),
  );
  gh.lazySingleton<_i872.SignOut>(
    () => _i872.SignOut(gh<_i1015.AuthRepository>()),
  );
  gh.factory<_i363.AuthBloc>(
    () => _i363.AuthBloc(
      gh<_i648.SignInWithGoogle>(),
      gh<_i872.SignOut>(),
      gh<_i191.GetCurrentUser>(),
    ),
  );
  return getIt;
}

class _$RegisterModule extends _i809.RegisterModule {}
