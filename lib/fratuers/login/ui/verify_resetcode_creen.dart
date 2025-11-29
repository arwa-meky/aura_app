import 'dart:async';
import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/style/colors.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/core/widgets/custom_text_field.dart';
import 'package:aura_project/fratuers/login/logic/forget_password_cubit.dart';
import 'package:aura_project/fratuers/login/logic/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyResetCodeScreen extends StatefulWidget {
  const VerifyResetCodeScreen({super.key});

  @override
  State<VerifyResetCodeScreen> createState() => _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState extends State<VerifyResetCodeScreen> {
  final TextEditingController codeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Timer? _timer;
  int _start = 30;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String email =
        ModalRoute.of(context)?.settings.arguments as String? ?? "";

    return BlocProvider(
      create: (context) {
        final cubit = ForgotPasswordCubit();
        cubit.emailController.text = email;
        return cubit;
      },
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Code resent successfully!"),
                backgroundColor: Colors.green,
              ),
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
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.05,
                ),
                child: Form(
                  key: formKey,
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
                      const Text(
                        "Verification Code",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text100Color,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "We sent a 6-digit code to your email.\nPlease enter it below to continue.",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textBodyColor,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: context.usableHeight * 0.05),

                      CustomTextField(
                        controller: codeController,
                        hintText: "Enter 6-digit Code",
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the code";
                          }
                          if (value.length < 6) return "Code must be 6 digits";
                          return null;
                        },
                        backgroundColor: const Color(0xffFDFDFF),
                        hasBorder: true,
                      ),

                      SizedBox(height: context.usableHeight * 0.03),

                      Center(
                        child: Text(
                          "00:${_start.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            color: AppColors.textBodyColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: context.usableHeight * 0.04),

                      CustomButton(
                        text: "Verify",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.pushNamed(
                              Routes.newPassword,
                              arguments: {
                                'email': email,
                                'code': codeController.text,
                              },
                            );
                          }
                        },
                      ),

                      SizedBox(height: context.usableHeight * 0.02),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Didn't receive the code? ",
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          GestureDetector(
                            onTap: _start == 0
                                ? () {
                                    setState(() {
                                      _start = 30;
                                      startTimer();
                                    });
                                    context
                                        .read<ForgotPasswordCubit>()
                                        .resendCode();
                                  }
                                : null,
                            child: (state is ForgotPasswordLoading)
                                ? const SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Resend Code",
                                    style: TextStyle(
                                      color: _start == 0
                                          ? AppColors.primaryColor
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                        ],
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
