import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FD),
      appBar: AppBar(
        title: const Text(
          "Privacy and Policy",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,

                  height: 1.3,
                ),
                children: [
                  TextSpan(text: "Your privacy is important to us at "),
                  TextSpan(
                    text: "AURA",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text:
                        ".\n\nWe are committed to protecting your personal and health information and using it responsibly.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            _buildSectionHeader("AURA may collect the following information:"),
            const SizedBox(height: 10),
            _buildBulletPoint("Personal details (such as name and email)"),
            _buildBulletPoint(
              "Health data (heart rate, blood oxygen, steps, activity status)",
            ),
            _buildBulletPoint(
              "Device information (watch status, battery, connection data)",
            ),
            _buildBulletPoint(
              "Location data (only when required for emergency features)",
            ),
            const SizedBox(height: 10),

            _buildSectionHeader("We use your data to:"),
            const SizedBox(height: 10),
            _buildBulletPoint("Provide health tracking and insights"),
            _buildBulletPoint("Improve app performance and user experience"),
            _buildBulletPoint("Enable emergency and safety features"),
            _buildBulletPoint("Sync data between your smartwatch and the app"),
            const SizedBox(height: 15),

            const Text(
              "We take reasonable measures to protect your data and keep it secure. Your information is not shared with third parties without your consent, except when required for emergency situations.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 25),

            _buildSectionHeader(
              "You are always in control of your data.You can:",
            ),
            const SizedBox(height: 10),
            _buildBulletPoint("View your health information inside the app"),
            _buildBulletPoint("Disconnect your device at any time"),
            _buildBulletPoint("Request data deletion by contacting support"),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    if (text.contains("AURA")) {
      return RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
          children: [
            const TextSpan(
              text: "AURA ",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            TextSpan(text: text.replaceAll("AURA ", "")),
          ],
        ),
      );
    }
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.2),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
