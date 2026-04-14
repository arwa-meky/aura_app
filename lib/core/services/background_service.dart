import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:aura_project/core/networking/socket_service.dart';
import 'package:aura_project/core/helpers/storage/local_storage.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(AuraBackgroundHandler());
}

class AuraBackgroundHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    final String? token = LocalStorage.token;
    if (token != null) {
      SocketService.init(token);
      print("🚀 Socket initialized in Background");
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    print("📡 Background Sync Done ");
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isUserAction) async {
    print("🛑 Service Stopped");
  }
}
