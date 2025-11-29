import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/style/colors.dart';
import 'package:aura_project/core/widgets/custom_dialog.dart';
import 'package:aura_project/core/widgets/custom_input_label.dart';
import 'package:aura_project/fratuers/login/logic/reset_password_cubit.dart';
import 'package:aura_project/fratuers/login/logic/reset_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/core/widgets/custom_text_field.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool isPasswordObscure = true;
  bool isConfirmObscure = true;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String email = args['email'];
    final String code = args['code'];

    return BlocProvider(
      create: (context) {
        final cubit = ResetPasswordCubit();
        cubit.email = email;
        cubit.token = code;
        return cubit;
      },
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            SuccessDialog.show(
              context,
              title: "Password Reset Successful",
              description:
                  "Your password has been successfully changed. Please use your new login details to continue.",
              buttonText: "Back to Login",
              onPressed: () {
                Navigator.of(context).pop();

                context.pushNamedAndRemoveAll(Routes.login);
              },
            );
          } else if (state is ResetPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ResetPasswordCubit>();

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.05,
                ),
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.usableHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),

                          Image.asset(
                            'assets/images/logo_name.png',
                            width: context.screenWidth * 0.25,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),

                      SizedBox(height: context.usableHeight * 0.06),

                      Text(
                        "Reset Your Password",
                        style: TextStyle(
                          fontSize: context.getResponsiveFontSize(
                            24,
                            minSize: 20,
                            maxSize: 28,
                          ),
                          fontWeight: FontWeight.bold,
                          color: AppColors.text100Color,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Create a new password for your Aura account. Please choose a strong and secure password.",
                        style: TextStyle(
                          fontSize: context.getResponsiveFontSize(
                            14,
                            minSize: 12,
                            maxSize: 16,
                          ),
                          color: AppColors.textBodyColor,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: context.usableHeight * 0.04),

                      BuildInputLabel(
                        text: "New Password",
                        icon: Icons.lock_outline,
                      ),
                      CustomTextField(
                        controller: cubit.passwordController,
                        hintText: "Enter new password",
                        obscureText: isPasswordObscure,
                        validator: ResetPasswordCubit.passwordValidator,
                        backgroundColor: const Color(0xffFDFDFF),
                        hasBorder: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordObscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(
                            () => isPasswordObscure = !isPasswordObscure,
                          ),
                        ),
                      ),

                      SizedBox(height: context.usableHeight * 0.02),

                      BuildInputLabel(
                        text: "Confirm Password",
                        icon: Icons.lock_outline,
                      ),
                      CustomTextField(
                        controller: cubit.confirmPasswordController,
                        hintText: "Confirm your new password",
                        obscureText: isConfirmObscure,
                        backgroundColor: const Color(0xffFDFDFF),
                        hasBorder: true,
                        validator: (val) {
                          if (val != cubit.passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            isConfirmObscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(
                            () => isConfirmObscure = !isConfirmObscure,
                          ),
                        ),
                      ),

                      SizedBox(height: context.usableHeight * 0.05),

                      (state is ResetPasswordLoading)
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              text: "Update Password",
                              onPressed: () {
                                cubit.resetPassword();
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
