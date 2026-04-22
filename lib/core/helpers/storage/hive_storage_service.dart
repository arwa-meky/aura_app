import 'package:aura_project/fratuers/bluetooth/model/health_reading_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorageService {
  static const String _boxName = 'health_reading_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HealthReadingModelAdapter());
    }
    await Hive.openBox<HealthReadingModel>(_boxName);
  }

  static Future<Box<HealthReadingModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<HealthReadingModel>(_boxName);
    }
    return Hive.box<HealthReadingModel>(_boxName);
  }

  static Future<void> saveReading(HealthReadingModel reading) async {
    final box = await _getBox();
    await box.add(reading);
  }

  static Future<List<HealthReadingModel>> getAllUnsyncedReadings() async {
    final box = await _getBox();
    return box.values.where((item) => item.isSynced == false).toList();
  }

  static Future<void> clearAllReadings() async {
    final box = await _getBox();
    await box.clear();
    print("🧹 Local storage cleared after sync");
  }

  static const String _profileBox = 'profile_box';

  static Future<void> saveProfile(Map<String, dynamic> data) async {
    var box = Hive.box(_profileBox);
    await box.put('user_cached_data', data);
  }

  static Map<String, dynamic>? getCachedProfile() {
    // التأكد من أن الـ Box مفتوح، وإذا لم يكن، نفتحه أولاً
    if (!Hive.isBoxOpen(_profileBox)) {
      // ملحوظة: بما أن هذه الدالة ليست async، سنستخدم Hive.box()
      // ولكن يجب أن نكون قد فتحناه في الـ onStart الخاص بالـ Background
      print(
        "⚠️ Box was not open, make sure Hive.openBox was called in onStart",
      );
      return null;
    }

    var box = Hive.box(_profileBox);
    final user = box.get('user_cached_data');
    if (user == null) return null;
    return Map<String, dynamic>.from(user);
  }
}
