import 'package:aura_project/core/helpers/storage/hive_storage_service.dart';
import 'package:aura_project/core/networking/api_constants.dart';
import 'package:aura_project/fratuers/bluetooth/model/health_reading_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? socket;
  static bool isConnected = false;
  static bool initialized = false;

  static void init(String token) {
    if (socket != null) {
      socket!.dispose();
    }

    isConnected = false;
    initialized = true;
    if (isConnected) {
      print('⚠️ Already connected');
      return;
    }

    socket = IO.io(
      ApiConstants.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    socket?.off('chat message');
    socket?.off('alert response');

    socket?.onConnect((_) {
      print('✅ Socket Connected!');

      isConnected = true;

      for (var item in _pendingQueue) {
        socket?.emit('chat message', item);
      }
      _pendingQueue.clear();

      Future.delayed(const Duration(seconds: 2), () => _syncOfflineData());
    });

    socket?.onDisconnect((_) {
      print('❌ Socket Disconnected');
      isConnected = false;
      initialized = false;
    });

    socket?.onConnectError((data) => print("Socket Error: $data"));
    // - This is the alert sent from the backend server which already comes from the
    // - ds server
    // - DS server => backend server => mobile
    socket?.on('alert response', (data) {
      print(data);

      // TODO:
      // - Convert to AlertModel
      // - Show notification
    });
    socket?.connect();
  }

  static final List<Map<String, dynamic>> _pendingQueue = [];

  static Future<void> sendHealthData(
    HealthReadingModel reading,
    Map<String, dynamic> backendMap,
  ) async {
    if (socket?.connected == true) {
      socket!.emit('chat message', backendMap);
      print("📡 Sent to server");
    } else {
      print("📦 Saved offline (no connection)");

      await HiveStorageService.saveReading(reading);
    }
  }

  static void _syncOfflineData() async {
    List<HealthReadingModel> offlineData =
        await HiveStorageService.getAllUnsyncedReadings();
    if (offlineData.isEmpty) return;

    final fullResponse = HiveStorageService.getCachedProfile();
    final cachedData = fullResponse?['data'] as Map<dynamic, dynamic>?;

    if (cachedData == null) {
      print("⚠️ Sync Cancelled: Profile data not found in Hive.");
      return;
    }

    double weight =
        double.tryParse(cachedData['weight']?.toString() ?? "0") ?? 0.0;
    double height =
        double.tryParse(cachedData['height']?.toString() ?? "0") ?? 0.0;
    int age = int.tryParse(cachedData['age']?.toString() ?? "0") ?? 0;
    int gender = (cachedData['gender']?.toString().toLowerCase() == "male")
        ? 0
        : 1;

    print("🔄 Syncing ${offlineData.length} readings to backend...");

    for (var reading in offlineData) {
      final backendMap = reading.toBackendJson(
        weight: weight,
        height: height,
        age: age,
        gender: gender,
        previousTotalSteps: 0,
      );

      socket?.emit('chat message', backendMap);
    }

    await HiveStorageService.clearAllReadings();
    print("🧹 Sync completed and Hive cleared.");
  }

  static void disconnect() {
    if (isConnected) {
      socket?.disconnect();
    }
  }
}
