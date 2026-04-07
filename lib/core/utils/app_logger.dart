import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final AppLogger appLogger = AppLogger._();

class AppLogger {
  AppLogger._();

  final Logger _logger = Logger(
    level: kDebugMode ? Level.debug : Level.warning,
    printer: PrettyPrinter(
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    output: kDebugMode ? ConsoleOutput() : null,
  );

  void d(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.d(message, error: error, stackTrace: stackTrace);

  void i(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.i(message, error: error, stackTrace: stackTrace);

  void w(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.w(message, error: error, stackTrace: stackTrace);

  void e(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
