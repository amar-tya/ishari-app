import 'package:flutter_test/flutter_test.dart';
import 'package:ishari/features/audio/domain/entities/audio_category.dart';
import 'package:ishari/features/audio/domain/entities/audio_track_entity.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_state.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_sort.dart';

AudioTrackEntity _track({
  required String id,
  required String title,
  required DateTime createdAt,
  String? hadiName,
  String? rodadCabang,
}) => AudioTrackEntity(
  id: id,
  title: title,
  mediaUrl: 'https://example.com/$id.mp3',
  createdAt: createdAt,
  hadiName: hadiName,
  rodadCabang: rodadCabang,
);

void main() {
  // a: Hadi Amir only
  final a = _track(
    id: 'a',
    title: 'Zebra Song',
    hadiName: 'Hadi Amir',
    createdAt: DateTime(2024),
  );
  // b: Hadi Budi only
  final b = _track(
    id: 'b',
    title: 'Apple Song',
    hadiName: 'Hadi Budi',
    createdAt: DateTime(2024, 3),
  );
  // c: chapter "Muhud Track" — no hadi, no rodad_cabang attached. Its own
  // title is what makes it match the "Muhud" (= chapter) filter section.
  final c = _track(id: 'c', title: 'Muhud Track', createdAt: DateTime(2024, 2));
  // d: Hadi Amir AND Rodad Cabang Surabaya at once — this is the real-data
  // shape that surfaced the bug: a track can carry more than one facet.
  final d = _track(
    id: 'd',
    title: 'Rodad Track',
    hadiName: 'Hadi Amir',
    rodadCabang: 'Surabaya',
    createdAt: DateTime(2024, 4),
  );

  final tracks = [a, b, c, d];

  group('filteredSortedTracks — sort', () {
    test('terbaru sorts by createdAt descending', () {
      final state = AudioListState(tracks: tracks);
      expect(
        state.filteredSortedTracks.map((t) => t.id),
        ['d', 'b', 'c', 'a'],
      );
    });

    test('terlama sorts by createdAt ascending', () {
      final state = AudioListState(tracks: tracks, sort: AudioSort.terlama);
      expect(
        state.filteredSortedTracks.map((t) => t.id),
        ['a', 'c', 'b', 'd'],
      );
    });

    test('az sorts by title ascending', () {
      final state = AudioListState(tracks: tracks, sort: AudioSort.az);
      expect(
        state.filteredSortedTracks.map((t) => t.id),
        ['b', 'c', 'd', 'a'],
      );
    });
  });

  group('filteredSortedTracks — search', () {
    test('matches title case-insensitively', () {
      final state = AudioListState(tracks: tracks, query: 'song');
      expect(state.filteredSortedTracks.map((t) => t.id).toSet(), {
        'a',
        'b',
      });
    });

    test('matches hadiName even when title does not match', () {
      final state = AudioListState(tracks: tracks, query: 'amir');
      expect(state.filteredSortedTracks.map((t) => t.id).toSet(), {
        'a',
        'd',
      });
    });

    test('no match yields an empty list', () {
      final state = AudioListState(tracks: tracks, query: 'nonexistent');
      expect(state.filteredSortedTracks, isEmpty);
    });
  });

  group('filteredSortedTracks — facet filter (independent, OR-across-all)', () {
    test(
      'a track with two facets (hadi AND rodad_cabang) matches either '
      'section on its own — this is the real-data regression this covers',
      () {
        final byHadi = AudioListState(
          tracks: tracks,
          appliedSelected: {
            AudioCategory.hadi: {'Hadi Amir'},
          },
        );
        // 'd' has hadiName 'Hadi Amir' too, even though it ALSO has a
        // rodad_cabang — it must still show up under the Hadi filter.
        expect(byHadi.filteredSortedTracks.map((t) => t.id).toSet(), {
          'a',
          'd',
        });

        final byRodad = AudioListState(
          tracks: tracks,
          appliedSelected: {
            AudioCategory.rodadCabang: {'Surabaya'},
          },
        );
        expect(byRodad.filteredSortedTracks.map((t) => t.id).toSet(), {'d'});
      },
    );

    test('selections across sections are unioned (OR, not AND)', () {
      final state = AudioListState(
        tracks: tracks,
        appliedSelected: {
          AudioCategory.hadi: {'Hadi Budi'},
          AudioCategory.muhud: {'Muhud Track'},
        },
      );
      expect(state.filteredSortedTracks.map((t) => t.id).toSet(), {
        'b',
        'c',
      });
    });

    test('filter combined with search narrows further (AND)', () {
      final state = AudioListState(
        tracks: tracks,
        query: 'zebra',
        appliedSelected: {
          AudioCategory.hadi: {'Hadi Amir', 'Hadi Budi'},
        },
      );
      // Matches the Hadi filter (a and d both qualify) AND the search
      // ('zebra') — only 'a' satisfies both.
      expect(state.filteredSortedTracks.map((t) => t.id).toSet(), {'a'});
    });

    test('no selections in any section means no filtering', () {
      final state = AudioListState(tracks: tracks);
      expect(state.filteredSortedTracks.map((t) => t.id).toSet(), {
        'a',
        'b',
        'c',
        'd',
      });
    });
  });

  group('categorySubValues', () {
    test(
      'each section reads its own independent facet across all tracks',
      () {
        final state = AudioListState(tracks: tracks);
        expect(state.categorySubValues[AudioCategory.hadi], [
          'Hadi Amir',
          'Hadi Budi',
        ]);
        // "Muhud" = chapter title, for every track, not just ones flagged
        // by a DB category — that was the exact bug reported and fixed.
        expect(state.categorySubValues[AudioCategory.muhud], [
          'Apple Song',
          'Muhud Track',
          'Rodad Track',
          'Zebra Song',
        ]);
        expect(state.categorySubValues[AudioCategory.rodadCabang], [
          'Surabaya',
        ]);
      },
    );

    test('a section with zero tracks is omitted from the map', () {
      const state = AudioListState();
      expect(state.categorySubValues, isEmpty);
    });
  });

  group('filter counts', () {
    test('totalAppliedFilterCount sums selected values across sections', () {
      final state = AudioListState(
        tracks: tracks,
        appliedSelected: {
          AudioCategory.hadi: {'Hadi Amir', 'Hadi Budi'},
          AudioCategory.muhud: {'Muhud Track'},
        },
      );
      expect(state.totalAppliedFilterCount, 3);
    });

    test('empty selections count as zero', () {
      const state = AudioListState();
      expect(state.totalAppliedFilterCount, 0);
      expect(state.totalDraftFilterCount, 0);
    });
  });

  group('playingTrack', () {
    test('resolves the entity matching playingId', () {
      final state = AudioListState(tracks: tracks, playingId: 'c');
      expect(state.playingTrack?.id, 'c');
    });

    test('is null when nothing is playing', () {
      final state = AudioListState(tracks: tracks);
      expect(state.playingTrack, isNull);
    });
  });
}
