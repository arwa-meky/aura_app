import 'dart:async';
import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/helpers/storage/local_storage.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/services/notification_service.dart';
import 'package:aura_project/core/widgets/troubleshooting_sheet.dart';
import 'package:aura_project/fratuers/bluetooth/logic/bluetooth_cubit.dart';
import 'package:aura_project/fratuers/bluetooth/logic/bluetooth_state.dart';
import 'package:aura_project/fratuers/profile/logic/profile_cubit.dart';
import 'package:aura_project/fratuers/profile/logic/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getUserData();
    final savedDeviceId = LocalStorage.getDeviceId;
    if (savedDeviceId != null) {
      context.read<BluetoothCubit>().getDeviceStreak(savedDeviceId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<BluetoothCubit>();
    final state = cubit.state;

    String lastSyncTime = LocalStorage.getLastSyncTime() ?? "Unknown";
    String timeAgo = _getTimeAgo(lastSyncTime);

    // التحقق من حالة الاتصال
    bool isConnected =
        cubit.isDeviceConnected ||
        state is BluetoothConnected ||
        state is BluetoothDataReceived;

    final lastData = cubit.lastReadings;

    int hr = isConnected ? (lastData?.heartRate ?? 0) : 0;
    int spo2 = isConnected ? (lastData?.oxygen ?? 0) : 0;
    int speed = isConnected ? (lastData?.speed ?? 0) : 0;
    Object steps = isConnected
        ? (lastData?.steps ?? 0)
        : (cubit.getLastSteps());
    int deviceStatus = isConnected ? (lastData?.position ?? 0) : 0;
    int batteryLevel = isConnected ? (lastData?.battery ?? 0) : 0;

    return Scaffold(
      backgroundColor: const Color(0xffF8F9FD),
      body: BlocListener<BluetoothCubit, BluetoothState>(
        listener: (context, state) {
          if (state is BluetoothEmergencyState) {
            _showEmergencyDialog(context, state.message);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(isConnected),
                const SizedBox(height: 20),
                _buildDeviceStatusCard(isConnected, batteryLevel, timeAgo),
                const SizedBox(height: 25),
                _buildSectionHeader(
                  'assets/images/home/overview.png',
                  "Todays Overview",
                  isConnected ? null : "Last recorded $timeAgo",
                ),
                const SizedBox(height: 15),
                if (!isConnected) _buildLiveDataUnavailableNote(),
                _buildVitalsGrid(isConnected, hr, spo2, speed, steps),
                const SizedBox(height: 20),
                _buildCurrentStatusCard(
                  isConnected,
                  deviceStatus,
                  _getTimeAgo(lastSyncTime),
                ),
                const SizedBox(height: 25),
                _buildSectionHeader(
                  'assets/images/home/location.png',
                  "Location",
                  isConnected ? null : "Updated ${_getTimeAgo(lastSyncTime)}",
                ),
                const SizedBox(height: 10),
                _buildLocationCard(
                  cubit.lastReadings?.lat,
                  cubit.lastReadings?.lon,
                  isConnected,
                ),
                const SizedBox(height: 20),
                _buildStreakCard(cubit.currentStreak, isConnected),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isConnected) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        var cubit = ProfileCubit.get(context);
        var user = cubit.currentUser;

        String? displayName =
            (user != null && user.fullName != null && user.fullName!.isNotEmpty)
            ? user.fullName!.trim().split(" ").first
            : "User";
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Good Morning,",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xff212121),
                      ),
                    ),
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xff212121),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isConnected
                      ? "All vitals look stable today."
                      : "Live data unavailable, watch not connected",
                  style: TextStyle(
                    color: Color(0xff616161),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            _buildNotificationIcon(),
          ],
        );
      },
    );
  }

  Widget _buildNotificationIcon() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xffE0E0E0), width: 1.5),
      ),
      child: Image.asset('assets/images/home/notif.png', scale: 1.8),
    );
  }

  Widget _buildDeviceStatusCard(
    bool isConnected,
    int battery,
    String syncInfo,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset('assets/images/home/watch_icon.png', scale: 1.6),
            SizedBox(width: 10),
            const Text(
              "Device Status",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xff212121),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(11.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xffE0E0E0)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 21,
                    backgroundColor: Color(0xffE0E0E0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: isConnected
                          ? const Color(0xffF5F8FF)
                          : const Color(0xffE9E9EA),
                      child: isConnected
                          ? Image.asset(
                              'assets/images/home/watch_active.png',
                              scale: 1.8,
                            )
                          : Image.asset(
                              'assets/images/home/watch_notActive.png',
                              scale: 1.8,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Watch Status:",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xff212121),
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (isConnected)
                          Row(
                            children: [
                              Text(
                                "Watch Battery",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xffACACAC),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                " $battery%",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xff616161),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        Text(
                          isConnected
                              ? "Last Sync: Just now"
                              : "Last connected: $syncInfo",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xff616161),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(isConnected),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: isConnected
                    ? OutlinedButton(
                        onPressed: () {
                          context.pushReplacmentNamed(Routes.device);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xff194B96)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Manage Device",
                          style: TextStyle(
                            color: Color(0xff194B96),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () =>
                                  context.pushNamed(Routes.bluetoothConnect),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff194B96),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                "Reconnect Device",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              if (!isConnected) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: OutlinedButton(
                    onPressed: () {
                      showTroubleShootingSheet(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xff194B96)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Troubleshoot Connection",
                      style: TextStyle(
                        color: Color(0xff194B96),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isConnected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 5,
            backgroundColor: isConnected
                ? Color(0xff27AE60)
                : Color(0xffE53935),
          ),
          const SizedBox(width: 4),
          Text(
            isConnected ? "Connected" : "Disconnected",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isConnected ? Color(0xff27AE60) : Color(0xffE53935),
            ),
          ),
        ],
      ),
    );
  }

  // --- Vitals Grid ---
  Widget _buildVitalsGrid(
    bool isConnected,
    int hr,
    int spo2,
    int speed,
    Object steps,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildVitalCard(
                isConnected
                    ? 'assets/images/watch_icon/blood.png'
                    : 'assets/images/home/heart_notActive.png',
                "Heart Rate",
                isConnected ? "$hr" : "--",
                "BPM",
                isConnected ? getHRStatus(hr) : null,
                isConnected,
                true,
                color: getHRColor(hr),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildVitalCard(
                isConnected
                    ? 'assets/images/watch_icon/blood.png'
                    : 'assets/images/home/boold_notActive.png',
                "Blood Oxygen",
                isConnected ? "$spo2" : "--",
                "%",
                isConnected ? getSpO2Status(spo2) : null,
                isConnected,
                true,
                color: getSpo2Color(spo2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildVitalCard(
                isConnected
                    ? 'assets/images/home/speed_active.png'
                    : 'assets/images/home/speed_notActive.png',
                "Speed",
                isConnected ? "$speed" : "--",
                "Km/h",
                null,
                isConnected,
                true,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Stack(
                children: [
                  _buildVitalCard(
                    isConnected
                        ? 'assets/images/home/steps_active.png'
                        : 'assets/images/home/steps_notActive.png',
                    "Steps",
                    "$steps",
                    "Steps",
                    null,
                    isConnected,
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String getHRStatus(int hr) {
    if (hr == 0) return "--";
    if (hr > 100) return "High";
    if (hr < 60) return "Low";
    return "Normal";
  }

  Color getHRColor(int hr) {
    if (hr > 100 || hr < 60) return Colors.red;
    if (hr == 0) return Colors.grey;
    return Colors.green;
  }

  String getSpO2Status(int spo2) {
    if (spo2 == 0) return "--";
    if (spo2 < 90) return "Critical";
    if (spo2 < 95) return "Low";
    return "Healthy";
  }

  Color getSpo2Color(int spo2) {
    if (spo2 < 95) return Colors.red;
    if (spo2 == 0) return Colors.grey;
    return Colors.green;
  }

  Widget _buildVitalCard(
    String image,
    String title,
    String value,
    String unit,
    String? status,
    bool isConnected,
    bool isLastRecorded, {
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isConnected ? Colors.white : const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xffE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(image, scale: 1.5),
              if (status != null && isConnected)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (!isLastRecorded && !isConnected)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xffACACAC)),
                  ),
                  child: Text(
                    'Last Record',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isConnected ? Color(0xff212121) : Color(0xff9E9E9E),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  color: isConnected ? Color(0xff212121) : Color(0xffACACAC),
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff616161),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStatusCard(bool isConnected, int status, syncinfo) {
    String statusText = isConnected ? _getPositionText(status) : "Unknown";
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isConnected ? Colors.white : const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xffE0E0E0)),
      ),
      child: Row(
        children: [
          isConnected
              ? Image.asset(
                  statusText == 'Sitting'
                      ? 'assets/images/home/siting_icon.png'
                      : 'assets/images/home/standing_icon.png',
                  scale: 1.3,
                )
              : Image.asset(
                  'assets/images/home/nonActive_icon.png',
                  scale: 1.3,
                ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Current Status",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isConnected ? Color(0xff212121) : Color(0xff9E9E9E),
                  ),
                ),
                const SizedBox(height: 2),
                isConnected
                    ? Row(
                        children: [
                          Text(
                            statusText,
                            style: TextStyle(
                              color: Color(0xff194B96),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Since $syncinfo",
                            style: TextStyle(
                              color: Color(0xff616161),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        "Connect your watch to detect activity.",
                        style: TextStyle(
                          color: Color(0xff616161),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPositionText(int position) {
    switch (position) {
      case 0:
        return "Sitting";
      case 1:
        return "Standing";
      default:
        return "Unknown";
    }
  }

  Widget _buildLocationCard(double? lat, double? lng, bool isConnected) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE0E0E0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: (isConnected && lat != null && lng != null)
            ? GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, lng),
                  zoom: 15,
                ),
                liteModeEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                markers: {
                  Marker(
                    markerId: const MarkerId('user_loc'),
                    position: LatLng(lat, lng),
                  ),
                },
              )
            : Stack(
                children: [
                  Image.asset(
                    "assets/images/map_placeholder.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Container(color: Colors.white.withOpacity(0.5)),
                  const Center(child: Text("Connect watch to see location")),
                ],
              ),
      ),
    );
  }

  Widget _buildStreakCard(int streak, bool isConnected) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xffE0E0E0)),
      ),
      child: Row(
        children: [
          isConnected
              ? Image.asset('assets/images/home/streak_active.png', scale: 1.5)
              : Image.asset(
                  'assets/images/home/streak_notActive.png',
                  scale: 1.5,
                ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$streak Days Streak",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isConnected ? Color(0xff212121) : Color(0xff9E9E9E),
                ),
              ),
              Text(
                isConnected
                    ? "You are building a healthy habit."
                    : "Streak paused, reconnect to keep it alive",
                style: const TextStyle(
                  color: Color(0xff616161),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String image, String title, String? subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(image, scale: 1.5),
            SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(0xff212121),
              ),
            ),
          ],
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xff616161),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    );
  }

  Widget _buildLiveDataUnavailableNote() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Center(
        child: Text(
          "Live data unavailable.",
          style: TextStyle(
            color: Color(0xff212121),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(String? timeString) {
    if (timeString == null || timeString == "Unknown") return "Never";
    try {
      DateTime lastSync = DateTime.parse(timeString);
      Duration diff = DateTime.now().difference(lastSync);
      if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
      if (diff.inHours < 24) return "${diff.inHours}h ago";
      return "${diff.inDays}d ago";
    } catch (e) {
      return "Unknown";
    }
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
