import 'package:aura_project/fratuers/calendar/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyCalendarStrip extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<EventModel> allEvents;

  const WeeklyCalendarStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.allEvents,
  });

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected = _isSameDay(date, selectedDate);
          bool hasEvent = allEvents.any(
            (event) => _isSameDay(event.date, date),
          );

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFC9D5EA)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? Border.all(color: const Color(0xFF194B96), width: 1.5)
                    : (hasEvent
                          ? Border.all(
                              color: const Color(0xFFACACAC),
                              width: 1.5,
                            )
                          : null),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date),
                    style: TextStyle(
                      color: hasEvent ? Color(0xff194B96) : Color(0xff212121),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Color(0xff212121)
                          : (hasEvent
                                ? const Color(0xFF194B96)
                                : Color(0xff616161)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (hasEvent)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF194B96),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventModel event;
  final bool showHeader;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const EventCard({
    super.key,
    required this.event,
    required this.showHeader,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader)
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 10),
            child: Row(
              children: [
                Text(
                  DateFormat('MMM d - ').format(event.date),
                  style: const TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 16,
                  ),
                ),
                Text(
                  DateFormat('EEEE').format(event.date),
                  style: const TextStyle(
                    color: Color(0xFF194B96),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.time,
                      style: const TextStyle(
                        color: Color(0xFF194B96),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff616161),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffe8edf4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF194B96),
                  ),
                  onPressed: onEdit,
                ),
              ),
              SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 253, 218, 214),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: onDelete,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
