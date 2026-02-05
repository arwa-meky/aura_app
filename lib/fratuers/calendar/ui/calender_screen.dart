import 'package:aura_project/fratuers/calendar/logic/calender_cubit.dart';
import 'package:aura_project/fratuers/calendar/logic/calender_state.dart';
import 'package:aura_project/fratuers/calendar/ui/calender_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_event_screen.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarCubit(),
      child: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          var cubit = CalendarCubit.get(context);
          var allEvents = cubit.sortedEvents;

          return Scaffold(
            backgroundColor: const Color(0xffF5F8FF),
            appBar: AppBar(
              backgroundColor: const Color(0xffF5F8FF),
              elevation: 0,

              title: const Text(
                "Calendar",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF194B96),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddEventScreen(),
                        ),
                      ).then((_) => cubit.refreshCalendar());
                    },
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                WeeklyCalendarStrip(
                  selectedDate: cubit.selectedDate,
                  allEvents: allEvents,
                  onDateSelected: (date) => cubit.changeSelectedDate(date),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "My Events",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () => cubit.clearAllEvents(),
                        child: const Text(
                          "Clear all",
                          style: TextStyle(color: Color(0xff616161)),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: allEvents.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: allEvents.length,
                          itemBuilder: (context, index) {
                            final event = allEvents[index];
                            bool showHeader = true;
                            if (index > 0) {
                              if (event.date.year ==
                                      allEvents[index - 1].date.year &&
                                  event.date.month ==
                                      allEvents[index - 1].date.month &&
                                  event.date.day ==
                                      allEvents[index - 1].date.day) {
                                showHeader = false;
                              }
                            }

                            return EventCard(
                              event: event,
                              showHeader: showHeader,
                              onDelete: () => cubit.deleteEvent(event.key),
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddEventScreen(eventToEdit: event),
                                  ),
                                ).then((_) => cubit.refreshCalendar());
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/clander.png',
          color: Color(0xffC9D5EA),
          scale: 1.6,
        ),
        const SizedBox(height: 16),
        const Text(
          "No events scheduled",
          style: TextStyle(color: Color(0xff616161), fontSize: 16),
        ),
      ],
    );
  }
}
