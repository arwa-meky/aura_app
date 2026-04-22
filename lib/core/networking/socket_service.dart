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
    List<HealthReadingModel> offlineData =
        await HiveStorageService.getAllUnsyncedReadings();
    if (offlineData.isEmpty) return;

    // 1. جلب بيانات البروفايل من الـ Hive قبل البدء
    final cachedData =
        HiveStorageService.getCachedProfile(); // تأكدي من عمل import للـ LocalStorage

    // 2. استخراج القيم أو وضع قيم افتراضية
    double weight =
        double.tryParse(cachedData?['weight']?.toString() ?? "0") ?? 0.0;
    double height =
        double.tryParse(cachedData?['height']?.toString() ?? "0") ?? 0.0;
    int age = int.tryParse(cachedData?['age']?.toString() ?? "0") ?? 0;
    int gender = (cachedData?['gender']?.toString().toLowerCase() == "male")
        ? 0
        : 1;

    print("🔄 Syncing ${offlineData.length} offline readings...");

    // 3. تمرير المتغيرات لدالة toBackendJson أثناء الـ Mapping
    List<Map<String, dynamic>> batchData = offlineData
        .map(
          (e) => e.toBackendJson(
            weight: weight,
            height: height,
            age: age,
            gender: gender,
          ),
        )
        .toList();

    // 4. الإرسال (زي ما هو في كودك)
    socket.emitWithAck(
      'chat message',
      batchData,
      ack: (data) async {
        print("✅ Server acknowledged sync: $data");
        await HiveStorageService.clearAllReadings();
        print("🧹 Local storage cleared after successful sync");
      },
    );
  }

  static void disconnect() {
    if (isConnected) {
      socket.disconnect();
    }
  }
}
