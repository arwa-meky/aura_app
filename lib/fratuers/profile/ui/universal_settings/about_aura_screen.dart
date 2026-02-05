import 'package:flutter/material.dart';

class AboutAuraScreen extends StatelessWidget {
  const AboutAuraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FD),
      appBar: AppBar(
        title: const Text(
          "About AURA",
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
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text:
                        "AURA is a smart health monitoring app designed to help you track your daily health using your smartwatch.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "With AURA, you can:",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),

            _buildBulletPoint(
              "Monitor your heart rate and blood oxygen (SpO₂).",
            ),
            _buildBulletPoint(
              "Track your daily activity, steps, and movement.",
            ),
            _buildBulletPoint(
              "Detect falls and send SOS alerts in emergency situations.",
            ),
            _buildBulletPoint(
              "View your health trends and progress over time.",
            ),
            _buildBulletPoint(
              "Stay connected to your health anytime, anywhere.",
            ),

            const SizedBox(height: 25),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text:
                        "AURA focuses on simplicity, safety, and real-time insights to help you take better care of your health.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 12),
            height: 4,
            width: 4,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
