import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Records a push notification failure that the app carries on from.
void reportPushError(Object error, StackTrace stack) {
  debugPrint('Push notification error: $error');
  unawaited(Sentry.captureException(error, stackTrace: stack));
  if (Firebase.apps.isNotEmpty) {
    unawaited(
      FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: 'push_notification',
      ),
    );
  }
}
