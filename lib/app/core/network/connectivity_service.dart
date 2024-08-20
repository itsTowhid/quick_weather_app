// import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  // final Connectivity _connectivity = Connectivity();

  Future<bool> isConnected() async {
    // var connectivityResult = await _connectivity.checkConnectivity();
    // return !connectivityResult.contains(ConnectivityResult.none);
    return true;
  }

  // Stream<List<ConnectivityResult>> get onConnectivityChanged =>
  //     _connectivity.onConnectivityChanged;
}
