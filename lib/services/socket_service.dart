import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  Function get emit => this._socket.emit;
  Function get on => this._socket.on;
  IO.Socket get socket => this._socket;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    // Dart client
    this._socket = IO.io('http://192.168.0.15:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    // socket.onConnect((_) {
    //   print('connect');
    // });

    // IO.Socket socket = IO.io(
    //     'http://localhost:3000',
    //     OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
    //         //.disableAutoConnect() // disable auto-connection
    //         //.setExtraHeaders({'foo': 'bar'}) // optional
    //         .build());

    // socket.connect();

    // socket.onConnect((_) {
    //   print('connect');
    // });
    this._socket.on('connect', (_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    //socket.onDisconnect((_) => print('disconnect'));

    // socket.on('nuevo-mensaje', (payload) {
    //   print('nuevo-mesaje:');
    //   print('nombre:' + payload['nombre']);
    //   print('mensaje:' + payload['mensaje']);
    //   print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'no hay');
    // });
  }
}
