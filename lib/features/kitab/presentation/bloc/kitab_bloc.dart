import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/usecases/usecase.dart';
import 'package:ishari/features/kitab/domain/entities/book_entity.dart';
import 'package:ishari/features/kitab/domain/usecases/get_all_books.dart';

part 'kitab_bloc.freezed.dart';
part 'kitab_event.dart';
part 'kitab_state.dart';

@injectable
class KitabBloc extends Bloc<KitabEvent, KitabState> {
  KitabBloc(this._getAllBooks) : super(const KitabState.initial()) {
    on<_Load>(_onLoad);
    on<_Refresh>(_onRefresh);
  }

  final GetAllBooks _getAllBooks;

  Future<void> _onLoad(_Load event, Emitter<KitabState> emit) async {
    emit(const KitabState.loading());
    await _fetch(emit);
  }

  Future<void> _onRefresh(_Refresh event, Emitter<KitabState> emit) async {
    emit(const KitabState.loading());
    await _fetch(emit);
  }

  Future<void> _fetch(Emitter<KitabState> emit) async {
    final result = await _getAllBooks(const NoParams());
    result.fold(
      (failure) => emit(KitabState.error(failure.message)),
      (books) => emit(KitabState.loaded(books)),
    );
  }
}
