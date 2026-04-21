import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aura_project/core/constants.dart';
import 'package:aura_project/core/helpers/storage/hive_storage_service.dart';
import 'package:aura_project/core/helpers/storage/local_storage.dart';
import 'package:aura_project/core/networking/api_constants.dart';
import 'package:aura_project/core/networking/auth_api_service.dart';
import 'package:aura_project/core/networking/dio_factory.dart';
import 'package:aura_project/core/networking/socket_service.dart';
import 'package:aura_project/core/services/background_service.dart';
import 'package:aura_project/fratuers/bluetooth/logic/bluetooth_state.dart';
import 'package:aura_project/fratuers/bluetooth/model/health_reading_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' hide BluetoothState;
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:aura_project/core/services/notification_service.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart'; //for demo

class BluetoothCubit extends Cubit<BluetoothState> {
  BluetoothCubit() : super(BluetoothInitial());

  final AuthApiService _apiService = AuthApiService();
  int currentStreak = 0;
  String currentAddress = "Finding location...";
  HealthReadingModel? lastReadings;
  bool isDeviceConnected = false;
  StreamSubscription? _connectionSubscription;

  StreamSubscription? _scanSubscription;
  StreamSubscription? _dataSubscription;
  BluetoothDevice? connectedDevice;
  List<ScanResult> _scanResults = [];
  Timer? _simulationTimer; //for demo
  int cachedSteps = 0;

  Future<void> _initForegroundTask() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'aura_monitoring',
        channelName: 'AURA Monitoring',
        channelImportance: NotificationChannelImportance.MAX,
        priority: NotificationPriority.MAX,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        showBadge: false,
        visibility: NotificationVisibility.VISIBILITY_PUBLIC,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: true,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  void startSimulation() async {
    emit(BluetoothConnecting());

    await Future.delayed(const Duration(seconds: 2));
    //for demo
    isDeviceConnected = true;
    const String demoDeviceId = "6789abcdef0123456789zxcv";

    emit(BluetoothConnected("Aura Demo Watch"));

    await getDeviceStreak(demoDeviceId);

    final String? token = LocalStorage.token;
    if (token != null) SocketService.init(token);
    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _generateFakeData();
    });
    await _initForegroundTask();
    await FlutterForegroundTask.startService(
      notificationTitle: 'AURA: وضع المحاكاة نشط',
      notificationText: 'جاري محاولة محاكاة البيانات والـ Streak...',
      callback: startCallback,
    );
  }

  void _generateFakeData() async {
    //for demo
    final random = Random();

    final int hr = 70 + random.nextInt(30);
    final int o2 = 95 + random.nextInt(5);
    final int speed = random.nextInt(10) * 10;

    final bool isSOS = random.nextInt(100) > 98;
    final bool isFallDetected = random.nextInt(100) > 98;

    final data = HealthReadingModel(
      userId: LocalStorage.getUserId ?? "demo_user",
      timestamp: DateTime.now().toIso8601String(),
      heartRate: hr,
      oxygen: o2,
      speed: speed,
      steps: 1500 + random.nextInt(100),
      lat: 30.0,
      lon: 31.0,
      position: 0,
      sos: isSOS ? 1 : 0,
      shake: isFallDetected ? 1 : 0,
      battery: 60,
    );
    lastReadings = data;
    emit(BluetoothDataReceived(data));

    // 2. الاختبار الحقيقي للـ Background Service:
    // نبعت البيانات للـ Task Isolate
    FlutterForegroundTask.sendDataToTask(data.toBackendJson());
    await HiveStorageService.saveReading(data);

    // SocketService.sendHealthData(data.toBackendJson());
    if (data.lat != 0) updateLocationAddress(data.lat, data.lon);

    if (isSOS) {
      NotificationService().startEmergencyCountdown(
        title: "SOS Alert",
        lat: data.lat.toString(),
        lon: data.lon.toString(),
      );

      emit(BluetoothEmergencyState("🚨 SOS Simulated Alert!"));
    } else if (isFallDetected) {
      NotificationService().startEmergencyCountdown(
        title: "Shake Alert!",
        lat: data.lat.toString(),
        lon: data.lon.toString(),
      );
      emit(BluetoothEmergencyState("🚨 Shake Simulated Alert!"));
    } else {
      emit(BluetoothDataReceived(data));
    }
  }

  void startScan() async {
    bool permGranted = await _requestPermissions();
    if (!permGranted) {
      emit(
        BluetoothError(
          "Please enable Bluetooth & Location permissions from settings.",
        ),
      );
      return;
    }

    if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.on) {
      try {
        await FlutterBluePlus.adapterState
            .firstWhere((s) => s == BluetoothAdapterState.on)
            .timeout(const Duration(seconds: 3));
      } catch (e) {
        emit(BluetoothError("Please turn on Bluetooth & Location."));
        return;
      }
    }

    try {
      _scanResults.clear();
      emit(BluetoothScanning([]));

      FlutterBluePlus.isScanning.listen((isScanning) {
        if (!isScanning && _scanResults.isNotEmpty) {
          emit(BluetoothScanStopped(_scanResults));
        } else if (!isScanning && _scanResults.isEmpty) {
          emit(BluetoothScanStopped([]));
        }
      });

      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        _scanResults = results;
        if (FlutterBluePlus.isScanningNow) {
          emit(BluetoothScanning(_scanResults));
        }
      });
    } catch (e) {
      emit(BluetoothError("Scan failed: $e"));
    }
  }

  void connectToDevice(BluetoothDevice device) async {
    await FlutterBluePlus.stopScan();
    emit(BluetoothConnecting());

    try {
      await device.connect(autoConnect: false);
      if (Platform.isAndroid) {
        try {
          await device.requestMtu(512);
          print("✅ MTU Requested: 512");
        } catch (e) {
          print("⚠️ MTU Request Failed: $e");
        }
      }

      connectedDevice = device;
      isDeviceConnected = true;
      await _initForegroundTask();
      await FlutterForegroundTask.startService(
        notificationTitle: 'AURA: المراقبة نشطة',
        notificationText: 'جاري استلام البيانات وإرسالها للسيرفر...',
        callback: startCallback,
      );

      _connectionSubscription?.cancel();

      _connectionSubscription = device.connectionState.listen((
        BluetoothConnectionState state,
      ) async {
        if (state == BluetoothConnectionState.disconnected) {
          isDeviceConnected = false;
          emit(
            BluetoothError(
              "⚠️ Device disconnected! Attempting auto-reconnect...",
            ),
          );
          NotificationService().showInstantNotification(
            title: "Device disconnected",
            body: "Device disconnected! Attempting auto-reconnect...",
          );

          print(
            "Device disconnected! Attempting auto-reconnect in 5 seconds...",
          );

          await Future.delayed(const Duration(seconds: 5));
          try {
            await device.connect(autoConnect: true);
          } catch (e) {
            print("Auto-reconnect failed: $e");
          }
        } else if (state == BluetoothConnectionState.connected) {
          isDeviceConnected = true;
          NotificationService().showInstantNotification(
            title: "connection done",
            body: "your watch is connecting again",
          );
          emit(BluetoothConnected(device.platformName));
        }
      });

      final String deviceId = device.remoteId.toString();
      final String deviceName = device.platformName;

      try {
        await _apiService.linkDevice(
          deviceId: deviceId,
          deviceName: deviceName,
        );
        print("Device linked to backend successfully");
      } catch (e) {
        print("Link Warning: $e");
      }
      await LocalStorage.saveDeviceId(deviceId);

      final String? token = LocalStorage.token;
      if (token != null) {
        SocketService.init(token);
      }

      emit(BluetoothConnected(deviceName));

      _discoverAndSubscribe(device);
      getDeviceStreak(deviceId);
    } catch (e) {
      isDeviceConnected = false;
      device.disconnect();
      emit(BluetoothError("Connection failed: $e"));
    }
  }

  void _discoverAndSubscribe(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();

      BluetoothCharacteristic? txChar;
      BluetoothCharacteristic? rxChar;

      for (var service in services) {
        if (service.uuid.toString().toLowerCase() == UART_SERVICE_UUID) {
          for (var c in service.characteristics) {
            if (c.uuid.toString().toLowerCase() == UART_TX_UUID) {
              txChar = c;
            }
            if (c.uuid.toString().toLowerCase() == UART_RX_UUID) {
              rxChar = c;
            }
          }
        }
      }

      if (txChar == null || rxChar == null) {
        print("❌ UART characteristics not found");
        return;
      }

      await txChar.setNotifyValue(true);

      _dataSubscription?.cancel();
      _dataSubscription = txChar.onValueReceived.listen((value) {
        print("📩 RAW DATA: $value");
        _processData(value);
      });
      await rxChar.write(utf8.encode("START"), withoutResponse: true);

      print("✅ UART Connected & Streaming Started");
    } catch (e) {
      print("❌ BLE Error: $e");
    }
  }

  // void _discoverAndSubscribe(BluetoothDevice device) async {
  //   try {
  //     List<BluetoothService> services = await device.discoverServices();

  //     for (var service in services) {
  //       print("🟦 SERVICE UUID: ${service.uuid}");

  //       for (var c in service.characteristics) {
  //         print(
  //           "   🔹 CHAR UUID: ${c.uuid} | "
  //           "notify=${c.properties.notify} | "
  //           "read=${c.properties.read} | "
  //           "write=${c.properties.write}",
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     print("Service Discovery Error: $e");
  //   }
  // }

  // void _discoverAndSubscribe(BluetoothDevice device) async {
  //   try {
  //     List<BluetoothService> services = await device.discoverServices();

  //     for (var service in services) {
  //       print("🟦 SERVICE UUID: ${service.uuid}");

  //       for (var characteristic in service.characteristics) {
  //         if (characteristic.properties.notify) {
  //           await characteristic.setNotifyValue(true);

  //           _dataSubscription = characteristic.onValueReceived.listen((value) {
  //             _processData(value);
  //           });
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print("Service Discovery Error: $e");
  //   }
  // }

  void _processData(List<int> bytes) async {
    try {
      String jsonString = utf8.decode(bytes).trim();
      if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
        jsonString = jsonString.substring(1, jsonString.length - 1);
      }
      jsonString = jsonString.replaceAll(r'\"', '"');
      print("clanedJson:$jsonString");

      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      String? currentUserId = LocalStorage.getUserId;
      if (currentUserId == null) {
        return;
      }
      final HealthReadingModel data = HealthReadingModel.fromWatchJson(
        jsonData,
        currentUserId,
      );
      lastReadings = data;
      emit(BluetoothDataReceived(data));

      FlutterForegroundTask.sendDataToTask(data.toBackendJson());
      await HiveStorageService.saveReading(data);

      // SocketService.sendHealthData(data.toBackendJson());

      if (data.lat != 0 && data.lon != 0) {
        _updateAddressBackground(data.lat, data.lon);
      }

      if (data.isSOSActive) {
        NotificationService().startEmergencyCountdown(
          title: "🚨 SOS ALERT!",
          lat: data.lat.toString(),
          lon: data.lon.toString(),
        );

        emit(BluetoothEmergencyState("🚨 SOS Alert! Patient needs help!"));
      } else if (data.isFallDetected) {
        NotificationService().startEmergencyCountdown(
          title: "⚠️ FALL DETECTED!",
          lat: data.lat.toString(),
          lon: data.lon.toString(),
        );

        emit(BluetoothEmergencyState("⚠️ Fall Detected! Check the patient!"));
      } else {
        LocalStorage.saveLastSyncTime();

        emit(BluetoothDataReceived(data));
      }
    } catch (e) {
      print("Parsing Error: $e");
    }
  }

  void saveDeviceNickname(String deviceId, String newName) async {
    await LocalStorage.saveCustomDeviceName(deviceId, newName);
    if (FlutterBluePlus.isScanningNow) {
      emit(BluetoothScanning(_scanResults));
    } else {
      emit(BluetoothScanStopped(_scanResults));
    }
  }

  List<dynamic> myPairedDevices = [];

  Future<void> fetchMyDevices() async {
    try {
      await _apiService.getPairedDevices();
      if (state is BluetoothConnected) {
        emit(BluetoothConnected((state as BluetoothConnected).deviceName));
      } else {
        emit(BluetoothInitial());
      }
      print("📱 Devices fetched: ${myPairedDevices.length}");
    } catch (e) {
      print("❌ Error fetching devices: $e");
    }
  }

  Future<void> removeDevice(String deviceId) async {
    try {
      await _apiService.unlinkDevice(deviceId: deviceId);

      if (connectedDevice?.remoteId.toString() == deviceId) {
        close();
      }

      await fetchMyDevices();

      print("🗑️ Device deleted successfully");
    } catch (e) {
      print("❌ Error deleting device: $e");
    }
  }

  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
      Permission.notification,
    ].request();
    return statuses.values.every((status) => status.isGranted);
  }

  Future<void> getDeviceStreak(String deviceId) async {
    try {
      final response = await DioFactory.postData(
        path: ApiConstants.streak,
        data: deviceId,
      );

      if (response.statusCode == 200) {
        currentStreak = response.data['streak'] ?? 0;

        if (lastReadings != null) {
          emit(BluetoothDataReceived(lastReadings!));
        } else {
          emit(BluetoothStreakUpdated(currentStreak));
        }
      }
    } catch (e) {
      print("❌ Failed to get streak: $e");
    }
  }

  Future<void> _updateAddressBackground(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        currentAddress =
            "${place.locality}, ${place.subAdministrativeArea}, ${place.country}";
      }
    } catch (e) {
      print("Address Error: $e");
    }
  }

  Future<void> updateLocationAddress(double lat, double long) async {
    await _updateAddressBackground(lat, long);
    emit(BluetoothLocationUpdated());
  }

  Future<void> saveLastSteps(int steps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_steps', steps);
  }

  Future<int> getLastSteps() async {
    final prefs = await SharedPreferences.getInstance();
    int steps = prefs.getInt('last_steps') ?? 0;
    cachedSteps = steps;
    return steps;
  }

  void stopEverything() {
    FlutterBluePlus.stopScan();
    _scanSubscription?.cancel();
    _dataSubscription?.cancel();
    connectedDevice = null;
    connectedDevice?.disconnect();
    SocketService.disconnect();
    _simulationTimer?.cancel();
    NotificationService().stopEmergencySequence();
    emit(BluetoothInitial());
  }
}
