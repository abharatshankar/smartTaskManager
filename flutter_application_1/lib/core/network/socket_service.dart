import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../constants/api_constants.dart';

class SocketService {
  IO.Socket? _socket;

  void connect({required void Function(String message) onTaskUpdate}) {
    _socket ??= IO.io(
      ApiConstants.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .enableAutoConnect()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1500)
          .build(),
    );

    _socket?.on('task_update', (data) {
      if (data is Map && data['message'] is String) {
        onTaskUpdate(data['message'] as String);
      }
    });

    _socket?.connect();
  }

  void dispose() {
    _socket?.dispose();
    _socket = null;
  }
}
