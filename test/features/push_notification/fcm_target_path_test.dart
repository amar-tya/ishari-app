import 'package:flutter_test/flutter_test.dart';
import 'package:ishari/features/push_notification/data/services/fcm_service.dart';

void main() {
  group('fcmTargetPath', () {
    test('opens the verse when both ids are present', () {
      expect(fcmTargetPath('3', verseId: '41'), '/chapter/3?verseId=41');
    });

    test('opens the audio list for a chapter recording (no verseId)', () {
      expect(fcmTargetPath('3'), '/audio');
      expect(fcmTargetPath('3', verseId: ''), '/audio');
    });

    for (final chapterId in [null, '', 'null', 'abc', '0', '-1', '1/2']) {
      test('never builds a /chapter path for chapterId "$chapterId"', () {
        expect(fcmTargetPath(chapterId, verseId: '41'), '/audio');
      });
    }

    test('does not navigate without any id', () {
      expect(fcmTargetPath(null), isNull);
      expect(fcmTargetPath('', verseId: ''), isNull);
    });

    test('keeps verseId inside its query parameter', () {
      final uri = Uri.parse(fcmTargetPath('3', verseId: '4&x=1')!);

      expect(uri.queryParameters, {'verseId': '4&x=1'});
    });
  });
}
