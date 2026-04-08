import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/features/update/domain/usecases/check_for_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'update_cubit.freezed.dart';
part 'update_state.dart';

@lazySingleton
class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit(this._checkForUpdate) : super(const UpdateState.initial());

  final CheckForUpdate _checkForUpdate;

  Future<void> check() async {
    emit(const UpdateState.checking());
    try {
      final platform = Platform.isAndroid ? 'android' : 'ios';
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final result = await _checkForUpdate(platform);
      result.fold(
        // Fail silently — never block the user for an update check error.
        (failure) => emit(UpdateState.error(failure.message)),
        (entity) {
          if (_isLessThan(currentVersion, entity.minVersion)) {
            emit(UpdateState.forceUpdate(
              storeUrl: entity.storeUrl,
              releaseNotes: entity.releaseNotes,
            ));
          } else if (_isLessThan(currentVersion, entity.latestVersion)) {
            emit(UpdateState.softUpdate(
              latestVersion: entity.latestVersion,
              storeUrl: entity.storeUrl,
              releaseNotes: entity.releaseNotes,
            ));
          } else {
            emit(const UpdateState.upToDate());
          }
        },
      );
    } catch (_) {
      emit(const UpdateState.upToDate());
    }
  }

  /// Returns true if version [a] is strictly less than version [b].
  /// Both must be in "x.y.z" format.
  bool _isLessThan(String a, String b) {
    final aParts = a.split('.').map(int.tryParse).whereType<int>().toList();
    final bParts = b.split('.').map(int.tryParse).whereType<int>().toList();
    final len = aParts.length > bParts.length ? aParts.length : bParts.length;
    for (var i = 0; i < len; i++) {
      final av = i < aParts.length ? aParts[i] : 0;
      final bv = i < bParts.length ? bParts[i] : 0;
      if (av < bv) return true;
      if (av > bv) return false;
    }
    return false;
  }
}
