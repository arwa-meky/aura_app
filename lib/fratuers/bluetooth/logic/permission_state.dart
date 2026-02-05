class PermissionState {
  final bool isLocationGranted;
  final bool isActivityGranted;
  final bool isNotificationGranted;
  final bool isBluetoothGranted;
  final bool isMicGranted;
  final bool isPhoneGranted;
  final bool isSmsGranted;

  PermissionState({
    this.isLocationGranted = false,
    this.isActivityGranted = false,
    this.isNotificationGranted = false,
    this.isBluetoothGranted = false,
    this.isMicGranted = false,
    this.isPhoneGranted = false,
    this.isSmsGranted = false,
  });

  bool get allGranted =>
      isLocationGranted &&
      isActivityGranted &&
      isNotificationGranted &&
      isBluetoothGranted &&
      isMicGranted &&
      isPhoneGranted &&
      isSmsGranted;

  PermissionState copyWith({
    bool? isLocationGranted,
    bool? isActivityGranted,
    bool? isNotificationGranted,
    bool? isBluetoothGranted,
    bool? isMicGranted,
    bool? isPhoneGranted,
    bool? isSmsGranted,
  }) {
    return PermissionState(
      isLocationGranted: isLocationGranted ?? this.isLocationGranted,
      isActivityGranted: isActivityGranted ?? this.isActivityGranted,
      isNotificationGranted:
          isNotificationGranted ?? this.isNotificationGranted,
      isBluetoothGranted: isBluetoothGranted ?? this.isBluetoothGranted,
      isMicGranted: isMicGranted ?? this.isMicGranted,
      isPhoneGranted: isPhoneGranted ?? this.isPhoneGranted,
      isSmsGranted: isSmsGranted ?? this.isSmsGranted,
    );
  }
}
