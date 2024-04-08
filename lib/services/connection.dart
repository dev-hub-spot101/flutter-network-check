import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nointernet/services/navigation_service.dart';
import 'package:nointernet/widgets/no_internet.dart';

class ConnectionStatusListener {
  static final _singleton = ConnectionStatusListener._internal();
  ConnectionStatusListener._internal();

  bool hasShownNoIntenet = false;

  final Connectivity _connectivity = Connectivity();

  static ConnectionStatusListener getInstance() => _singleton;

  bool hasConnection = false;

  StreamController connectionChangeController = StreamController.broadcast();

  Stream get connectionChange => connectionChangeController.stream;

  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }

  Future<void> initialize() async {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    await checkConnection();
  }

  void dispose() {
    connectionChangeController.close();
  }
}

updateConnectivity(
    dynamic hasConnection, ConnectionStatusListener connectionStatus) {
  print("hasConnection" + hasConnection.toString());

  if (!hasConnection) {
    connectionStatus.hasShownNoIntenet = true;
    NavigationService().navigateToScreen(NoInternetScreen());
  } else {
    if (connectionStatus.hasShownNoIntenet) {
      connectionStatus.hasShownNoIntenet = false;
      NavigationService().goBack();
    }
  }
}

initNoInternetListener() async {
  var connectionStatus = ConnectionStatusListener.getInstance();
  await connectionStatus.initialize();
  if (!connectionStatus.hasConnection) {
    updateConnectivity(false, connectionStatus);
  } else {
    connectionStatus.connectionChange.listen((event) {
      print("initNoInternetListener $event");
      updateConnectivity(event, connectionStatus);
    });
  }
}
