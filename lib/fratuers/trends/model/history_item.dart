import 'package:hive/hive.dart';

part 'history_item.g.dart';

@HiveType(typeId: 4)
class HistoryItem extends HiveObject {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final double value;

  HistoryItem({required this.date, required this.type, required this.value});
}
