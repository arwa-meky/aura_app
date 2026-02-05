import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura_project/fratuers/profile/logic/profile_cubit.dart';
import 'package:aura_project/fratuers/profile/logic/profile_state.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xffF8F9FD),
          appBar: AppBar(
            title: const Text(
              "Notification",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildSwitchItem(
                  title: "General Notification",
                  value: cubit.notifyGeneral,
                  onChanged: (val) =>
                      cubit.changeNotificationSwitch('general', val),
                ),
                const SizedBox(height: 15),

                _buildSwitchItem(
                  title: "Sound",
                  value: cubit.notifySound,
                  onChanged: (val) =>
                      cubit.changeNotificationSwitch('sound', val),
                ),
                const SizedBox(height: 15),

                _buildSwitchItem(
                  title: "Vibrate",
                  value: cubit.notifyVibrate,
                  onChanged: (val) =>
                      cubit.changeNotificationSwitch('vibrate', val),
                ),
                const SizedBox(height: 15),

                _buildSwitchItem(
                  title: "App Updates",
                  value: cubit.notifyUpdates,
                  onChanged: (val) =>
                      cubit.changeNotificationSwitch('updates', val),
                ),
                const SizedBox(height: 15),

                _buildSwitchItem(
                  title: "New Service Available",
                  value: cubit.notifyNewService,
                  onChanged: (val) =>
                      cubit.changeNotificationSwitch('service', val),
                ),
                const SizedBox(height: 15),

                _buildSwitchItem(
                  title: "New Tips Available",
                  value: cubit.notifyTips,
                  onChanged: (val) =>
                      cubit.changeNotificationSwitch('tips', val),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xffE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xff194B96),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xffACACAC),
          ),
        ],
      ),
    );
  }
}
