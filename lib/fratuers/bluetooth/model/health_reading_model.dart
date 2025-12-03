import 'package:hive/hive.dart';

part 'health_reading_model.g.dart';

@HiveType(typeId: 0)
class HealthReadingModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String timestamp;

  @HiveField(2)
  final int heartRate;

  @HiveField(3)
  final int oxygen;

  @HiveField(4)
  final double temperature;

  @HiveField(5)
  final int steps;

  @HiveField(6)
  final double lat;

  @HiveField(7)
  final double lon;

  @HiveField(8)
  final int position;

  @HiveField(9)
  final int sos;

  @HiveField(10)
  final int shake;

  @HiveField(11)
  final bool isSynced;

  bool get isSOSActive => sos == 1;
  bool get isFallDetected => shake == 1;

  HealthReadingModel({
    required this.userId,
    required this.timestamp,
    required this.heartRate,
    required this.oxygen,
    required this.temperature,
    required this.steps,
    required this.lat,
    required this.lon,
    required this.position,
    required this.sos,
    required this.shake,
    this.isSynced = false,
  });

  factory HealthReadingModel.fromWatchJson(
    Map<String, dynamic> json,
    String userId,
  ) {
    return HealthReadingModel(
      userId: userId,
      timestamp: DateTime.now().toIso8601String(),
      heartRate: json['HR'] ?? 0,
      oxygen: json['O2'] ?? 0,
      temperature: (json['T'] ?? 0).toDouble(),
      steps: json['ST'] ?? 0,
      lat: (json['GPS'] != null ? json['GPS']['lat'] : 0.0).toDouble(),
      lon: (json['GPS'] != null ? json['GPS']['lon'] : 0.0).toDouble(),
      position: json['POS'] ?? 0,
      sos: json['SOS'] ?? 0,
      shake: json['SHK'] ?? 0,
      isSynced: false,
    );
  }

  Map<String, dynamic> toBackendJson() {
    return {
      "user_id": userId,
      "timestamp": timestamp,
      "data": {
        "heartRate": heartRate,
        "spO2": oxygen,
        "temp": temperature,
        "steps": steps,
        "gps": {"lat": lat, "lon": lon},
        "Sitting or Standing": position,
        "Walking or Running": 0,
        "SOS": sos,
        "Shake": shake,
      },
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': key,
      'userId': userId,
      'timestamp': timestamp,
      'heartRate': heartRate,
      'oxygen': oxygen,
      'temperature': temperature,
      'steps': steps,
      'lat': lat,
      'lon': lon,
      'position': position,
      'sos': sos,
      'shake': shake,
      'isSynced': isSynced ? 1 : 0,
    };
  }
}
