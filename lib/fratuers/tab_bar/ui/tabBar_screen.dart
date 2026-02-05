import 'package:aura_project/fratuers/profile/logic/profile_cubit.dart';
import 'package:aura_project/fratuers/tab_bar/logic/tabBar_cubit.dart';
import 'package:aura_project/fratuers/tab_bar/logic/tabBar_state.dart';
import 'package:aura_project/fratuers/trends/logic/trends_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LayoutCubit()),

        BlocProvider(create: (context) => ProfileCubit()..initProfile()),
        BlocProvider(create: (context) => TrendsCubit()..loadData()),
      ],
      child: BlocBuilder<LayoutCubit, LayoutState>(
        builder: (context, state) {
          var cubit = LayoutCubit.get(context);

          return Scaffold(
            body: cubit.screens[cubit.currentIndex],

            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeBottomNav(index);
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                elevation: 0,

                selectedItemColor: const Color(0xff194B96),
                unselectedItemColor: Colors.grey,

                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),

                items: [
                  _buildPngItem(
                    iconPath: 'assets/images/tabBar/home.png',
                    activeIconPath: 'assets/images/tabBar/home_active.png',
                    label: "Home",
                    isSelected: cubit.currentIndex == 0,
                  ),
                  _buildPngItem(
                    iconPath: 'assets/images/tabBar/clander.png',
                    activeIconPath: 'assets/images/tabBar/clander_active.png',
                    label: "Calendar",
                    isSelected: cubit.currentIndex == 1,
                  ),
                  _buildPngItem(
                    iconPath: 'assets/images/tabBar/trends.png',
                    activeIconPath: 'assets/images/tabBar/trends_active.png',
                    label: "Trends",
                    isSelected: cubit.currentIndex == 2,
                  ),
                  _buildPngItem(
                    iconPath: 'assets/images/tabBar/watch.png',
                    activeIconPath: 'assets/images/tabBar/watch_active.png',
                    label: "Watch",
                    isSelected: cubit.currentIndex == 3,
                  ),
                  _buildPngItem(
                    iconPath: 'assets/images/tabBar/profile.png',
                    activeIconPath: 'assets/images/tabBar/profile_active.png',
                    label: "Profile",
                    isSelected: cubit.currentIndex == 4,
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

BottomNavigationBarItem _buildPngItem({
  required String iconPath,
  required String activeIconPath,
  required String label,
  required bool isSelected,
}) {
  return BottomNavigationBarItem(
    icon: Image.asset(
      iconPath,
      width: 30,
      height: 30,
      color: Color(0xffACACAC),
    ),
    activeIcon: Image.asset(
      activeIconPath,
      width: 30,
      height: 30,
      color: const Color(0xff194B96),
    ),
    label: label,
  );
}
