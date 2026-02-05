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
    final phoneStatus = await Permission.phone.isGranted;
    final smsStatus = await Permission.sms.isGranted;

    emit(
      state.copyWith(
        isLocationGranted: locationStatus,
        isActivityGranted: activityStatus,
        isNotificationGranted: notificationStatus,
        isBluetoothGranted: bluetoothStatus,
        isMicGranted: micStatus,
        isPhoneGranted: phoneStatus,
        isSmsGranted: smsStatus,
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
    } else if (permission == Permission.phone) {
      emit(state.copyWith(isPhoneGranted: status.isGranted));
    } else if (permission == Permission.sms) {
      emit(state.copyWith(isSmsGranted: status.isGranted));
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
      Permission.phone,
      Permission.sms,
    ].request();

    _checkInitialStatus();
  }
}
