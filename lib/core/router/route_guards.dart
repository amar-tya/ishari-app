/// Pure checks for route input that comes from outside the app (deep links,
/// push payloads, route restoration) and therefore cannot be trusted.
library;

/// Parses a database id taken from a path or push payload.
///
/// Returns `null` unless [raw] is a positive integer.
int? parseRouteId(String? raw) {
  final id = int.tryParse(raw ?? '');
  return id != null && id > 0 ? id : null;
}

/// Reads the force-update route's `extra`.
///
/// [extra] may be any type: anything that is not a `String` entry of a `Map`
/// comes back as an empty string.
({String storeUrl, String releaseNotes}) parseForceUpdateExtra(Object? extra) {
  String read(String key) {
    final value = extra is Map ? extra[key] : null;
    return value is String ? value : '';
  }

  return (storeUrl: read('storeUrl'), releaseNotes: read('releaseNotes'));
}
