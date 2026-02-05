import 'dart:io';
import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/helpers/storage/local_storage.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/fratuers/bluetooth/logic/bluetooth_cubit.dart';
import 'package:aura_project/fratuers/bluetooth/logic/bluetooth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' hide BluetoothState;
import 'package:aura_project/core/widgets/custom_auth_title_desc.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/core/widgets/custom_text_button.dart';

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
      backgroundColor: const Color(0xffF5F8FF),
      body: SafeArea(
        child: BlocConsumer<BluetoothCubit, BluetoothState>(
          listener: (context, state) {
            if (state is BluetoothConnected) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Connected to ${state.deviceName}"),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
              context.pushNamedAndRemoveAll(Routes.appBar);
            } else if (state is BluetoothError) {
              if (FlutterBluePlus.adapterStateNow == BluetoothAdapterState.on) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Color(0xffD32F2F),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }
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
                    Text("Connecting to your Aura Watch..."),
                  ],
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.04,
                      vertical: context.usableHeight * 0.01,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios, size: 20),
                        ),
                        Image.asset(
                          'assets/images/logo_name.png',
                          width: context.screenWidth * 0.3,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 10,
                    ),
                    child: CustomAuthTitleDesc(
                      title: "Connect Your Aura Watch",
                      description:
                          "Make sure your smartwatch is powered on.\nTurn on Bluetooth to start scanning for nearby devices.",
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildPulseIcon(),
                  ),
                ),
                ..._buildDynamicSlivers(state, cubit),
                SliverToBoxAdapter(
                  child: StreamBuilder<BluetoothAdapterState>(
                    stream: FlutterBluePlus.adapterState,
                    initialData: BluetoothAdapterState.unknown,
                    builder: (context, snapshot) {
                      final adapterState = snapshot.data;
                      if (adapterState == BluetoothAdapterState.off) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          child: _buildBluetoothOffBanner(),
                        );
                      }
                      return _buildBottomButtons(state, cubit);
                    },
                  ),
                ),

                SliverToBoxAdapter(
                  child: CustomTextButton(
                    text: "Having trouble connecting?",
                    onPressed: () {
                      _showTroubleShootingSheet(context);
                    },
                    color: 0xff194B96,
                  ),
                ),
                SliverToBoxAdapter(
                  child: TextButton(
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showTroubleShootingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xffF5F8FF),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: Image.asset(
                  'assets/images/logo_name.png',
                  width: context.screenWidth * 0.3,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Troubleshooting",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 20),
              _buildTipItem(
                Icons.bluetooth,
                "Turn on Bluetooth on your phone.",
              ),
              _buildTipItem(Icons.refresh, "Restart your Aura watch."),
              _buildTipItem(
                Icons.phone_android,
                "Keep your phone and watch close together.",
              ),
              _buildTipItem(Icons.search, "Try scanning for devices again."),
              _buildTipItem(
                Icons.battery_full,
                "Make sure your watch is charged.",
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTipItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFc9d5ea),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: const Color(0xFF194b96), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff212121),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulseIcon() {
    return Center(
      child: Image.asset(
        'assets/images/ble.png',
        width: context.screenWidth * 0.85,
        height: context.screenHeight * .3,
        fit: BoxFit.contain,
      ),
    );
  }

  List<Widget> _buildDynamicSlivers(
    BluetoothState state,
    BluetoothCubit cubit,
  ) {
    if (state is BluetoothScanning) {
      return [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const Text(
                "Searching for available devices...",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: context.screenWidth * 0.2),
              const ScanningDots(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ];
    } else if (state is BluetoothConnected) {
      return [
        const SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 40),
              Text(
                "Connected Successfully",
                style: TextStyle(
                  color: Color(0xff4CAF50),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ];
    } else if (state is BluetoothError) {
      return [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "Connection Failed",
                style: TextStyle(
                  color: Color(0xffE53935),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Could not connect to your smartwatch.\nPlease try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ];
    } else {
      List<ScanResult> devices = (state is BluetoothScanStopped)
          ? state.results
          : [];
      if (devices.isEmpty) {
        return [
          const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(60.0),
                child: Text(
                  "No devices found",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
            ),
          ),
        ];
      }
      return [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Text(
              "Available Devices:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return _buildDeviceCard(devices[index], cubit);
            }, childCount: devices.length),
          ),
        ),
      ];
    }
  }

  Widget _buildDeviceCard(ScanResult result, BluetoothCubit cubit) {
    final device = result.device;
    final deviceId = device.remoteId.toString();
    String name =
        LocalStorage.getCustomDeviceName(deviceId) ??
        (device.platformName.isEmpty ? "Unknown Device" : device.platformName);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
      child: GestureDetector(
        onTap: () => cubit.connectToDevice(device),
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.watch, color: Color(0xFF448AFF)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text(
                    "Tap to Connect",
                    style: TextStyle(color: Color(0xFF448AFF), fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                _showRenameDialog(context, cubit, deviceId, name);
              },
              icon: const Icon(Icons.edit, color: Color(0xFF448AFF), size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BluetoothState state, BluetoothCubit cubit) {
    String text = "Scan Again";
    VoidCallback? onPressed;

    if (state is BluetoothScanning) {
      return const SizedBox.shrink();
    } else if (state is BluetoothConnected) {
      text = "Continue";
      onPressed = () {
        context.pushNamedAndRemoveAll(Routes.home);
      };
    } else if (state is BluetoothError) {
      text = "Retry";
      onPressed = () {
        cubit.startScan();
      };
    } else {
      text = "Scan Again";
      onPressed = () {
        cubit.startScan();
      };
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: CustomButton(text: text, onPressed: onPressed),
    );
  }

  Widget _buildBluetoothOffBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFc9d5ea),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.bluetooth,
              color: const Color(0xFF194b96),
              size: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please enable Bluetooth to connect your Aura Watch.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff212121),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                if (Platform.isAndroid) {
                  await FlutterBluePlus.turnOn();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please turn on Bluetooth from settings"),
                      backgroundColor: Color(0xffD32F2F),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Could not turn on Bluetooth"),
                    backgroundColor: Color(0xffD32F2F),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff194B96),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: const Size(0, 36),
            ),
            child: const Text(
              "Enable",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScanningDots extends StatefulWidget {
  const ScanningDots({super.key});

  @override
  State<ScanningDots> createState() => _ScanningDotsState();
}

class _ScanningDotsState extends State<ScanningDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.3,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 1000), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return FadeTransition(
          opacity: _animations[index],
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            width: context.screenWidth * .1,
            height: context.screenHeight * .1,
            decoration: const BoxDecoration(
              color: Color(0xff3976d1),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Rename Device",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Give your device a friendly name to identify it easily.",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Enter new name",
              filled: true,
              fillColor: const Color(0xffF5F8FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff194B96),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            if (nameController.text.isNotEmpty) {
              cubit.saveDeviceNickname(deviceId, nameController.text);
              Navigator.pop(context);
            }
          },
          child: const Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
