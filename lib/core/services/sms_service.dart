import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsService {
  static const platform = MethodChannel('com.aura.project/sms');

  static Future<void> sendEmergencySMS({
    required String phoneNumber,
    required String message,
  }) async {
    try {
      if (await Permission.sms.status.isDenied) await Permission.sms.request();
      if (await Permission.sms.status.isGranted) {
        await platform.invokeMethod('sendDirectSMS', {
          'phone': phoneNumber,
          'msg': message,
        });
        print("✅ Native SMS Sent");
      }
    } catch (e) {
      print("❌ SMS Error: $e");
    }
  }

  static Future<void> makeDirectCall(String phoneNumber) async {
    try {
      if (await Permission.phone.status.isDenied) {
        await Permission.phone.request();
      }

      if (await Permission.phone.status.isGranted) {
        await platform.invokeMethod('makeDirectCall', {'phone': phoneNumber});
        print("✅ Native Direct Call Started");
      } else {
        print("⚠️ Phone Permission Denied");
      }
    } catch (e) {
      print("❌ Call Error: $e");
    }
  }
}
