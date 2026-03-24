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
import 'features/home/data/datasources/home_remote_datasource.dart' as _i400;
import 'features/home/data/repositories/home_repository_impl.dart' as _i689;
import 'features/home/domain/repositories/home_repository.dart' as _i649;
import 'features/home/domain/usecases/get_chapters_by_category.dart' as _i853;
import 'features/home/domain/usecases/get_featured_chapter.dart' as _i212;
import 'features/home/domain/usecases/get_hadi_list.dart' as _i316;
import 'features/home/presentation/bloc/home_bloc.dart' as _i123;
import 'features/muhud/data/datasources/muhud_remote_datasource.dart' as _i314;
import 'features/muhud/data/repositories/muhud_repository_impl.dart' as _i964;
import 'features/muhud/domain/repositories/muhud_repository.dart' as _i681;
import 'features/muhud/domain/usecases/get_all_chapters.dart' as _i183;
import 'features/muhud/domain/usecases/get_bookmarked_verse_ids.dart' as _i356;
import 'features/muhud/domain/usecases/get_chapter_by_id.dart' as _i307;
import 'features/muhud/domain/usecases/get_verses_by_chapter.dart' as _i1006;
import 'features/muhud/domain/usecases/toggle_bookmark.dart' as _i718;
import 'features/muhud/presentation/bloc/chapter_list_bloc.dart' as _i242;
import 'features/muhud/presentation/bloc/muhud_bloc.dart' as _i533;
import 'features/search/data/datasources/search_remote_datasource.dart'
    as _i647;
import 'features/search/data/repositories/search_repository_impl.dart' as _i967;
import 'features/search/domain/repositories/search_repository.dart' as _i246;
import 'features/search/domain/usecases/search_chapters.dart' as _i961;
import 'features/search/presentation/bloc/search_bloc.dart' as _i944;
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
  gh.lazySingleton<_i314.MuhudRemoteDataSource>(
    () => _i314.MuhudRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
  );
  gh.lazySingleton<_i647.SearchRemoteDataSource>(
    () => _i647.SearchRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
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
  gh.lazySingleton<_i400.HomeRemoteDataSource>(
    () => _i400.HomeRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
  );
  gh.lazySingleton<_i649.HomeRepository>(
    () => _i689.HomeRepositoryImpl(
      gh<_i400.HomeRemoteDataSource>(),
      gh<_i75.NetworkInfo>(),
    ),
  );
  gh.lazySingleton<_i681.MuhudRepository>(
    () => _i964.MuhudRepositoryImpl(
      gh<_i314.MuhudRemoteDataSource>(),
      gh<_i75.NetworkInfo>(),
    ),
  );
  gh.lazySingleton<_i246.SearchRepository>(
    () => _i967.SearchRepositoryImpl(
      gh<_i647.SearchRemoteDataSource>(),
      gh<_i75.NetworkInfo>(),
    ),
  );
  gh.factory<_i853.GetChaptersByCategory>(
    () => _i853.GetChaptersByCategory(gh<_i649.HomeRepository>()),
  );
  gh.factory<_i212.GetFeaturedChapter>(
    () => _i212.GetFeaturedChapter(gh<_i649.HomeRepository>()),
  );
  gh.factory<_i316.GetHadiList>(
    () => _i316.GetHadiList(gh<_i649.HomeRepository>()),
  );
  gh.lazySingleton<_i1015.AuthRepository>(
    () => _i111.AuthRepositoryImpl(
      gh<_i588.AuthRemoteDataSource>(),
      gh<_i1043.AuthLocalDataSource>(),
      gh<_i75.NetworkInfo>(),
    ),
  );
  gh.factory<_i183.GetAllChapters>(
    () => _i183.GetAllChapters(gh<_i681.MuhudRepository>()),
  );
  gh.factory<_i356.GetBookmarkedVerseIds>(
    () => _i356.GetBookmarkedVerseIds(gh<_i681.MuhudRepository>()),
  );
  gh.factory<_i307.GetChapterById>(
    () => _i307.GetChapterById(gh<_i681.MuhudRepository>()),
  );
  gh.factory<_i1006.GetVersesByChapter>(
    () => _i1006.GetVersesByChapter(gh<_i681.MuhudRepository>()),
  );
  gh.factory<_i718.ToggleBookmark>(
    () => _i718.ToggleBookmark(gh<_i681.MuhudRepository>()),
  );
  gh.factory<_i961.SearchChapters>(
    () => _i961.SearchChapters(gh<_i246.SearchRepository>()),
  );
  gh.factory<_i944.SearchBloc>(
    () => _i944.SearchBloc(gh<_i961.SearchChapters>()),
  );
  gh.factory<_i242.ChapterListBloc>(
    () => _i242.ChapterListBloc(getAllChapters: gh<_i183.GetAllChapters>()),
  );
  gh.factory<_i123.HomeBloc>(
    () => _i123.HomeBloc(
      gh<_i212.GetFeaturedChapter>(),
      gh<_i853.GetChaptersByCategory>(),
      gh<_i316.GetHadiList>(),
    ),
  );
  gh.factory<_i533.MuhudBloc>(
    () => _i533.MuhudBloc(
      getVersesByChapter: gh<_i1006.GetVersesByChapter>(),
      toggleBookmark: gh<_i718.ToggleBookmark>(),
      getBookmarkedVerseIds: gh<_i356.GetBookmarkedVerseIds>(),
      getChapterById: gh<_i307.GetChapterById>(),
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
