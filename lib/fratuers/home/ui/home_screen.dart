import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
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
          double temp = 0.0;
          int steps = 0;
          bool isConnected = false;

          if (state is BluetoothDataReceived) {
            hr = state.data.heartRate;
            spo2 = state.data.oxygen;
            temp = state.data.temperature;
            steps = state.data.steps;
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
                            ? "Connected to Aura Band"
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
                      "Temperature",
                      temp.toStringAsFixed(1),
                      "°C",
                      Icons.thermostat,
                      Colors.orange,
                    ),
                    _buildHealthCard(
                      "Steps",
                      "$steps",
                      "steps",
                      Icons.directions_walk,
                      Colors.green,
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
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.text100Color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "$unit $title",
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
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 10),
            Text("EMERGENCY"),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("I'm OK", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              //  كود الاتصال برقم الطوارئ
            },
            child: const Text(
              "Call Help",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
