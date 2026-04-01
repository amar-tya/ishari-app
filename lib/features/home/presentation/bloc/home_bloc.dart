import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/usecases/usecase.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/home/domain/entities/hadi_entity.dart';
import 'package:ishari/features/home/domain/usecases/get_chapters_by_category.dart';
import 'package:ishari/features/home/domain/usecases/get_featured_chapter.dart';
import 'package:ishari/features/home/domain/usecases/get_hadi_list.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

const _kDefaultCategory = 'Diwan';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    this._getFeaturedChapter,
    this._getChaptersByCategory,
    this._getHadiList,
  ) : super(const HomeState.initial()) {
    on<_Load>(_onLoad);
    on<_CategorySelected>(_onCategorySelected);
    on<_Refresh>(_onRefresh);
  }

  final GetFeaturedChapter _getFeaturedChapter;
  final GetChaptersByCategory _getChaptersByCategory;
  final GetHadiList _getHadiList;

  Future<void> _onLoad(_Load event, Emitter<HomeState> emit) async {
    emit(const HomeState.loading());
    await _fetchAll(
      emit,
      category: _kDefaultCategory,
      userId: event.userId,
    );
  }

  Future<void> _onCategorySelected(
    _CategorySelected event,
    Emitter<HomeState> emit,
  ) async {
    // Optimistically update selectedCategory while fetching new chapters
    final current = state;
    if (current is _Loaded) {
      emit(current.copyWith(selectedCategory: event.category));
    }

    final result = await _getChaptersByCategory(CategoryParams(event.category));
    result.fold(
      (failure) => emit(HomeState.error(failure.message)),
      (chapters) {
        final loaded = state;
        if (loaded is _Loaded) {
          emit(
            loaded.copyWith(
              chapters: chapters,
              selectedCategory: event.category,
            ),
          );
        }
      },
    );
  }

  Future<void> _onRefresh(_Refresh event, Emitter<HomeState> emit) async {
    final current = state;
    final category = current is _Loaded
        ? current.selectedCategory
        : _kDefaultCategory;
    // Emit loading first so the stream always fires, even when the fetched data
    // is identical to the current state (BlocBase.emit deduplicates equal states).
    emit(const HomeState.loading());
    await _fetchAll(emit, category: category, userId: event.userId);
  }

  Future<void> _fetchAll(
    Emitter<HomeState> emit, {
    required String category,
    String? userId,
  }) async {
    // Start all 3 fetches in parallel
    final featuredFuture = _getFeaturedChapter(const FeaturedChapterParams());
    final chaptersFuture = _getChaptersByCategory(CategoryParams(category));
    final hadiFuture = _getHadiList(const NoParams());

    final featuredResult = await featuredFuture;
    final chaptersResult = await chaptersFuture;
    final hadiResult = await hadiFuture;

    String? error;
    featuredResult.fold((f) => error = f.message, (_) {});
    if (error != null) {
      emit(HomeState.error(error!));
      return;
    }

    chaptersResult.fold((f) => error = f.message, (_) {});
    if (error != null) {
      emit(HomeState.error(error!));
      return;
    }

    hadiResult.fold((f) => error = f.message, (_) {});
    if (error != null) {
      emit(HomeState.error(error!));
      return;
    }

    emit(
      HomeState.loaded(
        featuredChapter: featuredResult.getOrElse(
          (_) => throw StateError('unreachable'),
        ),
        chapters: chaptersResult.getOrElse(
          (_) => throw StateError('unreachable'),
        ),
        selectedCategory: category,
        hadiList: hadiResult.getOrElse((_) => throw StateError('unreachable')),
      ),
    );
  }
}
