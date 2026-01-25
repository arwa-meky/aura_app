class PermissionState {
  final bool isLocationGranted;
  final bool isActivityGranted;
  final bool isNotificationGranted;
  final bool isBluetoothGranted;
  final bool isMicGranted;

  PermissionState({
    this.isLocationGranted = false,
    this.isActivityGranted = false,
    this.isNotificationGranted = false,
    this.isBluetoothGranted = false,
    this.isMicGranted = false,
  });

  bool get allGranted =>
      isLocationGranted &&
      isActivityGranted &&
      isNotificationGranted &&
      isBluetoothGranted &&
      isMicGranted;

  PermissionState copyWith({
    bool? isLocationGranted,
    bool? isActivityGranted,
    bool? isNotificationGranted,
    bool? isBluetoothGranted,
    bool? isMicGranted,
  }) {
    return PermissionState(
      isLocationGranted: isLocationGranted ?? this.isLocationGranted,
      isActivityGranted: isActivityGranted ?? this.isActivityGranted,
      isNotificationGranted:
          isNotificationGranted ?? this.isNotificationGranted,
      isBluetoothGranted: isBluetoothGranted ?? this.isBluetoothGranted,
      isMicGranted: isMicGranted ?? this.isMicGranted,
    );
  }
}
