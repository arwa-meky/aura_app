import 'package:aura_project/fratuers/calendar/ui/calender_screen.dart';
import 'package:aura_project/fratuers/device/ui/device_screen.dart';
import 'package:aura_project/fratuers/home/home_screen.dart';
import 'package:aura_project/fratuers/profile/ui/profile_screen.dart';
import 'package:aura_project/fratuers/tab_bar/logic/tabBar_state.dart';
import 'package:aura_project/fratuers/trends/ui/trends_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial());

  static LayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    const HomeScreen(),
    const CalendarScreen(),
    const TrendsScreen(),
    const DeviceScreen(),
    const ProfileScreen(),
  ];

  List<String> titles = ["Home", "Calendar", "Trends", "Device", "Profile"];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(LayoutChangeBottomNavState());
  }
}
