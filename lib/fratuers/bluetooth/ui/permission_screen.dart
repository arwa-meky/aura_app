import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/fratuers/bluetooth/logic/permission_cubit.dart';
import 'package:aura_project/fratuers/bluetooth/logic/permission_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PermissionCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xffF5F8FF),
        body: SafeArea(
          child: BlocBuilder<PermissionCubit, PermissionState>(
            builder: (context, state) {
              final cubit = context.read<PermissionCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Image.asset(
                      'assets/images/logo_name.png',
                      width: context.screenWidth * 0.3,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 30),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Allow Required Permissions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff212121),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'To provide accurate tracking and real time health monitoring, Aura needs access to the following permissions.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff616161),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 15),

                    _buildPermissionItem(
                      icon: Icons.location_on,
                      title: 'Location Access',
                      description:
                          'Used for fall detection, emergency SOS, and activity classification.',
                      isAllowed: state.isLocationGranted,
                      onTap: () => cubit.requestPermission(Permission.location),
                    ),

                    _buildPermissionItem(
                      icon: Icons.directions_run,
                      title: 'Motion & Fitness Activity',
                      description:
                          'Used for fall detection, emergency SOS, and activity classification.',
                      isAllowed: state.isActivityGranted,
                      onTap: () => cubit.requestPermission(
                        Permission.activityRecognition,
                      ),
                    ),

                    _buildPermissionItem(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      description:
                          'Needed for urgent health alerts, reminders and doctor updates.',
                      isAllowed: state.isNotificationGranted,
                      onTap: () =>
                          cubit.requestPermission(Permission.notification),
                    ),

                    _buildPermissionItem(
                      icon: Icons.bluetooth,
                      title: 'Bluetooth',
                      description:
                          'Allows your phone to securely connect with the Aura smartwatch.',
                      isAllowed: state.isBluetoothGranted,
                      onTap: () =>
                          cubit.requestPermission(Permission.bluetoothConnect),
                    ),

                    _buildPermissionItem(
                      icon: Icons.mic,
                      title: 'Microphone',
                      description:
                          'Used only if you activate stress or panic attack monitoring.',
                      isAllowed: state.isMicGranted,
                      onTap: () =>
                          cubit.requestPermission(Permission.microphone),
                    ),
                    _buildPermissionItem(
                      icon: Icons.phone,
                      title: 'Phone Access',
                      description:
                          'Allows the app to make emergency calls automatically if a fall is detected.',
                      isAllowed: state.isPhoneGranted,
                      onTap: () => cubit.requestPermission(Permission.phone),
                    ),

                    _buildPermissionItem(
                      icon: Icons.sms,
                      title: 'SMS Messages',
                      description:
                          'Used to send your location and SOS alerts to your emergency contacts.',
                      isAllowed: state.isSmsGranted,
                      onTap: () => cubit.requestPermission(Permission.sms),
                    ),

                    const SizedBox(height: 15),

                    if (state.allGranted) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            'All permissions enabled',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              Routes.bluetoothConnect,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff194B96),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () => cubit.requestAllPermissions(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff194B96),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Enable All Permissions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    const SizedBox(height: 20),

                    Text(
                      'Your data is encrypted and securely stored. Aura never shares your information with third parties.',
                      style: TextStyle(fontSize: 11, color: Color(0xff616161)),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isAllowed,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xffE8EAF6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: const Color(0xff194B96), size: 24),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),

              GestureDetector(
                onTap: isAllowed ? null : onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isAllowed
                        ? const Color(0xFF4CAF50)
                        : const Color(0xff194B96),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isAllowed ? 'Allowed' : 'Allow',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              description,
              maxLines: 2,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xff616161),
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
