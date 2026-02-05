import 'package:aura_project/fratuers/trends/model/history_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static const String boxName = 'health_history';

  static Box<HistoryItem> getBox() {
    return Hive.box<HistoryItem>(boxName);
  }

  static Future<void> saveDailyAverage(
    String date,
    String type,
    double value,
  ) async {
    final box = getBox();
    final key = "${date}_$type";

    final item = HistoryItem(date: date, type: type, value: value);
    await box.put(key, item);
  }

  static List<HistoryItem> getHistory(String type, int daysAgo) {
    final box = getBox();
    final startDate = DateTime.now().subtract(Duration(days: daysAgo));

    return box.values.where((item) {
      DateTime itemDate = DateTime.parse(item.date);
      return item.type == type &&
          itemDate.isAfter(startDate.subtract(const Duration(days: 1)));
    }).toList();
  }
}
