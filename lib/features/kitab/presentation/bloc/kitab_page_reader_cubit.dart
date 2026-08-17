import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/kitab/domain/entities/book_page_entity.dart';
import 'package:ishari/features/kitab/domain/usecases/get_pages_by_chapter.dart';

sealed class KitabPageReaderState {
  const KitabPageReaderState();
}

final class KitabPageReaderInitial extends KitabPageReaderState {
  const KitabPageReaderInitial();
}

final class KitabPageReaderLoading extends KitabPageReaderState {
  const KitabPageReaderLoading();
}

final class KitabPageReaderLoaded extends KitabPageReaderState {
  const KitabPageReaderLoaded({required this.pages});

  final List<BookPageEntity> pages;
}

final class KitabPageReaderError extends KitabPageReaderState {
  const KitabPageReaderError({required this.message});

  final String message;
}

/// Loads the pre-rendered page images for the per-halaman reading mode.
class KitabPageReaderCubit extends Cubit<KitabPageReaderState> {
  KitabPageReaderCubit({required this.getPagesByChapter})
    : super(const KitabPageReaderInitial());

  final GetPagesByChapter getPagesByChapter;

  Future<void> load(int chapterId) async {
    emit(const KitabPageReaderLoading());
    final result = await getPagesByChapter(chapterId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(KitabPageReaderError(message: failure.message)),
      (pages) => emit(KitabPageReaderLoaded(pages: pages)),
    );
  }
}
