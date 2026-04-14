import 'package:aura_project/core/helpers/extension.dart';
import 'package:flutter/material.dart';

void showTroubleShootingSheet(BuildContext context) {
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
            _buildTipItem(Icons.bluetooth, "Turn on Bluetooth on your phone."),
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
