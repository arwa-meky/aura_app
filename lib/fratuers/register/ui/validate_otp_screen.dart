import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/fratuers/register/logic/validate_otp_cubit.dart';
import 'package:aura_project/fratuers/register/logic/validate_otp_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura_project/core/widgets/custom_auth_title_desc.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/core/widgets/custom_text_field.dart';

class ValidateOtpScreen extends StatelessWidget {
  final String email;
  const ValidateOtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ValidateOtpCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Verify Account")),
        body: BlocConsumer<ValidateOtpCubit, ValidateOtpState>(
          listener: (context, state) {
            if (state is ValidateOtpSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Login Successful!"),
                  backgroundColor: Colors.green,
                ),
              );
              context.pushNamedAndRemoveAll(Routes.home);
            } else if (state is ValidateOtpNavigateToCompleteProfile) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please complete your profile"),
                  backgroundColor: Colors.blue,
                ),
              );
              context.pushNamedAndRemoveAll(Routes.completeProfile);
            } else if (state is ValidateOtpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<ValidateOtpCubit>();

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.screenWidth * 0.04,
              ),
              child: Column(
                children: [
                  SizedBox(height: context.usableHeight * 0.05),

                  const CustomAuthTitleDesc(
                    title: "Check Your Email",
                    description:
                        "We've sent an OTP code to your email. Please enter it below to verify your account.",
                  ),

                  SizedBox(height: context.usableHeight * 0.05),

                  CustomTextField(
                    controller: cubit.otpController,
                    hintText: "Enter 6-digit Code",
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: context.usableHeight * 0.05),

                  (state is ValidateOtpLoading)
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          text: "Verify",
                          onPressed: () {
                            cubit.verifyOtp(email: email);
                          },
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
