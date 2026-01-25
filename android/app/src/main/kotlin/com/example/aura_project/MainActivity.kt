package com.example.aura_project


import android.content.Intent
import android.net.Uri
import android.telephony.SmsManager
import android.util.Log // استيراد الـ Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.aura.project/sms"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendDirectSMS") {
                val phone = call.argument<String>("phone")
                val msg = call.argument<String>("msg")
                Log.d("AuraNative", "Trying to send SMS to $phone") // Log 1

                if (phone != null && msg != null) {
                    sendSMS(phone, msg)
                    result.success("Sent")
                } else {
                    Log.e("AuraNative", "Phone or Msg is null") // Log 2
                    result.error("INVALID", "Args Error", null)
                }
            } 
            else if (call.method == "makeDirectCall") {
                val phone = call.argument<String>("phone")
                if (phone != null) {
                    makeCall(phone)
                    result.success("Calling")
                } else {
                    result.error("INVALID", "Phone Error", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun sendSMS(phone: String, message: String) {
        try {
            val smsManager = SmsManager.getDefault()
            val parts = smsManager.divideMessage(message)
            smsManager.sendMultipartTextMessage(phone, null, parts, null, null)
            Log.d("AuraNative", "✅ SMS Sent Successfully via Native") // Log 3
        } catch (e: Exception) {
            Log.e("AuraNative", "❌ SMS Failed: ${e.message}") // Log 4 (ده المهم)
            e.printStackTrace()
        }
    }

    private fun makeCall(phone: String) {
        try {
            val intent = Intent(Intent.ACTION_CALL)
            intent.data = Uri.parse("tel:$phone")
            startActivity(intent)
        } catch (e: Exception) {
            Log.e("AuraNative", "❌ Call Failed: ${e.message}")
            e.printStackTrace()
        }
    }
}