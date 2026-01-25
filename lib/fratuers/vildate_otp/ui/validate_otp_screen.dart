import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/fratuers/vildate_otp/logic/validate_otp_cubit.dart';
import 'package:aura_project/fratuers/vildate_otp/logic/validate_otp_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura_project/core/widgets/custom_auth_title_desc.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/core/widgets/custom_text_field.dart';

class ValidateOtpScreen extends StatelessWidget {
  const ValidateOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String email = args['email'];
    final bool isSignup = args['isSignup'];
    return BlocProvider(
      create: (context) => ValidateOtpCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xffF5F8FF),
        body: BlocConsumer<ValidateOtpCubit, ValidateOtpState>(
          listener: (context, state) {
            if (state is ValidateOtpSuccess) {
              context.pushNamedAndRemoveAll(Routes.home);
            } else if (state is ValidateOtpNavigateToCompleteProfile) {
              context.pushNamedAndRemoveAll(Routes.completeProfile);
            } else if (state is ValidateOtpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
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
            final cubit = context.read<ValidateOtpCubit>();

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.screenWidth * 0.04,
              ),
              child: Column(
                children: [
                  SizedBox(height: context.usableHeight * 0.05),
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
                    hasBorder: true,
                    backgroundColor: const Color(0xffEEEEEE),
                  ),

                  SizedBox(height: context.usableHeight * 0.05),

                  (state is ValidateOtpLoading)
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          text: "Verify",
                          onPressed: () {
                            cubit.verifyOtp(email: email, isSignup: isSignup);
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
