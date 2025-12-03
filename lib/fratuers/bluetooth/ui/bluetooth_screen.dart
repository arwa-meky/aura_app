import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/helpers/storage/local_storage.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/style/colors.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/fratuers/bluetooth/logic/bluetooth_cubit.dart';
import 'package:aura_project/fratuers/bluetooth/logic/bluetooth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' hide BluetoothState;

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BluetoothCubit>().startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: BlocConsumer<BluetoothCubit, BluetoothState>(
        listener: (context, state) {
          if (state is BluetoothConnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Connected to ${state.deviceName}"),
                backgroundColor: Colors.green,
              ),
            );
            context.pushNamedAndRemoveAll(Routes.home);
          } else if (state is BluetoothError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<BluetoothCubit>();

          if (state is BluetoothConnecting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Connecting to your Aura Band..."),
                ],
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.screenWidth * 0.04,
                    vertical: context.usableHeight * 0.01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                      Image.asset(
                        'assets/images/logo_name.png',
                        width: context.screenWidth * 0.25,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                if (state is BluetoothScanning)
                  const LinearProgressIndicator(color: AppColors.primaryColor),

                Padding(
                  padding: EdgeInsets.all(context.screenWidth * 0.05),
                  child: const Text(
                    "Select your device to pair",
                    style: TextStyle(
                      color: AppColors.textBodyColor,
                      fontSize: 16,
                    ),
                  ),
                ),

                Expanded(child: _buildDeviceList(state, cubit)),

                Padding(
                  padding: EdgeInsets.all(context.screenWidth * 0.05),
                  child: CustomButton(
                    text: (state is BluetoothScanning)
                        ? "Scanning..."
                        : "Rescan",
                    isOutlined: (state is BluetoothScanning),
                    onPressed: () {
                      if (state is! BluetoothScanning) {
                        cubit.startScan();
                      }
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    cubit.startSimulation(); // for demo
                  },
                  child: const Text(
                    "No Watch? Try Demo Mode",
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
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

  Widget _buildDeviceList(BluetoothState state, BluetoothCubit cubit) {
    List<ScanResult> devices = [];

    if (state is BluetoothScanning) {
      devices = state.results;
    } else if (state is BluetoothScanStopped) {
      devices = state.results;
    }

    if (devices.isEmpty) {
      return const Center(
        child: Text(
          "No devices found.\nMake sure your watch is ON.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      itemCount: devices.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final device = devices[index].device;
        final String deviceId = device.remoteId.toString();

        String displayName =
            LocalStorage.getCustomDeviceName(deviceId) ??
            (device.platformName.isEmpty
                ? "Unknown Device"
                : device.platformName);

        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFE3F2FD),
            child: Icon(Icons.watch, color: AppColors.primaryColor),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  displayName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                onPressed: () =>
                    _showRenameDialog(context, cubit, deviceId, displayName),
              ),
            ],
          ),
          subtitle: Text(
            deviceId,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () => cubit.connectToDevice(device),
            child: const Text(
              "Connect",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        );
      },
    );
  }

  void _showRenameDialog(
    BuildContext context,
    BluetoothCubit cubit,
    String deviceId,
    String currentName,
  ) {
    TextEditingController nameController = TextEditingController(
      text: currentName,
    );
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Rename Device"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Enter new name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.saveDeviceNickname(deviceId, nameController.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
