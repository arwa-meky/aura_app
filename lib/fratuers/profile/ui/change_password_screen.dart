import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/widgets/custom_dialog.dart';
import 'package:aura_project/fratuers/profile/logic/profile_cubit.dart';
import 'package:aura_project/fratuers/profile/logic/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    void checkValidation() {
      setState(() {
        isButtonEnabled =
            cubit.currentPassController.text.isNotEmpty &&
            cubit.newPassController.text.isNotEmpty &&
            cubit.confirmPassController.text.isNotEmpty &&
            cubit.newPassController.text.length >= 8;
      });
    }

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is PasswordUpdateSuccess) {
          SuccessDialog.show(
            context,
            title: 'Password Reset Successful',
            description: 'Your password has been successfully changed',
            buttonText: 'Submit',
            onPressed: () {
              Navigator.pop(context);

              context.pushNamedAndRemoveAll(Routes.welcome);
            },
          );
        } else if (state is PasswordUpdateError) {
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
        return Scaffold(
          backgroundColor: const Color(0xffF8F9FD),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Change Password",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Create a new password for your Aura account. Please choose a strong and secure password.",
                  style: TextStyle(
                    color: Color(0xff616161),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPasswordField(
                        label: "Current Password",
                        hint: "Enter your current password",
                        controller: cubit.currentPassController,
                        isObscured: _obscureCurrent,
                        onChanged: (val) => checkValidation(),
                        onToggleVisibility: () =>
                            setState(() => _obscureCurrent = !_obscureCurrent),
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(
                        label: "New Password",
                        hint: "Enter your new password",
                        controller: cubit.newPassController,
                        isObscured: _obscureNew,
                        onChanged: (val) => checkValidation(),
                        onToggleVisibility: () =>
                            setState(() => _obscureNew = !_obscureNew),
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(
                        label: "Confirm Password",
                        hint: "Confirm your new password",
                        controller: cubit.confirmPassController,
                        isObscured: _obscureConfirm,
                        onChanged: (val) => checkValidation(),
                        onToggleVisibility: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      const SizedBox(height: 25),
                      _buildRequirementRow("At least 8 characters"),
                      _buildRequirementRow("1 uppercase letter"),
                      _buildRequirementRow("1 number"),
                      _buildRequirementRow("1 special character"),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            cubit.changePassword();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isButtonEnabled
                          ? const Color(0xff194B96)
                          : Color(0xffC1C5C9),
                      disabledBackgroundColor: Color(0xffC1C5C9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: (state is PasswordUpdateLoading)
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Update Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isObscured,
    required VoidCallback onToggleVisibility,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            obscureText: isObscured,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Color(0xff616161), fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isObscured
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Color(0xffACACAC),
                  size: 20,
                ),
                onPressed: onToggleVisibility,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xff616161),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xff212121),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
