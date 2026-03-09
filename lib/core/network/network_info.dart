import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Contract for checking internet connectivity.
abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}

/// [InternetConnection]-backed implementation, registered as lazy singleton.
@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl(this._internetConnection);

  final InternetConnection _internetConnection;

  @override
  Future<bool> get isConnected => _internetConnection.hasInternetAccess;
}
