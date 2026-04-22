import 'package:aura_project/core/helpers/storage/hive_storage_service.dart';
import 'package:aura_project/core/networking/api_constants.dart';
import 'package:aura_project/fratuers/bluetooth/model/health_reading_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static late IO.Socket socket;
  static bool isConnected = false;
  static bool _initialized = false;

  static void init(String token) {
    if (_initialized) {
      print('⚠️ Socket already initialized');
      return;
    }
    _initialized = true;

    socket = IO.io(
      ApiConstants.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('✅ Socket Connected!');
      isConnected = true;

      Future.delayed(Duration(seconds: 3), () => _syncOfflineData());
    });

    socket.onDisconnect((_) {
      print('❌ Socket Disconnected');
      isConnected = false;
    });

    socket.onConnectError((data) => print("Socket Error: $data"));
    // - This is the alert sent from the backend server which already comes from the
    // - ds server
    // - DS server => backend server => mobile
    socket.on('alert response', (data) {
      print(data);

      // TODO:
      // - Convert to AlertModel
      // - Show notification
    });
  }

  static void sendHealthData(Map<String, dynamic> data) {
    if (_initialized && isConnected) {
      // - Emit the data read from the smartwatch to the backend server
      socket.emit('chat message', data);
      print("📡 Data emitted via Socket");
    } else {
      print("⚠️ Socket not connected, data saved locally only.");
    }
  }

  static void _syncOfflineData() async {
  List<HealthReadingModel> offlineData = await HiveStorageService.getAllUnsyncedReadings();

  if (offlineData.isEmpty) return;

  print("🔄 Syncing ${offlineData.length} offline readings...");

  List<Map<String, dynamic>> batchData = offlineData.map((e) => e.toBackendJson()).toList();

  socket.emitWithAck('chat message', batchData, ack: (data) async {
    print("✅ Server acknowledged sync: $data");
    
    await HiveStorageService.clearAllReadings();
    print("🧹 Local storage cleared after successful sync");
  });

  print("📡 Sync process initiated...");
}

  static void disconnect() {
    if (isConnected) {
      socket.disconnect();
    }
  }
}
