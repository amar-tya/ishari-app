import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_event.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_state.dart';
import 'package:ishari/features/muhud/presentation/widgets/chapter_reader_body.dart';
import 'package:ishari/injection_container.dart';

/// Muhud tab — provides [MuhudBloc] and renders the chapter reader inline
/// (keeps the bottom nav bar visible).
class MuhudTab extends StatelessWidget {
  const MuhudTab({super.key});

  static const _defaultChapterId = 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MuhudBloc>()
        ..add(const MuhudEvent.loadChapter(chapterId: _defaultChapterId)),
      child: const _MuhudTabBody(),
    );
  }
}

class _MuhudTabBody extends StatefulWidget {
  const _MuhudTabBody();

  @override
  State<_MuhudTabBody> createState() => _MuhudTabBodyState();
}

class _MuhudTabBodyState extends State<_MuhudTabBody> {
  @override
  void initState() {
    super.initState();
    AppState.muhudChapterRequest.addListener(_onChapterRequest);
  }

  @override
  void dispose() {
    AppState.muhudChapterRequest.removeListener(_onChapterRequest);
    super.dispose();
  }

  void _onChapterRequest() {
    final chapterId = AppState.muhudChapterRequest.value;
    if (chapterId != null) {
      context
          .read<MuhudBloc>()
          .add(MuhudEvent.loadChapter(chapterId: chapterId));
      AppState.muhudChapterRequest.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MuhudBloc, MuhudState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Scaffold(
            backgroundColor: Color(0xFFF6F8F7),
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF51C878)),
              ),
            ),
          ),
          loaded: (chapter, verses, bookmarked, showTranslation,
                  playingVerseId, isAudioLoading, showArabic,
                  showTransliteration) =>
              ChapterReaderBody(
                chapter: chapter,
                verses: verses,
                bookmarkedVerseIds: bookmarked,
                showTranslation: showTranslation,
                showArabic: showArabic,
                showTransliteration: showTransliteration,
                playingVerseId: playingVerseId,
                isEmbeddedInTab: true,
              ),
          error: (message) => Scaffold(
            backgroundColor: const Color(0xFFF6F8F7),
            body: SafeArea(
              child: Center(
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
                              const MuhudEvent.loadChapter(
                                  chapterId: MuhudTab._defaultChapterId),
                            ),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF51C878),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
