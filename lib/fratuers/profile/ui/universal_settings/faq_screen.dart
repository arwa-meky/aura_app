import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FD),
      appBar: AppBar(
        title: const Text(
          "FAQ",
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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildFaqItem(
            question: "How do I connect my smartwatch to AURA?",
            answer:
                "Make sure Bluetooth is enabled on your phone, keep the watch nearby, and follow the connection steps in the Device page.",
            isExpanded: true,
          ),
          const SizedBox(height: 15),
          _buildFaqItem(
            question: "What should I do if my watch is disconnected?",
            answer:
                "Try using the Reconnect Device button. If the problem continues, open Troubleshoot connection for step-by-step guidance.",
          ),
          const SizedBox(height: 15),
          _buildFaqItem(
            question: "How can I reset my password?",
            answer:
                "Go to Profile > Security and choose Change Password. If you forgot it, use the 'Forgot Password' option at the login screen.",
          ),
          const SizedBox(height: 15),
          _buildFaqItem(
            question: "Is my health data shared with anyone?",
            answer:
                "No, your data is private. It is only shared with emergency contacts if you enable the SOS feature during an emergency.",
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
    bool isExpanded = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          title: Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xff212121),
            ),
          ),
          childrenPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          expandedAlignment: Alignment.centerLeft,
          collapsedIconColor: Colors.black,
          children: [
            Divider(color: Color(0xffACACAC), thickness: 1),
            Text(
              answer,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff616161),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
