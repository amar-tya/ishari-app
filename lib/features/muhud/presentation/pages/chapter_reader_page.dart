import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_event.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_state.dart';
import 'package:ishari/features/muhud/presentation/widgets/chapter_reader_body.dart';
import 'package:ishari/injection_container.dart';

class ChapterReaderPage extends StatelessWidget {
  const ChapterReaderPage({required this.chapterId, super.key});

  static const routePath = '/chapter/:chapterId';

  final int chapterId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MuhudBloc>()..add(MuhudEvent.loadChapter(chapterId: chapterId)),
      child: BlocBuilder<MuhudBloc, MuhudState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Scaffold(
              backgroundColor: Color(0xFFF6F8F7),
              body: SizedBox.shrink(),
            ),
            loading: () => const Scaffold(
              backgroundColor: Color(0xFFF6F8F7),
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFF51C878)),
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
                  isEmbeddedInTab: false,
                ),
            error: (message) => Scaffold(
              backgroundColor: const Color(0xFFF6F8F7),
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
                        onPressed: () => context
                            .read<MuhudBloc>()
                            .add(MuhudEvent.loadChapter(chapterId: chapterId)),
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
          );
        },
      ),
    );
  }
}
