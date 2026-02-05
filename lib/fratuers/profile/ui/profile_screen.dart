import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/fratuers/profile/logic/profile_cubit.dart';
import 'package:aura_project/fratuers/profile/logic/profile_state.dart';
import 'package:aura_project/fratuers/profile/ui/universal_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }
      },

      builder: (context, state) {
        var cubit = ProfileCubit.get(context);
        var user = cubit.currentUser;

        return Scaffold(
          backgroundColor: const Color(0xffF5F8FF),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Profile",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ),
          body: user == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: cubit.profileImage != null
                                  ? FileImage(cubit.profileImage!)
                                        as ImageProvider
                                  : (user.photoUrl != null)
                                  ? NetworkImage(user.photoUrl!)
                                        as ImageProvider
                                  : null,
                              child:
                                  (cubit.profileImage == null &&
                                      user.photoUrl == null)
                                  ? const Icon(Icons.person, size: 50)
                                  : null,
                            ),

                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    user.email ?? "",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff616161),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Personal Data",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xff1A56DB,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 18,
                                    color: Color(0xff1A56DB),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Personal Information",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            _buildLabel("Full Name"),
                            _buildReadOnlyField(user.fullName ?? ''),
                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel("Gender"),
                                      _buildReadOnlyField(user.gender ?? ""),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel("Your Age"),
                                      _buildReadOnlyField(
                                        "${user.age ?? ''} years",
                                        isHighlighted: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            _buildLabel("Mobile Phone"),
                            _buildReadOnlyField(user.phoneNumber ?? ""),
                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel("Height (cm)"),
                                      _buildReadOnlyField(user.height ?? ""),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel("Weight (kg)"),
                                      _buildReadOnlyField(user.weight ?? ""),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "Security",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildSettingsTile(
                        icon: Icons.vpn_key,
                        title: "Change Password",
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.changePassword,
                            arguments: ProfileCubit.get(context),
                          );
                        },
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "Account & App Settings",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildSettingsTile(
                        icon: Icons.person,
                        title: "Edit Profile",
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.editProfile,
                            arguments: ProfileCubit.get(context),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildSettingsTile(
                        icon: Icons.settings,
                        title: "Universal Settings",
                        onTap: () {
                          final cubit = ProfileCubit.get(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: cubit,
                                child: const UniversalSettingsScreen(),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 15),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String text, {bool isHighlighted = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xffF0F0F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: isHighlighted
          ? Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: text.split(" ")[0],
                      style: const TextStyle(
                        color: Color(0xff194B96),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'SofiaPro',
                      ),
                    ),
                    TextSpan(
                      text:
                          " ${text.split(" ").length > 1 ? text.split(" ")[1] : ""}",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xff194B96).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xff194B96), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}
