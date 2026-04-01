import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/domain/usecases/get_all_chapters.dart';
import 'package:ishari/features/muhud/domain/usecases/get_verses_by_chapter.dart';

sealed class SplitPanelState {
  const SplitPanelState();
}

final class SplitPanelInitial extends SplitPanelState {
  const SplitPanelInitial();
}

final class SplitPanelLoading extends SplitPanelState {
  const SplitPanelLoading();
}

final class SplitPanelLoaded extends SplitPanelState {
  const SplitPanelLoaded({required this.chapter, required this.verses});

  final ChapterEntity chapter;
  final List<VerseWithDetailsEntity> verses;
}

final class SplitPanelError extends SplitPanelState {
  const SplitPanelError({required this.message});

  final String message;
}

class SplitPanelCubit extends Cubit<SplitPanelState> {
  SplitPanelCubit({
    required this.getAllChapters,
    required this.getVersesByChapter,
  }) : super(const SplitPanelInitial());

  final GetAllChapters getAllChapters;
  final GetVersesByChapter getVersesByChapter;

  Future<void> loadPairedChapter(ChapterEntity current) async {
    if (state is SplitPanelLoaded) return;
    emit(const SplitPanelLoading());

    final chaptersResult = await getAllChapters();
    List<ChapterEntity>? chapters;
    chaptersResult.fold(
      (failure) => emit(SplitPanelError(message: failure.message)),
      (list) => chapters = list,
    );
    if (chapters == null) return;

    final pairedCategory = current.category == 'Diwan' ? 'Diba' : 'Diwan';
    ChapterEntity? paired;

    // Match by chapter number first
    if (current.number != null) {
      for (final c in chapters!) {
        if (c.category == pairedCategory && c.number == current.number) {
          paired = c;
          break;
        }
      }
    }

    // Fallback: first chapter of the paired category
    if (paired == null) {
      for (final c in chapters!) {
        if (c.category == pairedCategory) {
          paired = c;
          break;
        }
      }
    }

    if (paired == null) {
      emit(const SplitPanelError(message: 'Chapter pasangan tidak ditemukan'));
      return;
    }

    final parsedId = int.tryParse(paired.id);
    if (parsedId == null) {
      emit(const SplitPanelError(message: 'ID chapter tidak valid'));
      return;
    }

    final versesResult = await getVersesByChapter(parsedId);
    versesResult.fold(
      (failure) => emit(SplitPanelError(message: failure.message)),
      (verses) => emit(SplitPanelLoaded(chapter: paired!, verses: verses)),
    );
  }
}
