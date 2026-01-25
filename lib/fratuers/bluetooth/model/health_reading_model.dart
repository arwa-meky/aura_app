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
  final int speed;

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
    required this.speed,
    required this.steps,
    required this.lat,
    required this.lon,
    required this.position,
    required this.sos,
    required this.shake,
    this.isSynced = false,
  });

  // factory HealthReadingModel.fromWatchJson(
  //   Map<String, dynamic> json,
  //   String userId,
  // ) {
  //   return HealthReadingModel(
  //     userId: userId,
  //     timestamp: DateTime.now().toIso8601String(),
  //     heartRate: json['HR'] ?? 0,
  //     oxygen: json['O2'] ?? 0,
  //     temperature: (json['T'] ?? 0).toDouble(),
  //     steps: json['ST'] ?? 0,
  //     lat: (json['GPS'] != null ? json['GPS']['lat'] : 0.0).toDouble(),
  //     lon: (json['GPS'] != null ? json['GPS']['lon'] : 0.0).toDouble(),
  //     position: json['POS'] ?? 0,
  //     sos: json['SOS'] ?? 0,
  //     shake: json['SHK'] ?? 0,
  //     isSynced: false,
  //   );
  // }

  factory HealthReadingModel.fromWatchJson(
    Map<String, dynamic> json,
    String userId,
  ) {
    int boolToInt(dynamic v) {
      if (v is bool) return v ? 1 : 0;
      if (v is int) return v;
      return 0;
    }

    int toInt(dynamic v) {
      if (v is num) return v.toInt();
      return 0;
    }

    double toDouble(dynamic v) {
      if (v is num) return v.toDouble();
      return 0.0;
    }

    return HealthReadingModel(
      userId: userId,
      timestamp: DateTime.now().toIso8601String(),

      heartRate: toInt(json['HR']),
      oxygen: toInt(json['O2']),
      speed: toInt(json['SP']),
      steps: toInt(json['ST']),

      lat: toDouble(json['GPS']?['lat']),
      lon: toDouble(json['GPS']?['lon']),

      position: toInt(json['POS']),

      sos: boolToInt(json['SOS']),
      shake: boolToInt(json['SHAKE'] ?? json['SHK']),

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
        "speed": speed,
        "steps": steps,
        "gps": {"lat": lat, "lon": lon},
        "Sitting or Standing": position,
        "Walking or Running": 0,
        "SOS": sos,
        "Shake": shake,
      },
    };
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': key,
  //     'userId': userId,
  //     'timestamp': timestamp,
  //     'heartRate': heartRate,
  //     'oxygen': oxygen,
  //     'temperature': temperature,
  //     'steps': steps,
  //     'lat': lat,
  //     'lon': lon,
  //     'position': position,
  //     'sos': sos,
  //     'shake': shake,
  //     'isSynced': isSynced ? 1 : 0,
  //   };
  // }
}
