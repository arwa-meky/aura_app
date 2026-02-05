import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FD),
      appBar: AppBar(
        title: const Text(
          "Help Center",
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
            const Text(
              "We're here to help you get the best experience with AURA.",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff616161),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "If you have any questions, issues, or need support with:",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff616161),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),

            _buildBulletPoint("Connecting your smartwatch"),
            _buildBulletPoint("Health data and tracking"),
            _buildBulletPoint("Emergency features"),
            _buildBulletPoint("Account or app settings"),
            const SizedBox(height: 25),

            const Text(
              "Please contact our support team anytime at:",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xff616161),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                _launchEmail();
              },
              child: const Text(
                "aura.smart.watch@gmail.com",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff194B96),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xff194B96),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "We aim to respond as quickly as possible to assist you.",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff616161),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 40),

            Center(
              child: Image.asset(
                'assets/images/settings/help.png',
                scale: 1.6,
                color: Color(0xff194B96).withOpacity(.3),
              ),
            ),
          ],
        ),
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
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'aura.smart.watch@gmail.com',
      query: 'subject=Support Request&body=Hello AURA Support,',
    );
    launchUrl(emailLaunchUri);
  }
}
