import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/update/domain/entities/app_version_entity.dart';

part 'app_version_model.freezed.dart';
part 'app_version_model.g.dart';

@freezed
abstract class AppVersionModel with _$AppVersionModel {
  const factory AppVersionModel({
    @JsonKey(name: 'min_version') required String minVersion,
    @JsonKey(name: 'latest_version') required String latestVersion,
    @JsonKey(name: 'store_url') required String storeUrl,
    @JsonKey(name: 'release_notes') required String releaseNotes,
  }) = _AppVersionModel;

  factory AppVersionModel.fromJson(Map<String, dynamic> json) =>
      _$AppVersionModelFromJson(json);
}

extension AppVersionModelX on AppVersionModel {
  AppVersionEntity toEntity() => AppVersionEntity(
        minVersion: minVersion,
        latestVersion: latestVersion,
        storeUrl: storeUrl,
        releaseNotes: releaseNotes,
      );
}
