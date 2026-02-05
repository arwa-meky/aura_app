import 'package:aura_project/fratuers/calendar/logic/calender_state.dart';
import 'package:aura_project/fratuers/calendar/model/event_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarInitial());

  static CalendarCubit get(context) => BlocProvider.of(context);

  final Box<EventModel> eventBox = Hive.box<EventModel>('events_box');
  DateTime selectedDate = DateTime.now();

  void changeSelectedDate(DateTime date) {
    selectedDate = date;
    emit(CalendarUpdated());
  }

  Future<void> addEvent(EventModel event) async {
    await eventBox.add(event);
    emit(CalendarUpdated());
  }

  Future<void> updateEvent(dynamic key, EventModel event) async {
    await eventBox.put(key, event);
    emit(CalendarUpdated());
  }

  Future<void> deleteEvent(dynamic key) async {
    await eventBox.delete(key);
    emit(CalendarUpdated());
  }

  Future<void> clearAllEvents() async {
    await eventBox.clear();
    emit(CalendarUpdated());
  }

  void refreshCalendar() {
    emit(CalendarUpdated());
  }

  List<EventModel> get sortedEvents {
    List<EventModel> events = eventBox.values.toList();
    events.sort((a, b) {
      int dateComp = a.date.compareTo(b.date);
      return dateComp == 0 ? a.time.compareTo(b.time) : dateComp;
    });
    return events;
  }
}
