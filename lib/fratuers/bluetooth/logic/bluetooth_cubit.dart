import 'dart:async';
import 'dart:convert';
import 'package:aura_project/core/helpers/storage/hive_storage_service.dart';
import 'package:aura_project/core/helpers/storage/local_storage.dart';
import 'package:aura_project/core/networking/auth_api_service.dart';
import 'package:aura_project/core/networking/socket_service.dart';
import 'package:aura_project/fratuers/bluetooth/logic/bluetooth_state.dart';
import 'package:aura_project/fratuers/bluetooth/model/health_reading_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' hide BluetoothState;
import 'package:permission_handler/permission_handler.dart';
import 'package:aura_project/core/services/notification_service.dart';
import 'dart:math'; //for demo

class BluetoothCubit extends Cubit<BluetoothState> {
  BluetoothCubit() : super(BluetoothInitial());

  final AuthApiService _apiService = AuthApiService();

  StreamSubscription? _scanSubscription;
  StreamSubscription? _dataSubscription;
  BluetoothDevice? connectedDevice;
  List<ScanResult> _scanResults = [];

  Timer? _simulationTimer; //for demo

  void startSimulation() {
    //for demo
    emit(BluetoothConnecting());

    Future.delayed(const Duration(seconds: 2), () {
      emit(BluetoothConnected("Aura Demo Watch"));

      final String? token = LocalStorage.token;
      if (token != null) SocketService.init(token);

      _simulationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
        _generateFakeData();
      });
    });
  }

  void _generateFakeData() async {
    //for demo
    final random = Random();

    final int hr = 70 + random.nextInt(30);
    final int o2 = 95 + random.nextInt(5);
    final double temp = 36.5 + (random.nextInt(10) / 10);

    final bool isSOS = random.nextInt(100) > 98;

    final data = HealthReadingModel(
      userId: LocalStorage.getUserId ?? "demo_user",
      timestamp: DateTime.now().toIso8601String(),
      heartRate: hr,
      oxygen: o2,
      temperature: temp,
      steps: 1500 + random.nextInt(100),
      lat: 30.0,
      lon: 31.0,
      position: 0,
      sos: isSOS ? 1 : 0,
      shake: 0,
    );

    await HiveStorageService.saveReading(data);

    SocketService.sendHealthData(data.toBackendJson());

    if (data.isSOSActive) {
      emit(BluetoothEmergencyState("🚨 SOS Simulated Alert!"));
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
      await device.connect(autoConnect: true);
      connectedDevice = device;

      final String deviceId = device.remoteId.toString();
      final String deviceName = device.platformName;

      try {
        await _apiService.linkDevice(
          deviceId: deviceId,
          deviceName: deviceName,
        );
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
    } catch (e) {
      device.disconnect();
      emit(BluetoothError("Connection failed: $e"));
    }
  }

  void _discoverAndSubscribe(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();

      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.notify) {
            await characteristic.setNotifyValue(true);

            _dataSubscription = characteristic.onValueReceived.listen((value) {
              _processData(value);
            });
          }
        }
      }
    } catch (e) {
      print("Service Discovery Error: $e");
    }
  }

  void _processData(List<int> bytes) async {
    try {
      String jsonString = utf8.decode(bytes).trim();
      if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
        jsonString = jsonString.substring(1, jsonString.length - 1);
      }
      jsonString = jsonString.replaceAll(r'\"', '"');

      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      String currentUserId = LocalStorage.getUserId ?? "unknown";

      final HealthReadingModel data = HealthReadingModel.fromWatchJson(
        jsonData,
        currentUserId,
      );

      await HiveStorageService.saveReading(data);

      SocketService.sendHealthData(data.toBackendJson());

      if (data.isSOSActive) {
        NotificationService().showEmergencyNotification(
          title: "🚨 SOS ALERT!",
          body: "Patient pushed the SOS button. Please check immediately!",
        );

        emit(BluetoothEmergencyState("🚨 SOS Alert! Patient needs help!"));
      } else if (data.isFallDetected) {
        NotificationService().showEmergencyNotification(
          title: "⚠️ FALL DETECTED!",
          body: "A fall has been detected. Please check the patient!",
        );

        emit(BluetoothEmergencyState("⚠️ Fall Detected! Check the patient!"));
      } else {
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

  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
    return statuses.values.every((status) => status.isGranted);
  }

  @override
  Future<void> close() {
    FlutterBluePlus.stopScan();
    _scanSubscription?.cancel();
    _dataSubscription?.cancel();
    connectedDevice?.disconnect();
    SocketService.disconnect();
    _simulationTimer?.cancel();
    return super.close();
  }
}
