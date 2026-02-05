import 'package:aura_project/fratuers/device/logic/device_cubit.dart';
import 'package:aura_project/fratuers/device/logic/device_state.dart';
import 'package:aura_project/fratuers/device/ui/device_infprmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceCubit(),
      child: BlocBuilder<DeviceCubit, DeviceState>(
        builder: (context, state) {
          var cubit = DeviceCubit.get(context);
          bool isConnected = state.status == ConnectionStatus.connected;

          return Scaffold(
            backgroundColor: const Color(0xffF5F8FF),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                "Device",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(context, state, cubit),

                  const SizedBox(height: 24),

                  _buildSectionHeader(
                    "Health Monitoring",
                    isConnected ? "Activate" : "Deactivate",
                    isConnected,
                  ),
                  const SizedBox(height: 8),

                  Opacity(
                    opacity: isConnected ? 1.0 : 0.5,
                    child: IgnorePointer(
                      ignoring: !isConnected,
                      child: Column(
                        children: [
                          _buildSwitchTile(
                            "Health Rate Monitoring",
                            "Measure heart rate continuously",
                            'assets/images/watch_icon/heart.png',
                            state.isHeartRateEnabled,
                            (v) => cubit.toggleHeartRate(v),
                          ),
                          _buildSwitchTile(
                            "Blood Oxygen Monitoring",
                            "Measure SpO2 levels continuously",
                            'assets/images/watch_icon/blood.png',
                            state.isBloodOxygenEnabled,
                            (v) => cubit.toggleBloodOxygen(v),
                          ),
                          _buildSwitchTile(
                            "Activity Detection",
                            "Track walking, setting, moving",
                            'assets/images/watch_icon/activaity.png',
                            state.isActivityEnabled,
                            (v) => cubit.toggleActivity(v),
                          ),
                          _buildSwitchTile(
                            "GPS Tracking",
                            "Detect falls and get immediate help",
                            'assets/images/watch_icon/gps.png',
                            state.isGpsEnabled,
                            (v) => cubit.toggleGps(v),
                          ),
                          _buildSwitchTile(
                            "Auto Sync",
                            "Automatically sync data",
                            'assets/images/watch_icon/sync.png',
                            state.isAutoSyncEnabled,
                            (v) => cubit.toggleAutoSync(v),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  _buildSectionHeader("Safety & Emergency", null, isConnected),
                  const SizedBox(height: 10),
                  Opacity(
                    opacity: isConnected ? 1.0 : 0.5,
                    child: IgnorePointer(
                      ignoring: !isConnected,
                      child: Column(
                        children: [
                          _buildSwitchTile(
                            "SOS Emergency",
                            "Hold 3s for Emergency SOS",
                            'assets/images/watch_icon/sos.png',
                            state.isSosEnabled,
                            (v) => cubit.toggleSos(v),
                          ),
                          _buildSwitchTile(
                            "Fall Detection",
                            "Detect falls and get immediate help",
                            'assets/images/watch_icon/fall.png',
                            state.isFallDetectionEnabled,
                            (v) => cubit.toggleFallDetection(v),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 11),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xffE0E0E0)),
                    ),
                    child: ListTile(
                      title: const Text(
                        "Device Information",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff212121),
                          fontSize: 15,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xffACACAC),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const DeviceInfprmationScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xffE0E0E0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                color: Color(0xffEB5757).withOpacity(.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.error,
                                color: Color(0xffEB5757),
                              ),
                            ),
                            SizedBox(width: 8),
                            const Text(
                              "Danger Zone",
                              style: TextStyle(
                                color: Color(0xffEB5757),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: () {
                            _showResetDialog(context, cubit);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffEB5757),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Reset Watch",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "This will erase all data from the watch and restore factory settings.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff616161),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
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

  Widget _buildStatusCard(
    BuildContext context,
    DeviceState state,
    DeviceCubit cubit,
  ) {
    bool isConnected = state.status == ConnectionStatus.connected;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xffE0E0E0)),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.watch, size: 40, color: Colors.blue),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Watch Status:",
                        style: TextStyle(
                          color: Color(0xff212121),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isConnected) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.battery_std,
                              size: 16,
                              color: Colors.green,
                            ),
                            Text(
                              "${state.batteryLevel}%",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        const Text(
                          "0%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isConnected
                          ? Color(0xff27AE60)
                          : Color(0xffE53935),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    isConnected ? "Connected" : "Disconnected",
                    style: TextStyle(
                      color: isConnected
                          ? Color(0xff27AE60)
                          : Color(0xffE53935),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (isConnected)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Last Sync: ${state.lastSync}",
                style: const TextStyle(
                  color: Color(0xff616161),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          else
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => cubit.toggleConnection(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1A56DB),
                    ),
                    child: const Text(
                      "Reconnect Device",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Troubleshoot Connection",
                    style: TextStyle(color: Color(0xff1A56DB)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? actionText, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        if (actionText != null)
          Container(
            width: 120,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? Color(0xff27AE60) : Color(0xffACACAC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xffE0E0E0)),
            ),
            child: Center(
              child: Text(
                actionText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    String image,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE0E0E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(image, scale: 1.5),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12.3,
                          color: Color(0xff616161),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xff194B96),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xffD1D1D1),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, DeviceCubit cubit) {
    bool isChecked = false;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xffF8F9FD),
          title: const Center(
            child: Text(
              "Reset Watch",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Color(0xff212121),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Are you sure you want to reset your watch? This will erase all health data and restore factory settings.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff616161),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (v) => setState(() => isChecked = v!),
                    activeColor: Color(0xffEB5757),
                  ),
                  const Expanded(
                    child: Text(
                      "I understand this action cannot be undone",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff212121),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isChecked
                    ? () {
                        cubit.resetWatch();
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffEB5757),
                  disabledBackgroundColor: Color(0xffEB5757).withOpacity(0.3),
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Yes, Reset Watch",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  side: const BorderSide(color: Color(0xffEB5757)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Color(0xffEB5757)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
