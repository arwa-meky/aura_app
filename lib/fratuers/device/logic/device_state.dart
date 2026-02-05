enum ConnectionStatus { connected, disconnected, connecting }

class DeviceState {
  final ConnectionStatus status;
  final int batteryLevel;
  final String lastSync;

  final bool isHeartRateEnabled;
  final bool isBloodOxygenEnabled;
  final bool isActivityEnabled;
  final bool isGpsEnabled;
  final bool isAutoSyncEnabled;

  final bool isSosEnabled;
  final bool isFallDetectionEnabled;

  DeviceState({
    this.status = ConnectionStatus.connected,
    this.batteryLevel = 72,
    this.lastSync = "3 min ago",
    this.isHeartRateEnabled = true,
    this.isBloodOxygenEnabled = true,
    this.isActivityEnabled = true,
    this.isGpsEnabled = true,
    this.isAutoSyncEnabled = true,
    this.isSosEnabled = true,
    this.isFallDetectionEnabled = false,
  });

  DeviceState copyWith({
    ConnectionStatus? status,
    int? batteryLevel,
    String? lastSync,
    bool? isHeartRateEnabled,
    bool? isBloodOxygenEnabled,
    bool? isActivityEnabled,
    bool? isGpsEnabled,
    bool? isAutoSyncEnabled,
    bool? isSosEnabled,
    bool? isFallDetectionEnabled,
  }) {
    return DeviceState(
      status: status ?? this.status,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      lastSync: lastSync ?? this.lastSync,
      isHeartRateEnabled: isHeartRateEnabled ?? this.isHeartRateEnabled,
      isBloodOxygenEnabled: isBloodOxygenEnabled ?? this.isBloodOxygenEnabled,
      isActivityEnabled: isActivityEnabled ?? this.isActivityEnabled,
      isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
      isAutoSyncEnabled: isAutoSyncEnabled ?? this.isAutoSyncEnabled,
      isSosEnabled: isSosEnabled ?? this.isSosEnabled,
      isFallDetectionEnabled:
          isFallDetectionEnabled ?? this.isFallDetectionEnabled,
    );
  }
}
