import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/kitab/domain/usecases/get_chapters_by_book.dart';

sealed class BookChaptersState {
  const BookChaptersState();
}

final class BookChaptersInitial extends BookChaptersState {
  const BookChaptersInitial();
}

final class BookChaptersLoading extends BookChaptersState {
  const BookChaptersLoading();
}

final class BookChaptersLoaded extends BookChaptersState {
  const BookChaptersLoaded({required this.chapters});

  final List<ChapterEntity> chapters;
}

final class BookChaptersError extends BookChaptersState {
  const BookChaptersError({required this.message});

  final String message;
}

/// Loads the chapter list for a single Kitab book, feeding the
/// reading-mode selection sheet on [KitabPage].
class BookChaptersCubit extends Cubit<BookChaptersState> {
  BookChaptersCubit({required this.getChaptersByBook})
    : super(const BookChaptersInitial());

  final GetChaptersByBook getChaptersByBook;

  Future<void> load(int bookId) async {
    emit(const BookChaptersLoading());
    final result = await getChaptersByBook(bookId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(BookChaptersError(message: failure.message)),
      (chapters) => emit(BookChaptersLoaded(chapters: chapters)),
    );
  }
}
