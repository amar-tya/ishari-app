import 'dart:convert';
import 'dart:io';

/// Stands in for the Supabase auth API on 127.0.0.1.
class LoopbackAuthServer {
  LoopbackAuthServer._(this._server) {
    _server.listen((request) async {
      requests.add(request.uri.path);
      await request.drain<void>();
      request.response
        ..statusCode = status
        ..headers.contentType = ContentType.json
        ..write(body);
      await request.response.close();
    });
  }

  static Future<LoopbackAuthServer> start() async => LoopbackAuthServer._(
    await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
  );

  final HttpServer _server;
  final requests = <String>[];
  int status = 204;
  String body = '';

  String get url => 'http://127.0.0.1:${_server.port}';

  /// Nothing listens on the port afterwards: connections fail with a socket
  /// error, as they do without a network.
  Future<void> goOffline() => _server.close(force: true);
}

/// A persisted Supabase session as JSON, with a token that expires in
/// [expiresIn].
String sessionJson({required Duration expiresIn}) {
  String part(Map<String, Object> value) =>
      base64Url.encode(utf8.encode(json.encode(value))).replaceAll('=', '');
  final expiresAt =
      DateTime.now().add(expiresIn).millisecondsSinceEpoch ~/ 1000;
  final token =
      '${part({'alg': 'HS256'})}.${part({'exp': expiresAt})}.signature';
  return json.encode({
    'access_token': token,
    'token_type': 'bearer',
    'refresh_token': 'refresh-token',
    'user': {
      'id': 'user-1',
      'email': 'user@example.com',
      'aud': 'authenticated',
      'created_at': '2026-01-01T00:00:00Z',
      'app_metadata': <String, Object>{},
      'user_metadata': {'full_name': 'Test User'},
    },
  });
}
