import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/fratuers/profile/logic/profile_state.dart';
import 'package:aura_project/fratuers/profile/ui/universal_settings/about_aura_screen.dart';
import 'package:aura_project/fratuers/profile/ui/universal_settings/contact_us_screen.dart';
import 'package:aura_project/fratuers/profile/ui/universal_settings/faq_screen.dart';
import 'package:aura_project/fratuers/profile/ui/universal_settings/help_center_screen.dart';
import 'package:aura_project/fratuers/profile/ui/universal_settings/logout_screen.dart';
import 'package:aura_project/fratuers/profile/ui/universal_settings/notification_screen.dart';
import 'package:aura_project/fratuers/profile/ui/universal_settings/privacy_policy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura_project/fratuers/profile/logic/profile_cubit.dart';

class UniversalSettingsScreen extends StatelessWidget {
  const UniversalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLogOutSuccess) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(Routes.welcome, (route) => false);
        } else if (state is ProfileLogOutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.amber,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(Routes.welcome, (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF8F9FD),
        appBar: AppBar(
          title: const Text(
            "Universal Settings",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 22,
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildSettingItem(
                image: 'assets/images/settings/info.png',
                color: const Color(0xff1A56DB),
                title: "About AURA",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutAuraScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),

              _buildSettingItem(
                image: 'assets/images/settings/notif.png',
                color: const Color(0xff1A56DB),
                title: "Notification",
                onTap: () {
                  final cubit = ProfileCubit.get(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: cubit,
                        child: const NotificationScreen(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),

              _buildSettingItem(
                image: 'assets/images/settings/lock.png',
                color: const Color(0xff1A56DB),
                title: "Privacy Policy",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),

              _buildSettingItem(
                image: 'assets/images/settings/ques.png',
                color: const Color(0xff1A56DB),
                title: "Help Center",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpCenterScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),

              _buildSettingItem(
                image: 'assets/images/settings/faq.png',
                color: const Color(0xff1A56DB),
                title: "FAQ",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FaqScreen()),
                  );
                },
              ),
              const SizedBox(height: 15),

              _buildSettingItem(
                image: 'assets/images/settings/mic.png',
                color: const Color(0xff1A56DB),
                title: "Contact us",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactUsScreen()),
                  );
                },
              ),
              const SizedBox(height: 15),

              _buildSettingItem(
                image: 'assets/images/settings/logout.png',
                color: Color(0xffE53935),
                title: "Log Out",
                isLogOut: true,
                onTap: () {
                  showLogoutDialog(context, cubit);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String image,
    required Color color,
    required String title,
    required VoidCallback onTap,
    bool isLogOut = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xffE0E0E0)),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(image, scale: 2),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
