import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/fratuers/login/logic/forget_password_cubit.dart';
import 'package:aura_project/fratuers/login/logic/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura_project/core/widgets/custom_auth_title_desc.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/core/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Reset Password")),
        body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Password reset link sent! Check your email."),
                  backgroundColor: Colors.green,
                ),
              );
              context.pushReplacmentNamed(Routes.resetPassword);
            } else if (state is ForgotPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<ForgotPasswordCubit>();

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.04,
                ),
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    children: [
                      SizedBox(height: context.usableHeight * 0.05),

                      const CustomAuthTitleDesc(
                        title: "Forgot Password?",
                        description:
                            "Enter the email associated with your account and we'll send a reset link.",
                      ),

                      SizedBox(height: context.usableHeight * 0.03),

                      CustomTextField(
                        controller: cubit.emailController,
                        hintText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: ForgotPasswordCubit.emailValidator,
                      ),

                      SizedBox(height: context.usableHeight * 0.05),

                      (state is ForgotPasswordLoading)
                          ? const CircularProgressIndicator()
                          : CustomButton(
                              text: "Send Reset Link",
                              onPressed: cubit.sendResetLink,
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
