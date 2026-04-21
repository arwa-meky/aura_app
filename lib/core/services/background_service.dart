import 'dart:async';
import 'dart:math';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:aura_project/core/networking/socket_service.dart';
import 'package:aura_project/core/helpers/storage/local_storage.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(AuraBackgroundHandler());
}

class AuraBackgroundHandler extends TaskHandler {
  Timer? _bgTimer;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print("Background Service is alive even after App Kill!");

    final String? token = LocalStorage.token;
    if (token != null) {
      SocketService.init(token);
    }

    _bgTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _sendMockDataFromBackground();
    });
  }

  void _sendMockDataFromBackground() {
    final data = {
      "userId": LocalStorage.getUserId ?? "demo_user",
      "heartRate": 75 + Random().nextInt(10),
      "oxygen": 98,
      "timestamp": DateTime.now().toIso8601String(),
    };

    if (SocketService.isConnected) {
      SocketService.sendHealthData(data);
      print("Data sent from Background Isolate after App Kill ✅");
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    if (!SocketService.isConnected && LocalStorage.token != null) {
      SocketService.init(LocalStorage.token!);
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isUserAction) async {
    _bgTimer?.cancel();
    SocketService.disconnect();
  }
}
