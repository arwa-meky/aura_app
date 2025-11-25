import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/fratuers/login/logic/reset_password_cubit.dart';
import 'package:aura_project/fratuers/login/logic/reset_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aura_project/core/widgets/custom_auth_title_desc.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/core/widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Set New Password")),
        body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Password changed successfully! Login now."),
                  backgroundColor: Colors.green,
                ),
              );
              context.pushNamedAndRemoveAll(Routes.login);
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

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.screenWidth * 0.04,
              ),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  children: [
                    SizedBox(height: context.usableHeight * 0.05),

                    const CustomAuthTitleDesc(
                      title: "Create New Password",
                      description:
                          "Enter the token you received in your email, verify your email, and set a new password.",
                    ),

                    SizedBox(height: context.usableHeight * 0.03),

                    CustomTextField(
                      controller: cubit.tokenController,
                      hintText: "Token (from email)",
                      validator: ResetPasswordCubit.tokenValidator,
                    ),

                    SizedBox(height: context.usableHeight * 0.02),

                    CustomTextField(
                      controller: cubit.emailController,
                      hintText: "Confirm your Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: ResetPasswordCubit.emailValidator,
                    ),

                    SizedBox(height: context.usableHeight * 0.02),

                    CustomTextField(
                      controller: cubit.passwordController,
                      hintText: "New Password",
                      obscureText: isPasswordObscure,
                      validator: ResetPasswordCubit.passwordValidator,
                      suffixIcon: isPasswordObscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onSuffixIcon: () {
                        setState(() {
                          isPasswordObscure = !isPasswordObscure;
                        });
                      },
                    ),

                    SizedBox(height: context.usableHeight * 0.02),

                    CustomTextField(
                      controller: cubit.confirmPasswordController,
                      hintText: "Confirm New Password",
                      obscureText: isConfirmPasswordObscure,
                      validator: (value) {
                        if (value != cubit.passwordController.text)
                          return "Passwords do not match";
                        return null;
                      },
                      suffixIcon: isConfirmPasswordObscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onSuffixIcon: () {
                        setState(() {
                          isConfirmPasswordObscure = !isConfirmPasswordObscure;
                        });
                      },
                    ),

                    SizedBox(height: context.usableHeight * 0.05),

                    (state is ResetPasswordLoading)
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            text: "Reset Password",
                            onPressed: cubit.resetPassword,
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
