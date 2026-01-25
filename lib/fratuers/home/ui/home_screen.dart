import 'dart:async';

import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/services/notification_service.dart';
import 'package:aura_project/core/style/colors.dart';
import 'package:aura_project/fratuers/bluetooth/logic/bluetooth_cubit.dart';
import 'package:aura_project/fratuers/bluetooth/logic/bluetooth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "My Health",
          style: TextStyle(
            color: AppColors.text100Color,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {
              context.pushNamed(Routes.profile);
            },
          ),
        ],
      ),

      body: BlocConsumer<BluetoothCubit, BluetoothState>(
        listener: (context, state) {
          if (state is BluetoothEmergencyState) {
            _showEmergencyDialog(context, state.message);
          }
        },
        builder: (context, state) {
          int hr = 0;
          int spo2 = 0;
          int speed = 0;
          int steps = 0;
          int sos = 0;
          int shake = 0;
          bool isConnected = false;

          if (state is BluetoothDataReceived) {
            hr = state.data.heartRate;
            spo2 = state.data.oxygen;
            speed = state.data.speed;
            steps = state.data.steps;
            sos = state.data.sos;
            shake = state.data.shake;
            isConnected = true;
          } else if (state is BluetoothConnected) {
            isConnected = true;
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(context.screenWidth * 0.05),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isConnected
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isConnected ? Colors.green : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 12,
                        color: isConnected ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isConnected
                            ? "Connected to Aura Watch"
                            : "Device Disconnected",
                        style: TextStyle(
                          color: isConnected ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.0,
                  children: [
                    _buildHealthCard(
                      "Heart Rate",
                      "$hr",
                      "BPM",
                      Icons.favorite,
                      Colors.red,
                    ),
                    _buildHealthCard(
                      "Blood Oxygen",
                      "$spo2",
                      "%",
                      Icons.air,
                      Colors.blue,
                    ),
                    _buildHealthCard(
                      "Speed",
                      speed.toStringAsFixed(1),
                      "Km/h",
                      Icons.speed,
                      Colors.orange,
                    ),
                    _buildHealthCard(
                      "Steps",
                      "$steps",
                      "steps",
                      Icons.directions_walk,
                      Colors.green,
                    ),

                    _buildHealthCard(
                      "SOS Status",
                      sos == 1 ? "ALERT!" : "Safe",
                      "",
                      Icons.sos,
                      sos == 1 ? Colors.red : Colors.green,
                    ),

                    _buildHealthCard(
                      "Fall Check",
                      shake == 1 ? "FALL!" : "Stable",
                      "",
                      Icons.personal_injury,
                      shake == 1 ? Colors.red : Colors.green,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                if (!isConnected)
                  ElevatedButton.icon(
                    onPressed: () {
                      context.pushNamed(Routes.bluetoothConnect);
                    },
                    icon: const Icon(
                      Icons.bluetooth_searching,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Connect Device",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHealthCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.text100Color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            unit.isEmpty ? title : "$unit $title",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
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
