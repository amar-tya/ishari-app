import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/analytics/analytics_service.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/search/domain/usecases/search_chapters.dart';

part 'search_bloc.freezed.dart';
part 'search_event.dart';
part 'search_state.dart';

const _kDebounceMs = 400;
const _kDefaultCategory = 'Semua';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._searchChapters, this._analytics)
      : super(const SearchState.idle()) {
    on<_QueryChanged>(_onQueryChanged);
    on<_CategorySelected>(_onCategorySelected);
    on<_Cleared>(_onCleared);
  }

  final SearchChapters _searchChapters;
  final AnalyticsService _analytics;

  String _query = '';
  String _category = _kDefaultCategory;
  Timer? _debounce;

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  void _onQueryChanged(_QueryChanged event, Emitter<SearchState> emit) {
    _query = event.query.trim();
    _debounce?.cancel();

    if (_query.isEmpty) {
      emit(const SearchState.idle());
      return;
    }

    emit(const SearchState.loading());
    _debounce = Timer(
      const Duration(milliseconds: _kDebounceMs),
      () => add(SearchEvent.categorySelected(_category)),
    );
  }

  Future<void> _onCategorySelected(
    _CategorySelected event,
    Emitter<SearchState> emit,
  ) async {
    _category = event.category;

    if (_query.isEmpty) {
      // No active query — just remember the new category, stay idle
      return;
    }

    emit(const SearchState.loading());
    await _runSearch(emit);
  }

  void _onCleared(_Cleared event, Emitter<SearchState> emit) {
    _debounce?.cancel();
    _query = '';
    _category = _kDefaultCategory;
    emit(const SearchState.idle());
  }

  Future<void> _runSearch(Emitter<SearchState> emit) async {
    final result = await _searchChapters(
      SearchParams(query: _query, category: _category),
    );

    result.fold(
      (failure) => emit(SearchState.error(failure.message)),
      (chapters) {
        if (chapters.isEmpty) {
          emit(SearchState.empty(query: _query, category: _category));
        } else {
          emit(
            SearchState.results(
              chapters: chapters,
              query: _query,
              category: _category,
            ),
          );
        }
        unawaited(_analytics.logSearch(searchTerm: _query));
      },
    );
  }
}
