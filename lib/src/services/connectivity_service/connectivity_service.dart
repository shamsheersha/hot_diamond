import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';



class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final InternetConnectionChecker _internetChecker = InternetConnectionChecker.createInstance();

  Future<bool> checkConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return await _internetChecker.hasConnection;
  }

  Stream<List<ConnectivityResult>> get connectivityStream => _connectivity.onConnectivityChanged;
  Stream<InternetConnectionStatus> get internetStream => _internetChecker.onStatusChange;
}