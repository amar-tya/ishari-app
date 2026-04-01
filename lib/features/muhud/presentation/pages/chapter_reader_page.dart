import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_event.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_state.dart';
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
    return BlocProvider(
      create: (ctx) => sl<MuhudBloc>()
        ..add(
          MuhudEvent.loadChapter(
            chapterId: chapterId,
            userId: _resolveUserId(ctx),
          ),
        ),
      child: BlocBuilder<MuhudBloc, MuhudState>(
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
                ) => ChapterReaderBody(
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
