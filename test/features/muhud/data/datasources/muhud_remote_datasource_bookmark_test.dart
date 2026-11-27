import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/network/network_info.dart';
import 'package:ishari/features/muhud/data/repositories/muhud_repository_impl.dart';
import 'package:ishari/features/muhud/data/datasources/muhud_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _Online implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}

typedef _Request = ({String method, String table, Map<String, String> query});
typedef _Response = ({int status, Object? body});

/// Loopback stand-in for Supabase. Nothing here leaves the machine.
class _FakeSupabase {
  _FakeSupabase._(this._server) {
    _server.listen(_handle);
  }

  static Future<_FakeSupabase> start() async => _FakeSupabase._(
    await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
  );

  final HttpServer _server;

  /// Requests made to the REST API, in order.
  final requests = <_Request>[];

  /// Responses by `'<METHOD> <table>'`.
  final responses = <String, _Response>{
    'GET users': (status: 200, body: {'id': 7}),
  };

  String get url => 'http://${_server.address.address}:${_server.port}';

  Future<void> close() => _server.close(force: true);

  Future<void> _handle(HttpRequest request) async {
    await request.drain<void>();
    final path = request.uri.pathSegments;
    final _Response response;
    if (path.first == 'auth') {
      response = (status: 200, body: _session());
    } else {
      final table = path.last;
      requests.add((
        method: request.method,
        table: table,
        query: request.uri.queryParameters,
      ));
      response =
          responses['${request.method} $table'] ??
          (status: 500, body: {'message': 'unexpected request'});
    }
    request.response.statusCode = response.status;
    if (response.body != null) {
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode(response.body));
    }
    await request.response.close();
  }

  static Map<String, dynamic> _session() {
    String encode(Object value) =>
        base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
    final token = [
      encode({'alg': 'HS256', 'typ': 'JWT'}),
      encode({'sub': 'dummy', 'exp': 4102444800}),
      'signature',
    ].join('.');
    return {
      'access_token': token,
      'token_type': 'bearer',
      'expires_in': 3600,
      'refresh_token': 'dummy',
      'user': {
        'id': 'dummy',
        'aud': 'authenticated',
        'email': 'reader@example.com',
        'created_at': '2024-01-01T00:00:00Z',
        'app_metadata': <String, dynamic>{},
        'user_metadata': <String, dynamic>{},
      },
    };
  }
}

Map<String, dynamic> _row(int verseId) => {
  'note': 'note $verseId',
  'created_at': '2024-01-02T03:04:05Z',
  'verses': <String, dynamic>{
    'id': verseId,
    'verse_number': verseId,
    'arabic_text': 'arabic',
    'transliteration': 'latin',
    'chapters': {'id': 1, 'title': 'Chapter', 'category': 'Diwan'},
  },
};

void main() {
  late _FakeSupabase server;
  late SupabaseClient client;
  late MuhudRemoteDataSourceImpl dataSource;

  setUp(() async {
    server = await _FakeSupabase.start();
    client = SupabaseClient(
      server.url,
      'dummy-anon-key',
      authOptions: const AuthClientOptions(
        autoRefreshToken: false,
        authFlowType: AuthFlowType.implicit,
      ),
    );
    await client.auth.signInWithPassword(
      email: 'reader@example.com',
      password: 'dummy',
    );
    dataSource = MuhudRemoteDataSourceImpl(client);
  });

  tearDown(() async {
    await client.dispose();
    await server.close();
  });

  _Request requestFor(String method) => server.requests.singleWhere(
    (r) => r.table == 'bookmarks' && r.method == method,
  );

  group('soft-deleted rows', () {
    test('are excluded from bookmarked verse ids', () async {
      server.responses['GET bookmarks'] = (status: 200, body: <Object>[]);

      await dataSource.getBookmarkedVerseIds('u');

      expect(requestFor('GET').query['deleted_at'], 'is.null');
    });

    test('are excluded from the bookmark list', () async {
      server.responses['GET bookmarks'] = (status: 200, body: <Object>[]);

      await dataSource.getBookmarkedVerses('u');

      expect(requestFor('GET').query['deleted_at'], 'is.null');
    });

    test('are ignored by the toggle lookup and delete', () async {
      server.responses['GET bookmarks'] = (
        status: 200,
        body: [
          {'id': 1},
        ],
      );
      server.responses['DELETE bookmarks'] = (status: 204, body: null);

      final bookmarked = await dataSource.toggleBookmark(5, 'u');

      expect(bookmarked, isFalse);
      expect(requestFor('GET').query['deleted_at'], 'is.null');
      expect(requestFor('DELETE').query, {
        'verse_id': 'eq.5',
        'user_id': 'eq.7',
        'deleted_at': 'is.null',
      });
    });

    test('keep their note when a note is updated', () async {
      server.responses['PATCH bookmarks'] = (status: 204, body: null);

      await dataSource.updateBookmarkNote(5, 'new');

      expect(requestFor('PATCH').query['deleted_at'], 'is.null');
    });
  });

  group('toggle insert', () {
    setUp(() {
      server.responses['GET bookmarks'] = (status: 200, body: <Object>[]);
    });

    test('reports bookmarked on success', () async {
      server.responses['POST bookmarks'] = (status: 201, body: null);

      expect(await dataSource.toggleBookmark(5, 'u'), isTrue);
    });

    test('treats a unique violation as already bookmarked', () async {
      server.responses['POST bookmarks'] = (
        status: 409,
        body: {
          'code': '23505',
          'message':
              'duplicate key value violates unique constraint '
              '"unique_user_bookmark"',
        },
      );

      expect(await dataSource.toggleBookmark(5, 'u'), isTrue);
    });

    test('still fails on other database errors', () async {
      server.responses['POST bookmarks'] = (
        status: 403,
        body: {'code': '42501', 'message': 'permission denied'},
      );

      await expectLater(
        dataSource.toggleBookmark(5, 'u'),
        throwsA(isA<ServerException>()),
      );
    });

    test('a failure keeps the database error as its cause only', () async {
      server.responses['POST bookmarks'] = (
        status: 403,
        body: {
          'code': '42501',
          'message': 'permission denied for table bookmarks',
        },
      );

      final error = await dataSource
          .toggleBookmark(5, 'u')
          .then<Object>((_) => fail('expected an error'), onError: (Object e) => e);

      expect(error, isA<ServerException>());
      final exception = error as ServerException;
      expect(exception.cause, isA<PostgrestException>());
      expect(exception.message, isNot(contains('bookmarks')));
      expect(exception.toString(), isNot(contains('permission denied')));
    });

    test('the repository shows a readable text for that failure', () async {
      server.responses['POST bookmarks'] = (
        status: 403,
        body: {
          'code': '42501',
          'message': 'permission denied for table bookmarks',
        },
      );
      final repository = MuhudRepositoryImpl(dataSource, _Online());

      final result = await repository.toggleBookmark(5, 'u');

      expect(
        result.getLeft().toNullable(),
        const ServerFailure(message: FailureMessages.forbidden),
      );
    });
  });

  group('row parsing', () {
    test('skips bad bookmark rows and keeps the rest', () async {
      final nullVerse = _row(2)..['verses'] = null;
      final nullChapter = _row(3);
      (nullChapter['verses'] as Map<String, dynamic>)['chapters'] = null;
      final nullText = _row(4);
      (nullText['verses'] as Map<String, dynamic>)['arabic_text'] = null;
      final badDate = _row(6)..['created_at'] = 'not a date';
      server.responses['GET bookmarks'] = (
        status: 200,
        body: [_row(1), nullVerse, nullChapter, nullText, badDate, _row(7)],
      );

      final bookmarks = await dataSource.getBookmarkedVerses('u');

      expect(bookmarks.map((b) => b.verseId), [1, 7]);
      expect(bookmarks.first.note, 'note 1');
    });

    test('skips bad verse id rows and keeps the rest', () async {
      server.responses['GET bookmarks'] = (
        status: 200,
        body: [
          {'verse_id': 1},
          {'verse_id': null},
          {'verse_id': 'abc'},
          {'verse_id': '7'},
        ],
      );

      expect(await dataSource.getBookmarkedVerseIds('u'), [1, 7]);
    });

    test('still fails when the query itself fails', () async {
      server.responses['GET bookmarks'] = (
        status: 403,
        body: {'code': '42501', 'message': 'permission denied'},
      );

      await expectLater(
        dataSource.getBookmarkedVerses('u'),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
