import 'dart:async';
import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/helpers/storage/local_storage.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/services/notification_service.dart';
import 'package:aura_project/fratuers/bluetooth/logic/bluetooth_cubit.dart';
import 'package:aura_project/fratuers/bluetooth/logic/bluetooth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final savedDeviceId = LocalStorage.getDeviceId;
    if (savedDeviceId != null) {
      context.read<BluetoothCubit>().getDeviceStreak(savedDeviceId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BluetoothCubit>();
    String lastSyncTime = LocalStorage.getLastSyncTime() ?? "Unknown";
    String timeAgo = _getTimeAgo(lastSyncTime);

    return Scaffold(
      backgroundColor: const Color(0xffF8F9FD),
      body: BlocConsumer<BluetoothCubit, BluetoothState>(
        listener: (context, state) {
          if (state is BluetoothEmergencyState) {
            _showEmergencyDialog(context, state.message);
          }

          if (state is BluetoothConnected) {
            final deviceId = LocalStorage.getDeviceId;
            if (deviceId != null) {
              cubit.getDeviceStreak(deviceId);
            }
          }

          if (state is BluetoothDataReceived) {
            if (state.data.lat != 0 && state.data.lon != 0) {
              cubit.updateLocationAddress(state.data.lat, state.data.lon);
            }
          }
        },
        builder: (context, state) {
          int hr = 0;
          int spo2 = 0;
          int speed = 0;
          int steps = 0;
          bool isConnected = false;
          int deviceStatus = 0;
          int battery = 75;
          if (state is BluetoothDataReceived) {
            hr = state.data.heartRate;
            spo2 = state.data.oxygen;
            speed = state.data.speed;
            steps = state.data.steps;
            deviceStatus = state.data.position;
            isConnected = true;
            timeAgo = "Just now";
          } else if (state is BluetoothConnected) {
            isConnected = true;
          }

          final statusAttr = _getStatusAttributes(deviceStatus);
          final currentAddress = cubit.currentAddress;
          final currentStreak = cubit.currentStreak;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),

                  const SizedBox(height: 20),

                  _buildDeviceStatusCard(
                    context,
                    isConnected,
                    battery,
                    timeAgo,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Todays Overview",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (!isConnected)
                        const Text(
                          "Last recorded...",
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _buildVitalCard(
                          icon: Icons.favorite,
                          title: "Heart Rate",
                          value: "$hr",
                          unit: "BPM",
                          color: Colors.red,
                          status: hr > 0 ? "Normal" : null,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildVitalCard(
                          icon: Icons.water_drop,
                          title: "Blood Oxygen",
                          value: "$spo2",
                          unit: "%",
                          color: Colors.blue,
                          status: spo2 > 90 ? "Normal" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildVitalCard(
                          icon: Icons.flash_on,
                          title: "Speed",
                          value: "$speed",
                          unit: "Km/h",
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildVitalCard(
                          icon: Icons.directions_walk,
                          title: "Steps",
                          value: "$steps",
                          unit: "Steps",
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildCurrentStatusCard(
                    statusText: statusAttr['text'],
                    icon: statusAttr['icon'],
                    color: statusAttr['color'],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Location",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  _buildLocationCard(currentAddress),

                  const SizedBox(height: 20),

                  _buildStreakCard(currentStreak),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Map<String, dynamic> _getStatusAttributes(int status) {
    if (status == 1) {
      return {
        'text': 'Walking',
        'icon': Icons.directions_walk,
        'color': const Color(0xff1A56DB),
      };
    } else {
      return {'text': 'Sitting', 'icon': Icons.chair, 'color': Colors.grey};
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Good Morning, User",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 4),
            Text(
              "All vitals look stable today.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        InkWell(
          onTap: () => context.pushNamed(Routes.profile),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(Icons.person_outline, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceStatusCard(
    BuildContext context,
    bool isConnected,
    int battery,
    String timeAgo,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.watch, color: Colors.black54),
              ),
              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Watch Status:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),

                    if (isConnected)
                      Row(
                        children: [
                          Icon(
                            _getBatteryIcon(battery),
                            size: 16,
                            color: _getBatteryColor(battery),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$battery%",
                            style: TextStyle(
                              fontSize: 12,
                              color: _getBatteryColor(battery),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    else
                      const Text(
                        "Not Connected",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),

                    const SizedBox(height: 2),

                    Text(
                      isConnected
                          ? "Syncing live data..."
                          : "Last sync: $timeAgo",
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isConnected
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 3,
                      backgroundColor: isConnected ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isConnected ? "Connected" : "Disconnected",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isConnected ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),
          const Divider(height: 1, color: Color(0xffEEEEEE)),
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 40,
            child: isConnected
                ? OutlinedButton(
                    onPressed: () {
                      //
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xff1A56DB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Manage Device",
                      style: TextStyle(color: Color(0xff1A56DB)),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () => context.pushNamed(Routes.bluetoothConnect),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1A56DB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Reconnect Device",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(String? timeString) {
    if (timeString == null || timeString == "Unknown") return "Never";
    try {
      DateTime lastSync = DateTime.parse(timeString);
      Duration diff = DateTime.now().difference(lastSync);

      if (diff.inSeconds < 60) return "Just now";
      if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
      if (diff.inHours < 24) return "${diff.inHours} hours ago";
      return "${diff.inDays} days ago";
    } catch (e) {
      return "Unknown";
    }
  }

  IconData _getBatteryIcon(int level) {
    if (level >= 90) return Icons.battery_full;
    if (level >= 60) return Icons.battery_6_bar;
    if (level >= 40) return Icons.battery_4_bar;
    if (level >= 20) return Icons.battery_2_bar;
    return Icons.battery_alert;
  }

  Color _getBatteryColor(int level) {
    if (level > 20) return Colors.green;
    return Colors.red;
  }

  Widget _buildCurrentStatusCard({
    required String statusText,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Current Status",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(
                      text: "$statusText ",
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: "Detected via Watch",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalCard({
    required IconData icon,
    required String title,
    required String value,
    required String unit,
    required Color color,
    String? status,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              if (status != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(String address) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage("assets/images/map_placeholder.png"),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, color: Color(0xff1A56DB), size: 16),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  address,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakCard(int streak) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.orange,
            size: 30,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$streak Days Streak",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Text(
                "You are building a healthy habit.",
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => EmergencyCountdownDialog(message: message),
    );
  }
}

class EmergencyCountdownDialog extends StatefulWidget {
  final String message;

  const EmergencyCountdownDialog({super.key, required this.message});

  @override
  State<EmergencyCountdownDialog> createState() =>
      _EmergencyCountdownDialogState();
}

class _EmergencyCountdownDialogState extends State<EmergencyCountdownDialog> {
  Timer? _timer;
  int _timeLeft = 10;
  StreamSubscription? _cancelSubscription;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _cancelSubscription = NotificationService().onCancelStream.listen((_) {
      if (mounted) {
        print('Diaolg recived cancel signal from notification!');
        _timer?.cancel();
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          setState(() {
            _timeLeft--;
          });
        } else {
          _timer?.cancel();

          if (Navigator.canPop(context)) Navigator.pop(context);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cancelSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
            SizedBox(width: 10),
            Text(
              "EMERGENCY",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: Text(
                "$_timeLeft",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Auto-calling help in...",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                NotificationService().stopEmergencySequence();
                Navigator.pop(context);
              },
              child: const Text(
                "I'm OK",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
