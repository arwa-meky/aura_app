import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/style/colors.dart';
import 'package:aura_project/fratuers/login/logic/forget_password_cubit.dart';
import 'package:aura_project/fratuers/login/logic/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/core/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "password reset url sent successfully , Please check your email.",
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );

            context.pushNamed(
              Routes.verifyResetCode,
              arguments: context
                  .read<ForgotPasswordCubit>()
                  .emailController
                  .text,
            );
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
                        "Forget Your Password",
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
                      SizedBox(height: context.usableHeight * 0.015),
                      Text(
                        "Please enter your email address to reset your password.",
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

                      SizedBox(height: context.usableHeight * 0.05),

                      Row(
                        children: [
                          const Icon(
                            Icons.mail_outline,
                            size: 18,
                            color: AppColors.text100Color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Email Address",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: context.getResponsiveFontSize(
                                14,
                                minSize: 12,
                                maxSize: 16,
                              ),
                              color: AppColors.text100Color,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.usableHeight * 0.01),

                      CustomTextField(
                        controller: cubit.emailController,
                        hintText: "Enter Your Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: ForgotPasswordCubit.emailValidator,
                      ),

                      SizedBox(height: context.usableHeight * 0.05),

                      (state is ForgotPasswordLoading)
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              text: "Reset Password",
                              onPressed: cubit.sendResetLink,
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
