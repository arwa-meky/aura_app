import 'dart:async';
import 'dart:math';
import 'package:aura_project/core/helpers/storage/hive_storage_service.dart';
import 'package:aura_project/fratuers/bluetooth/model/health_reading_model.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:aura_project/core/networking/socket_service.dart';
import 'package:aura_project/core/helpers/storage/local_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(AuraBackgroundHandler());
}

class AuraBackgroundHandler extends TaskHandler {
  Timer? _demoTimer;
  final Random _random = Random();
  int _lastStepsTotal = 0;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    try {
      print("🚀 Background Service: Starting...");
      await Hive.initFlutter();
      await Hive.openBox('profile_box');
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(HealthReadingModelAdapter());
      }

      await HiveStorageService.init();
      await LocalStorage.init();

      _safeInitSocket();

      bool isDemo = LocalStorage.getIsDemoMode();
      print("ℹ️ Is Demo Mode: $isDemo");

      if (isDemo) {
        _demoTimer?.cancel();
        _demoTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
          _generateAndSendFakeData();
        });
      }
    } catch (e) {
      print("❌ Background Service Start Error: $e");
    }
  }

  void _generateAndSendFakeData() {
    final fullResponse = HiveStorageService.getCachedProfile();
    final cachedData = fullResponse?['data'] as Map<dynamic, dynamic>?;

    double weight =
        double.tryParse(cachedData?['weight']?.toString() ?? "0") ?? 0.0;
    double height =
        double.tryParse(cachedData?['height']?.toString() ?? "0") ?? 0.0;
    int age = int.tryParse(cachedData?['age']?.toString() ?? "0") ?? 0;

    String genderStr =
        cachedData?['gender']?.toString().toLowerCase() ?? "male";
    int gender = (genderStr == "male") ? 0 : 1;

    final int hr = 72 + _random.nextInt(20);
    final int o2 = 96 + _random.nextInt(4);
    final int currentSteps = 2000 + _random.nextInt(50);

    final data = HealthReadingModel(
      userId: LocalStorage.getUserId ?? "demo_user",
      timestamp: DateTime.now().toIso8601String(),
      heartRate: hr,
      oxygen: o2,
      speed: _random.nextInt(5),
      steps: currentSteps,
      lat: 30.0,
      lon: 31.0,
      position: 0,
      sos: (_random.nextInt(100) > 98) ? 1 : 0,
      shake: (_random.nextInt(100) > 98) ? 1 : 0,
      battery: 85,
    );
    _lastStepsTotal = currentSteps;
    final uiMap = {
      "user_id": data.userId,
      "timestamp": data.timestamp,
      "data": {
        "heartRate": data.heartRate,
        "spO2": data.oxygen,
        "speed": data.speed,
        "steps": data.steps,
        "battery": data.battery,
        "gps": {"lat": data.lat, "lon": data.lon},
        "SOS": data.sos,
        "Shake": data.shake,
        "Sitting or Standing": data.position,
      },
    };

    final backendMap = data.toBackendJson(
      weight: weight,
      height: height,
      age: age,
      gender: gender,
      previousTotalSteps: _lastStepsTotal,
    );

    FlutterForegroundTask.sendDataToMain(uiMap);

    print("🔄 Processing health data to backend");
    SocketService.sendHealthData(data, backendMap);
  }

  void _safeInitSocket() {
    final String? token = LocalStorage.token;

    if (token != null &&
        (!SocketService.isConnected && !SocketService.initialized)) {
      SocketService.init(token);
    }
  }

  @override
  void onReceiveData(Object data) async {
    // print("📩 Background received signal: $data");

    // if (data == 'GET_CURRENT_DATA') {
    //   if (_lastGeneratedData != null) {
    //     FlutterForegroundTask.sendDataToMain(_lastGeneratedData!);
    //   }
    // }
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    _safeInitSocket();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isUserAction) async {
    print("🛑 Background Service Destroyed");
    _demoTimer?.cancel();
    SocketService.disconnect();
  }
}
