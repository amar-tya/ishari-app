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
import 'package:shared_preferences/shared_preferences.dart' as _i460;
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
import 'features/bookmark/presentation/bloc/bookmark_bloc.dart' as _i560;
import 'features/home/data/datasources/home_remote_datasource.dart' as _i400;
import 'features/home/data/repositories/home_repository_impl.dart' as _i689;
import 'features/home/domain/repositories/home_repository.dart' as _i649;
import 'features/home/domain/usecases/get_chapters_by_category.dart' as _i853;
import 'features/home/domain/usecases/get_featured_chapter.dart' as _i212;
import 'features/home/domain/usecases/get_hadi_list.dart' as _i316;
import 'features/home/presentation/bloc/home_bloc.dart' as _i123;
import 'features/kitab/data/datasources/kitab_remote_datasource.dart' as _i914;
import 'features/kitab/data/repositories/kitab_repository_impl.dart' as _i918;
import 'features/kitab/domain/repositories/kitab_repository.dart' as _i430;
import 'features/kitab/domain/usecases/get_all_books.dart' as _i395;
import 'features/kitab/presentation/bloc/kitab_bloc.dart' as _i468;
import 'features/muhud/data/datasources/muhud_remote_datasource.dart' as _i314;
import 'features/muhud/data/repositories/muhud_repository_impl.dart' as _i964;
import 'features/muhud/domain/repositories/muhud_repository.dart' as _i681;
import 'features/muhud/domain/usecases/get_all_chapters.dart' as _i183;
import 'features/muhud/domain/usecases/get_bookmarked_verse_ids.dart' as _i356;
import 'features/muhud/domain/usecases/get_bookmarked_verses.dart' as _i718;
import 'features/muhud/domain/usecases/get_chapter_by_id.dart' as _i307;
import 'features/muhud/domain/usecases/get_verses_by_chapter.dart' as _i1006;
import 'features/muhud/domain/usecases/toggle_bookmark.dart' as _i718;
import 'features/muhud/domain/usecases/update_bookmark_note.dart' as _i851;
import 'features/muhud/presentation/bloc/chapter_list_bloc.dart' as _i242;
import 'features/muhud/presentation/bloc/muhud_bloc.dart' as _i533;
import 'features/notifications/data/datasources/notifications_remote_datasource.dart'
    as _i555;
import 'features/notifications/data/repositories/notifications_repository_impl.dart'
    as _i804;
import 'features/notifications/domain/repositories/notifications_repository.dart'
    as _i332;
import 'features/notifications/domain/usecases/get_notifications.dart' as _i397;
import 'features/notifications/domain/usecases/mark_all_notifications_read.dart'
    as _i506;
import 'features/notifications/presentation/bloc/notifications_bloc.dart'
    as _i772;
import 'features/search/data/datasources/search_remote_datasource.dart'
    as _i647;
import 'features/search/data/repositories/search_repository_impl.dart' as _i967;
import 'features/search/domain/repositories/search_repository.dart' as _i246;
import 'features/search/domain/usecases/search_chapters.dart' as _i961;
import 'features/search/presentation/bloc/search_bloc.dart' as _i944;
import 'features/tatanan/data/datasources/tatanan_remote_datasource.dart'
    as _i437;
import 'features/tatanan/data/repositories/tatanan_repository_impl.dart'
    as _i948;
import 'features/tatanan/domain/repositories/tatanan_repository.dart' as _i132;
import 'features/tatanan/domain/usecases/add_verse_to_tatanan.dart' as _i506;
import 'features/tatanan/domain/usecases/create_tatanan.dart' as _i464;
import 'features/tatanan/domain/usecases/delete_tatanan.dart' as _i845;
import 'features/tatanan/domain/usecases/get_tatanan_by_id.dart' as _i347;
import 'features/tatanan/domain/usecases/get_tatanan_detail.dart' as _i842;
import 'features/tatanan/domain/usecases/get_tatanan_list.dart' as _i203;
import 'features/tatanan/domain/usecases/remove_verse_from_tatanan.dart'
    as _i381;
import 'features/tatanan/domain/usecases/reorder_tatanan_verses.dart' as _i369;
import 'features/tatanan/presentation/bloc/tatanan_detail/tatanan_detail_bloc.dart'
    as _i946;
import 'features/tatanan/presentation/bloc/tatanan_list/tatanan_list_bloc.dart'
    as _i873;
import 'features/update/data/datasources/update_remote_datasource.dart'
    as _i354;
import 'features/update/data/repositories/update_repository_impl.dart' as _i75;
import 'features/update/domain/repositories/update_repository.dart' as _i549;
import 'features/update/domain/usecases/check_for_update.dart' as _i289;
import 'features/update/presentation/cubit/update_cubit.dart' as _i217;
import 'injection_container.dart' as _i809;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> initDependencies(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  await gh.singletonAsync<_i460.SharedPreferences>(
    () => registerModule.prefs,
    preResolve: true,
  );
  gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
  gh.lazySingleton<_i161.InternetConnection>(
    () => registerModule.internetConnection,
  );
  gh.lazySingleton<_i558.FlutterSecureStorage>(
    () => registerModule.secureStorage,
  );
  gh.lazySingleton<_i555.NotificationsRemoteDatasource>(
    () => _i555.NotificationsRemoteDatasourceImpl(gh<_i454.SupabaseClient>()),
  );
  gh.lazySingleton<_i354.UpdateRemoteDataSource>(
    () => _i354.UpdateRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
  );
  gh.lazySingleton<_i549.UpdateRepository>(
    () => _i75.UpdateRepositoryImpl(gh<_i354.UpdateRemoteDataSource>()),
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
  gh.lazySingleton<_i289.CheckForUpdate>(
    () => _i289.CheckForUpdate(gh<_i549.UpdateRepository>()),
  );
  gh.lazySingleton<_i914.KitabRemoteDataSource>(
    () => _i914.KitabRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
  );
  gh.lazySingleton<_i437.TatananRemoteDataSource>(
    () => _i437.TatananRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
  );
  gh.lazySingleton<_i75.NetworkInfo>(
    () => _i75.NetworkInfoImpl(gh<_i161.InternetConnection>()),
  );
  gh.lazySingleton<_i217.UpdateCubit>(
    () => _i217.UpdateCubit(gh<_i289.CheckForUpdate>()),
  );
  gh.lazySingleton<_i1043.AuthLocalDataSource>(
    () => _i1043.AuthLocalDataSourceImpl(gh<_i558.FlutterSecureStorage>()),
  );
  gh.lazySingleton<_i132.TatananRepository>(
    () => _i948.TatananRepositoryImpl(
      gh<_i437.TatananRemoteDataSource>(),
      gh<_i75.NetworkInfo>(),
    ),
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
  gh.lazySingleton<_i430.KitabRepository>(
    () => _i918.KitabRepositoryImpl(
      gh<_i914.KitabRemoteDataSource>(),
      gh<_i75.NetworkInfo>(),
    ),
  );
  gh.lazySingleton<_i681.MuhudRepository>(
    () => _i964.MuhudRepositoryImpl(
      gh<_i314.MuhudRemoteDataSource>(),
      gh<_i75.NetworkInfo>(),
    ),
  );
  gh.lazySingleton<_i332.NotificationsRepository>(
    () => _i804.NotificationsRepositoryImpl(
      gh<_i555.NotificationsRemoteDatasource>(),
      gh<_i75.NetworkInfo>(),
      gh<_i460.SharedPreferences>(),
    ),
  );
  gh.lazySingleton<_i246.SearchRepository>(
    () => _i967.SearchRepositoryImpl(
      gh<_i647.SearchRemoteDataSource>(),
      gh<_i75.NetworkInfo>(),
    ),
  );
  gh.factory<_i395.GetAllBooks>(
    () => _i395.GetAllBooks(gh<_i430.KitabRepository>()),
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
  gh.factory<_i506.AddVerseToTatanan>(
    () => _i506.AddVerseToTatanan(gh<_i132.TatananRepository>()),
  );
  gh.factory<_i464.CreateTatanan>(
    () => _i464.CreateTatanan(gh<_i132.TatananRepository>()),
  );
  gh.factory<_i845.DeleteTatanan>(
    () => _i845.DeleteTatanan(gh<_i132.TatananRepository>()),
  );
  gh.factory<_i347.GetTatananById>(
    () => _i347.GetTatananById(gh<_i132.TatananRepository>()),
  );
  gh.factory<_i842.GetTatananDetail>(
    () => _i842.GetTatananDetail(gh<_i132.TatananRepository>()),
  );
  gh.factory<_i203.GetTatananList>(
    () => _i203.GetTatananList(gh<_i132.TatananRepository>()),
  );
  gh.factory<_i381.RemoveVerseFromTatanan>(
    () => _i381.RemoveVerseFromTatanan(gh<_i132.TatananRepository>()),
  );
  gh.factory<_i369.ReorderTatananVerses>(
    () => _i369.ReorderTatananVerses(gh<_i132.TatananRepository>()),
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
  gh.factory<_i718.GetBookmarkedVerses>(
    () => _i718.GetBookmarkedVerses(gh<_i681.MuhudRepository>()),
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
  gh.factory<_i851.UpdateBookmarkNote>(
    () => _i851.UpdateBookmarkNote(gh<_i681.MuhudRepository>()),
  );
  gh.factory<_i468.KitabBloc>(() => _i468.KitabBloc(gh<_i395.GetAllBooks>()));
  gh.factory<_i961.SearchChapters>(
    () => _i961.SearchChapters(gh<_i246.SearchRepository>()),
  );
  gh.factory<_i946.TatananDetailBloc>(
    () => _i946.TatananDetailBloc(
      gh<_i347.GetTatananById>(),
      gh<_i842.GetTatananDetail>(),
      gh<_i506.AddVerseToTatanan>(),
      gh<_i381.RemoveVerseFromTatanan>(),
      gh<_i369.ReorderTatananVerses>(),
    ),
  );
  gh.factory<_i560.BookmarkBloc>(
    () => _i560.BookmarkBloc(
      gh<_i718.GetBookmarkedVerses>(),
      gh<_i718.ToggleBookmark>(),
      gh<_i851.UpdateBookmarkNote>(),
    ),
  );
  gh.factory<_i397.GetNotifications>(
    () => _i397.GetNotifications(gh<_i332.NotificationsRepository>()),
  );
  gh.factory<_i506.MarkAllNotificationsRead>(
    () => _i506.MarkAllNotificationsRead(gh<_i332.NotificationsRepository>()),
  );
  gh.factory<_i944.SearchBloc>(
    () => _i944.SearchBloc(gh<_i961.SearchChapters>()),
  );
  gh.factory<_i242.ChapterListBloc>(
    () => _i242.ChapterListBloc(getAllChapters: gh<_i183.GetAllChapters>()),
  );
  gh.factory<_i533.MuhudBloc>(
    () => _i533.MuhudBloc(
      getVersesByChapter: gh<_i1006.GetVersesByChapter>(),
      toggleBookmark: gh<_i718.ToggleBookmark>(),
      getBookmarkedVerseIds: gh<_i356.GetBookmarkedVerseIds>(),
      getChapterById: gh<_i307.GetChapterById>(),
      prefs: gh<_i460.SharedPreferences>(),
    ),
  );
  gh.factory<_i123.HomeBloc>(
    () => _i123.HomeBloc(
      gh<_i212.GetFeaturedChapter>(),
      gh<_i853.GetChaptersByCategory>(),
      gh<_i316.GetHadiList>(),
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
  gh.factory<_i873.TatananListBloc>(
    () => _i873.TatananListBloc(
      gh<_i203.GetTatananList>(),
      gh<_i464.CreateTatanan>(),
      gh<_i845.DeleteTatanan>(),
    ),
  );
  gh.lazySingleton<_i772.NotificationsBloc>(
    () => _i772.NotificationsBloc(
      gh<_i397.GetNotifications>(),
      gh<_i506.MarkAllNotificationsRead>(),
    ),
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
