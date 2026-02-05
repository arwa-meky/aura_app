import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/fratuers/bluetooth/logic/bluetooth_cubit.dart';
import 'package:aura_project/fratuers/bluetooth/logic/bluetooth_state.dart';
import 'package:aura_project/fratuers/profile_test/logic/logout_cubit.dart';
import 'package:aura_project/fratuers/profile_test/logic/logout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileTestScreen extends StatefulWidget {
  const ProfileTestScreen({super.key});

  @override
  State<ProfileTestScreen> createState() => _ProfileTestScreenState();
}

class _ProfileTestScreenState extends State<ProfileTestScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BluetoothCubit>().fetchMyDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My Linked Devices",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: BlocBuilder<BluetoothCubit, BluetoothState>(
                  builder: (context, state) {
                    final bluetoothCubit = context.read<BluetoothCubit>();
                    final devices = bluetoothCubit.myPairedDevices;

                    if (devices.isEmpty) {
                      return const Center(
                        child: Text(
                          "No devices linked yet.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: devices.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFFE3F2FD),
                              child: Icon(
                                Icons.watch,
                                color: Color(0xff194B96),
                              ),
                            ),
                            title: Text(
                              device['deviceName'] ?? "Unknown Device",
                            ),
                            subtitle: Text(device['deviceId'] ?? ""),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                bluetoothCubit.removeDevice(device['deviceId']);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              BlocConsumer<LogoutCubit, LogoutState>(
                listener: (context, state) {
                  if (state is LogoutSuccess) {
                    context.pushNamedAndRemoveAll(Routes.welcome);
                  }
                },
                builder: (context, state) {
                  return state is LogoutLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: "Logout",
                            onPressed: () {
                              try {
                                context.read<BluetoothCubit>().stopEverything();
                              } catch (e) {
                                print("Bluetooth stop error: $e");
                              }

                              context.read<LogoutCubit>().logout();
                            },
                          ),
                        );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
