import 'package:connectivity/connectivity.dart';

abstract class NetworkInfo{
  Future<bool> get isConnected;
}

