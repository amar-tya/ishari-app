import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Which feature currently "owns" the single app-wide audio session.
///
/// Only one owner may play sound at a time — `AudioListBloc` (audio catalog
/// tracks) and `MuhudBloc` (per-verse chapter reader audio) each hold their
/// own player, so nothing stops them from overlapping unless they
/// coordinate through this.
enum AudioSessionOwner { none, audioCatalog, muhudVerse }

/// App-wide "now playing" coordinator so at most one audio source plays at
/// once. A bloc calls [claim] right before starting playback; whichever bloc
/// currently isn't the owner is expected to stop itself in response to the
/// [ValueListenable] notification.
@lazySingleton
class AudioSessionCoordinator {
  final ValueNotifier<AudioSessionOwner> owner = ValueNotifier(
    AudioSessionOwner.none,
  );

  // A plain setter would read as `coordinator.owner.value = X` anyway (the
  // ValueNotifier is public); this method exists only to give that action a
  // name at call sites (`claim`) instead of a bare assignment.
  // ignore: use_setters_to_change_properties
  void claim(AudioSessionOwner newOwner) => owner.value = newOwner;

  /// Clears ownership only if [currentOwner] is still the one holding it —
  /// avoids a stale stop-callback clobbering a newer claim made by the other
  /// source in between.
  void release(AudioSessionOwner currentOwner) {
    if (owner.value == currentOwner) owner.value = AudioSessionOwner.none;
  }
}
