import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/muhud/domain/usecases/get_all_chapters.dart';
import 'package:ishari/features/muhud/domain/usecases/get_verses_by_chapter.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_event.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_state.dart';
import 'package:ishari/features/muhud/presentation/bloc/split_panel_cubit.dart';
import 'package:ishari/features/muhud/presentation/widgets/chapter_reader_body.dart';
import 'package:ishari/injection_container.dart';

class ChapterReaderPage extends StatelessWidget {
  const ChapterReaderPage({required this.chapterId, super.key});

  static const routePath = '/chapter/:chapterId';

  final int chapterId;

  String _resolveUserId(BuildContext context) {
    return context.read<AuthBloc>().state.maybeWhen(
      authenticated: (user) => user.id,
      orElse: () => '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => sl<MuhudBloc>()
            ..add(
              MuhudEvent.loadChapter(
                chapterId: chapterId,
                userId: _resolveUserId(ctx),
              ),
            ),
        ),
        BlocProvider(
          create: (_) => SplitPanelCubit(
            getAllChapters: sl<GetAllChapters>(),
            getVersesByChapter: sl<GetVersesByChapter>(),
          ),
        ),
      ],
      child: BlocConsumer<MuhudBloc, MuhudState>(
        listenWhen: (prev, curr) =>
            curr.mapOrNull(
              loaded: (l) => l.snackbarMessage,
            ) !=
            null,
        listener: (context, state) {
          final message = state.mapOrNull(loaded: (l) => l.snackbarMessage);
          if (message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
            context.read<MuhudBloc>().add(const MuhudEvent.clearSnackbar());
          }
        },
        builder: (context, state) {
          return state.when(
            initial: () => const Scaffold(
              backgroundColor: Color(0xFFF0F5EE),
              body: SizedBox.shrink(),
            ),
            loading: () => const Scaffold(
              backgroundColor: Color(0xFFF0F5EE),
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFFCAFF00)),
              ),
            ),
            loaded:
                (
                  chapter,
                  verses,
                  bookmarked,
                  showTranslation,
                  playingVerseId,
                  isAudioLoading,
                  showArabic,
                  showTransliteration,
                  arabFontSize,
                  transliterationFontSize,
                  translationFontSize,
                  snackbarMessage,
                ) =>
                    ChapterReaderBody(
                  chapter: chapter,
                  verses: verses,
                  bookmarkedVerseIds: bookmarked,
                  showTranslation: showTranslation,
                  showArabic: showArabic,
                  showTransliteration: showTransliteration,
                  arabFontSize: arabFontSize,
                  transliterationFontSize: transliterationFontSize,
                  translationFontSize: translationFontSize,
                  playingVerseId: playingVerseId,
                ),
            error: (message) => Scaffold(
              backgroundColor: const Color(0xFFF0F5EE),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.wifi_off_outlined,
                        size: 48,
                        color: Color(0xFF79747E),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF79747E)),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => context.read<MuhudBloc>().add(
                          MuhudEvent.loadChapter(
                            chapterId: chapterId,
                            userId: _resolveUserId(context),
                          ),
                        ),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF111111),
                          foregroundColor: const Color(0xFFCAFF00),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
