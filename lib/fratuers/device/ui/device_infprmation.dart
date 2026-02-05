import 'package:flutter/material.dart';

class DeviceInfprmationScreen extends StatelessWidget {
  const DeviceInfprmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Device Information',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Device Information',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildInfoTile('Device ID', 'AURA-Health-Monitor-2E0C2E6'),
            _buildInfoTile('Firmware Version', 'v2.2.1.4'),
            _buildInfoTile('Last Update', 'Feb 10, 2026'),
            _buildInfoTile('Model Number', 'AURA-GEN1-2026'),
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoTile(String title, String value) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xffEEEEEE),
      borderRadius: BorderRadius.circular(12),
      border: BoxBorder.all(color: Color(0xffE0E0E0)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Color(0xff333333),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, color: Color(0xff616161)),
        ),
      ],
    ),
  );
}
