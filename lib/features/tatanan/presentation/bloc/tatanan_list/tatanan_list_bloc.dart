import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_entity.dart';
import 'package:ishari/features/tatanan/domain/usecases/create_tatanan.dart';
import 'package:ishari/features/tatanan/domain/usecases/delete_tatanan.dart';
import 'package:ishari/features/tatanan/domain/usecases/get_tatanan_list.dart';

part 'tatanan_list_bloc.freezed.dart';
part 'tatanan_list_event.dart';
part 'tatanan_list_state.dart';

@injectable
class TatananListBloc extends Bloc<TatananListEvent, TatananListState> {
  TatananListBloc(
    this._getTatananList,
    this._createTatanan,
    this._deleteTatanan,
  ) : super(const TatananListState.initial()) {
    on<_Load>(_onLoad);
    on<_Create>(_onCreate);
    on<_Delete>(_onDelete);
  }

  final GetTatananList _getTatananList;
  final CreateTatanan _createTatanan;
  final DeleteTatanan _deleteTatanan;

  Future<void> _onLoad(_Load event, Emitter<TatananListState> emit) async {
    emit(const TatananListState.loading());
    final result = await _getTatananList(event.userId);
    result.fold(
      (failure) => emit(TatananListState.error(message: failure.message)),
      (tatanans) => emit(TatananListState.loaded(tatanans: tatanans)),
    );
  }

  Future<void> _onCreate(_Create event, Emitter<TatananListState> emit) async {
    final result = await _createTatanan(
      userId: event.userId,
      chapterId: event.chapterId,
      name: event.name,
      description: event.description,
    );
    result.fold(
      (failure) => emit(TatananListState.error(message: failure.message)),
      (tatananId) {
        emit(TatananListState.created(tatananId: tatananId));
        // Refresh list in the background so it's ready when user returns.
        add(TatananListEvent.load(userId: event.userId));
      },
    );
  }

  Future<void> _onDelete(_Delete event, Emitter<TatananListState> emit) async {
    final result = await _deleteTatanan(event.tatananId);
    result.fold(
      (failure) => emit(TatananListState.error(message: failure.message)),
      (_) {
        state.mapOrNull(
          loaded: (l) => emit(
            l.copyWith(
              tatanans:
                  l.tatanans.where((t) => t.id != event.tatananId).toList(),
            ),
          ),
        );
      },
    );
  }
}
