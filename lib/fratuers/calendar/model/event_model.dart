import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 2)
class EventModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String time;

  EventModel({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
  });
}
