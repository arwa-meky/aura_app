import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit() : super(PermissionState()) {
    _checkInitialStatus();
  }

  Future<void> _checkInitialStatus() async {
    final locationStatus = await Permission.location.isGranted;
    final activityStatus = await Permission.activityRecognition.isGranted;
    final notificationStatus = await Permission.notification.isGranted;
    final bluetoothStatus = await Permission.bluetoothConnect.isGranted;
    final micStatus = await Permission.microphone.isGranted;

    emit(
      state.copyWith(
        isLocationGranted: locationStatus,
        isActivityGranted: activityStatus,
        isNotificationGranted: notificationStatus,
        isBluetoothGranted: bluetoothStatus,
        isMicGranted: micStatus,
      ),
    );
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    if (permission == Permission.location) {
      emit(state.copyWith(isLocationGranted: status.isGranted));
    } else if (permission == Permission.activityRecognition) {
      emit(state.copyWith(isActivityGranted: status.isGranted));
    } else if (permission == Permission.notification) {
      emit(state.copyWith(isNotificationGranted: status.isGranted));
    } else if (permission == Permission.bluetoothConnect ||
        permission == Permission.bluetooth) {
      emit(state.copyWith(isBluetoothGranted: status.isGranted));
    } else if (permission == Permission.microphone) {
      emit(state.copyWith(isMicGranted: status.isGranted));
    }
  }

  Future<void> requestAllPermissions() async {
    await [
      Permission.location,
      Permission.activityRecognition,
      Permission.notification,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.microphone,
    ].request();

    _checkInitialStatus();
  }
}
