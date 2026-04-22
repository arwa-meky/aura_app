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

  @HiveField(12)
  final int battery;

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
    required this.battery,
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
      battery: toInt(json['BAT']), // افترضت أن الكي هو 'BAT'

      isSynced: false,
    );
  }

  // Map<String, dynamic> toBackendJson() {
  //   return {
  //     "user_id": userId,
  //     "timestamp": timestamp,
  //     "data": {
  //       "heartRate": heartRate,
  //       "spO2": oxygen,
  //       "speed": speed,
  //       "steps": steps,
  //       "gps": {"lat": lat, "lon": lon},
  //       "Sitting or Standing": position,
  //       "SOS": sos,
  //       "Shake": shake,
  //       "battery": battery,
  //     },
  //   };
  // }
  Map<String, dynamic> toBackendJson({
    required double weight,
    required double height,
    required int age,
    required int gender,
  }) {
    DateTime dt = DateTime.tryParse(timestamp) ?? DateTime.now();
    double heightInMeters = height / 100;
    double bmi = (heightInMeters > 0)
        ? weight / (heightInMeters * heightInMeters)
        : 0.0;
    double strideLength = (gender == 0) ? height * 0.415 : height * 0.413;
    double distanceInMeters = (steps * strideLength) / 100;
    double distanceKm = distanceInMeters / 1000;
    double caloriesBurned = steps * (weight * 0.0005);
    double calculatedHrv = 40.0 + (heartRate % 10);

    return {
      "User_ID": userId,
      "Age": age,
      "Gender": gender,
      "Height_cm": height,
      "Weight_kg": weight,
      "BMI": double.parse(bmi.toStringAsFixed(1)),
      "Fitness_Level": (steps < 5000)
          ? 1
          : ((steps > 10000) ? 3 : 2), ///////////
      "Timestamp": timestamp,
      "Hour": dt.hour,
      "Day_of_Week": dt.weekday,
      "Heart_Rate": heartRate.toDouble(),
      "SpO2": oxygen.toDouble(),
      "HRV": double.parse(calculatedHrv.toStringAsFixed(1)), ////////
      "Activity_Label": position, ////////////////
      "Speed_kmh": speed.toDouble(),
      "Steps_Interval": (steps * 0.02).toInt(), ////////
      "Total_Steps": steps,
      "Calories": caloriesBurned.toInt(), ////////
      "Distance_km": double.parse(distanceKm.toStringAsFixed(2)), //////
    };
  }

  factory HealthReadingModel.fromProcessedJson(Map<String, dynamic> json) {
    final dataMap = json['data'] as Map<String, dynamic>;
    final gpsMap = dataMap['gps'] as Map<String, dynamic>;

    return HealthReadingModel(
      userId: json['user_id'] ?? "",
      timestamp: json['timestamp'] ?? "",
      heartRate: (dataMap['heartRate'] ?? 0).toInt(),
      oxygen: (dataMap['spO2'] ?? 0).toInt(),
      speed: (dataMap['speed'] ?? 0).toInt(),
      steps: (dataMap['steps'] ?? 0).toInt(),
      lat: (gpsMap['lat'] ?? 0.0).toDouble(),
      lon: (gpsMap['lon'] ?? 0.0).toDouble(),
      position: (dataMap['Sitting or Standing'] ?? 0).toInt(),
      sos: (dataMap['SOS'] ?? 0).toInt(),
      shake: (dataMap['Shake'] ?? 0).toInt(),
      battery: (dataMap['battery'] ?? 0).toInt(),
      isSynced: true,
    );
  }
}
