import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_bloc.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_bloc.dart';
import 'package:ishari/features/home/presentation/bloc/home_bloc.dart';
import 'package:ishari/features/kitab/presentation/bloc/book_chapters_cubit.dart';
import 'package:ishari/features/kitab/presentation/bloc/kitab_bloc.dart';
import 'package:ishari/features/kitab/presentation/bloc/kitab_page_reader_cubit.dart';
import 'package:ishari/features/muhud/presentation/bloc/chapter_list_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/split_panel_cubit.dart';
import 'package:ishari/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:ishari/features/search/presentation/bloc/search_bloc.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_detail/tatanan_detail_bloc.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_list/tatanan_list_bloc.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_settings_cubit.dart';
import 'package:ishari/features/update/presentation/cubit/update_cubit.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

typedef BreadcrumbRecorder = FutureOr<void> Function(Breadcrumb breadcrumb);

/// Records which bloc reported an error as a Sentry breadcrumb, because the
/// obfuscated stack frames of a release build do not say.
///
/// A breadcrumb holds only literals written in this file. Events, states and
/// error messages can contain user data and are never read.
class SentryBlocObserver extends BlocObserver {
  const SentryBlocObserver({
    BreadcrumbRecorder addBreadcrumb = Sentry.addBreadcrumb,
  }) : _addBreadcrumb = addBreadcrumb;

  final BreadcrumbRecorder _addBreadcrumb;

  /// Adds this observer next to the one already set in [Bloc.observer].
  static void install({
    BreadcrumbRecorder addBreadcrumb = Sentry.addBreadcrumb,
  }) {
    Bloc.observer = MultiBlocObserver(
      observers: [
        Bloc.observer,
        SentryBlocObserver(addBreadcrumb: addBreadcrumb),
      ],
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    unawaited(_record(bloc, error));
  }

  // Everything before the first await runs inside onError, so the breadcrumb
  // is in place before Bloc.add() rethrows and the error reaches Sentry.
  Future<void> _record(BlocBase<dynamic> bloc, Object error) async {
    try {
      await _addBreadcrumb(
        Breadcrumb(
          category: 'bloc.error',
          level: SentryLevel.error,
          data: {'bloc': _blocName(bloc), 'error_type': _errorType(error)},
        ),
      );
    } on Object catch (_) {
      // Diagnostics must not add a second failure to the one being reported.
    }
  }

  // Obfuscation renames classes, so release builds cannot rely on runtimeType.
  // A test fails if a bloc or cubit in lib/ is missing here.
  static String _blocName(BlocBase<dynamic> bloc) => switch (bloc) {
    AudioListBloc() => 'AudioListBloc',
    AuthBloc() => 'AuthBloc',
    BookChaptersCubit() => 'BookChaptersCubit',
    BookmarkBloc() => 'BookmarkBloc',
    ChapterListBloc() => 'ChapterListBloc',
    HadiDirectoryBloc() => 'HadiDirectoryBloc',
    HomeBloc() => 'HomeBloc',
    KitabBloc() => 'KitabBloc',
    KitabPageReaderCubit() => 'KitabPageReaderCubit',
    MuhudBloc() => 'MuhudBloc',
    NotificationsBloc() => 'NotificationsBloc',
    SearchBloc() => 'SearchBloc',
    SplitPanelCubit() => 'SplitPanelCubit',
    TatananDetailBloc() => 'TatananDetailBloc',
    TatananListBloc() => 'TatananListBloc',
    TatananSettingsCubit() => 'TatananSettingsCubit',
    UpdateCubit() => 'UpdateCubit',
    WizardCubit() => 'WizardCubit',
    _ => 'unknownBloc',
  };

  // Order matters: the general Exception and Error cases must stay last.
  static String _errorType(Object error) => switch (error) {
    StateError() => 'StateError',
    ArgumentError() => 'ArgumentError',
    TypeError() => 'TypeError',
    TimeoutException() => 'TimeoutException',
    FormatException() => 'FormatException',
    Exception() => 'Exception',
    Error() => 'Error',
    _ => 'Object',
  };
}
