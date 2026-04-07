import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/features/muhud/domain/usecases/get_all_chapters.dart';
import 'package:ishari/features/muhud/presentation/bloc/chapter_list_event.dart';
import 'package:ishari/features/muhud/presentation/bloc/chapter_list_state.dart';

@injectable
class ChapterListBloc extends Bloc<ChapterListEvent, ChapterListState> {
  ChapterListBloc({required this.getAllChapters})
    : super(const ChapterListState.initial()) {
    on<ChapterListEvent>((event, emit) async {
      await event.when(load: () => _onLoad(emit));
    });
  }

  final GetAllChapters getAllChapters;

  Future<void> _onLoad(Emitter<ChapterListState> emit) async {
    emit(const ChapterListState.loading());
    final result = await getAllChapters();
    result.fold(
      (failure) => emit(ChapterListState.error(failure.message)),
      (chapters) => emit(ChapterListState.loaded(chapters)),
    );
  }
}
