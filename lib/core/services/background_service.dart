import 'dart:async';
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
  void _safeInitSocket() {
    if (!SocketService.isConnected) {
      final String? token = LocalStorage.token;
      if (token != null) {
        print("🌐 Background Service: Initializing Socket...");
        SocketService.init(token);
      }
    }
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(HealthReadingModelAdapter().typeId)) {
      Hive.registerAdapter(HealthReadingModelAdapter());
    }
    await Hive.openBox<HealthReadingModel>('health_readings');

    await LocalStorage.init();
    _safeInitSocket();
  }

  @override
  void onReceiveData(Object data) async {
    if (data is Map<String, dynamic>) {
      if (SocketService.isConnected) {
        SocketService.sendHealthData(data);
      } else {
        _safeInitSocket();
      }
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    _safeInitSocket();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isUserAction) async {
    print("🛑 Background Service Destroyed");
    SocketService.disconnect();
  }
}
