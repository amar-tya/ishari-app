import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_entity.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_verse_entity.dart';
import 'package:ishari/features/tatanan/domain/repositories/tatanan_repository.dart';
import 'package:ishari/features/tatanan/domain/usecases/add_verse_to_tatanan.dart';
import 'package:ishari/features/tatanan/domain/usecases/get_tatanan_by_id.dart';
import 'package:ishari/features/tatanan/domain/usecases/get_tatanan_detail.dart';
import 'package:ishari/features/tatanan/domain/usecases/remove_verse_from_tatanan.dart';
import 'package:ishari/features/tatanan/domain/usecases/reorder_tatanan_verses.dart';

part 'tatanan_detail_bloc.freezed.dart';
part 'tatanan_detail_event.dart';
part 'tatanan_detail_state.dart';

@injectable
class TatananDetailBloc extends Bloc<TatananDetailEvent, TatananDetailState> {
  TatananDetailBloc(
    this._getTatananById,
    this._getTatananDetail,
    this._addVerseToTatanan,
    this._removeVerseFromTatanan,
    this._reorderTatananVerses,
  ) : super(const TatananDetailState.initial()) {
    on<_Load>(_onLoad);
    on<_ToggleEditMode>(_onToggleEditMode);
    on<_AddVerses>(_onAddVerses);
    on<_RemoveVerse>(_onRemoveVerse);
    on<_Reorder>(_onReorder);
  }

  final GetTatananById _getTatananById;
  final GetTatananDetail _getTatananDetail;
  final AddVerseToTatanan _addVerseToTatanan;
  final RemoveVerseFromTatanan _removeVerseFromTatanan;
  final ReorderTatananVerses _reorderTatananVerses;

  Future<void> _onLoad(_Load event, Emitter<TatananDetailState> emit) async {
    emit(const TatananDetailState.loading());

    final tatananResult = await _getTatananById(event.tatananId);
    TatananEntity? tatanan;
    var hadError = false;
    tatananResult.fold(
      (f) {
        emit(TatananDetailState.error(message: f.message));
        hadError = true;
      },
      (t) => tatanan = t,
    );
    if (hadError || tatanan == null) return;

    final versesResult = await _getTatananDetail(event.tatananId);
    versesResult.fold(
      (f) => emit(TatananDetailState.error(message: f.message)),
      (verses) => emit(
        TatananDetailState.loaded(tatanan: tatanan!, verses: verses),
      ),
    );
  }

  void _onToggleEditMode(
    _ToggleEditMode event,
    Emitter<TatananDetailState> emit,
  ) {
    state.mapOrNull(
      loaded: (l) => emit(l.copyWith(isEditMode: !l.isEditMode)),
    );
  }

  Future<void> _onAddVerses(
    _AddVerses event,
    Emitter<TatananDetailState> emit,
  ) async {
    final loaded = state.mapOrNull(loaded: (l) => l);
    if (loaded == null) return;

    // Calculate starting position
    final currentMax = loaded.verses.isEmpty
        ? 0
        : loaded.verses.map((v) => v.position).reduce(max);

    var nextPosition = currentMax + 1;
    for (final verseId in event.verseIds) {
      await _addVerseToTatanan(
        tatananId: event.tatananId,
        verseId: verseId,
        position: nextPosition++,
      );
    }

    // Reload
    add(TatananDetailEvent.load(tatananId: event.tatananId));
  }

  Future<void> _onRemoveVerse(
    _RemoveVerse event,
    Emitter<TatananDetailState> emit,
  ) async {
    final loaded = state.mapOrNull(loaded: (l) => l);
    if (loaded == null) return;

    final result = await _removeVerseFromTatanan(
      tatananId: event.tatananId,
      verseId: event.verseId,
    );

    await result.fold(
      (_) async {},
      (_) async {
        // Optimistic update: remove from list and renumber
        final remaining = loaded.verses
            .where((v) => v.verseId != event.verseId)
            .toList();
        final reNumbered = remaining
            .asMap()
            .entries
            .map((e) => e.value.copyWith(position: e.key + 1))
            .toList();

        emit(loaded.copyWith(verses: reNumbered));

        // Persist new positions if any remain
        if (reNumbered.isNotEmpty) {
          final updates = reNumbered
              .map(
                (v) =>
                    VersePositionUpdate(verseId: v.verseId, position: v.position),
              )
              .toList();
          await _reorderTatananVerses(
            tatananId: event.tatananId,
            updates: updates,
          );
        }
      },
    );
  }

  Future<void> _onReorder(
    _Reorder event,
    Emitter<TatananDetailState> emit,
  ) async {
    final loaded = state.mapOrNull(loaded: (l) => l);
    if (loaded == null) return;

    // Optimistic update
    final posMap = {for (final u in event.updates) u.verseId: u.position};
    final updated = loaded.verses
        .map((v) => v.copyWith(position: posMap[v.verseId] ?? v.position))
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));

    emit(loaded.copyWith(verses: updated));

    // Persist to DB
    await _reorderTatananVerses(
      tatananId: event.tatananId,
      updates: event.updates,
    );
  }
}
