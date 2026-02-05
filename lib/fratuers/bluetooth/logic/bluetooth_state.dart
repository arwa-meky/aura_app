import 'package:aura_project/fratuers/bluetooth/model/health_reading_model.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothState {}

class BluetoothInitial extends BluetoothState {}

class BluetoothScanning extends BluetoothState {
  final List<ScanResult> results;
  BluetoothScanning(this.results);
}

class BluetoothConnecting extends BluetoothState {}

class BluetoothConnected extends BluetoothState {
  final String deviceName;
  BluetoothConnected(this.deviceName);
}

class BluetoothScanStopped extends BluetoothState {
  final List<ScanResult> results;
  BluetoothScanStopped(this.results);
}

class BluetoothDataReceived extends BluetoothState {
  final HealthReadingModel data;
  BluetoothDataReceived(this.data);
}

class BluetoothEmergencyState extends BluetoothState {
  final String message;
  BluetoothEmergencyState(this.message);
}

class BluetoothError extends BluetoothState {
  final String message;
  BluetoothError(this.message);
}

class BluetoothStreakUpdated extends BluetoothState {
  final int currentStreak;
  BluetoothStreakUpdated(this.currentStreak);
}

class BluetoothLocationUpdated extends BluetoothState {}
