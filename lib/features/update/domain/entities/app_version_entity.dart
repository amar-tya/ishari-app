import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_version_entity.freezed.dart';

/// Domain entity representing the app version config from the server.
@freezed
abstract class AppVersionEntity with _$AppVersionEntity {
  const factory AppVersionEntity({
    required String minVersion,
    required String latestVersion,
    required String storeUrl,
    required String releaseNotes,
  }) = _AppVersionEntity;
}
