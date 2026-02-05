import 'dart:async';
import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/style/colors.dart';
import 'package:aura_project/fratuers/login/logic/forget_password_cubit.dart';
import 'package:aura_project/fratuers/login/logic/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

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

  bool isCodeCompleted = false;

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

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xffE0E0E0)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      color: Colors.white,
      border: Border.all(color: Color(0xff2979FF), width: 2),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      color: Colors.white,
      border: Border.all(color: Color(0xff080808)),
    );
    final successPinTheme = defaultPinTheme
        .copyDecorationWith(
          border: Border.all(color: const Color(0xFF27AE60), width: 1.5),
        )
        .copyWith(
          textStyle: const TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        );

    final errorPinTheme = defaultPinTheme
        .copyDecorationWith(
          border: Border.all(color: const Color(0xFFE53935), width: 1.5),
        )
        .copyWith(
          textStyle: const TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        );
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
          } else if (state is VerifyCodeSuccess) {
            Future.delayed(const Duration(milliseconds: 800), () {
              if (context.mounted) {
                context.pushNamed(
                  Routes.newPassword,
                  arguments: {'email': email, 'code': codeController.text},
                );
              }
            });
          }
        },
        builder: (context, state) {
          final cubit = context.read<ForgotPasswordCubit>();

          return Scaffold(
            backgroundColor: const Color(0xffF5F8FF),

            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.06,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      SizedBox(height: context.usableHeight * 0.04),

                      const Text(
                        "Verification Code",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "We sent a 6-digit code to your email.\nPlease enter it below to continue.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),

                      SizedBox(height: context.usableHeight * 0.04),

                      Center(
                        child: Pinput(
                          length: 6,
                          controller: codeController,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: state is VerifyCodeFailure
                              ? errorPinTheme
                              : focusedPinTheme,
                          submittedPinTheme: state is VerifyCodeSuccess
                              ? successPinTheme
                              : submittedPinTheme,

                          forceErrorState: state is VerifyCodeFailure,
                          errorPinTheme: errorPinTheme,

                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          showCursor: true,

                          onChanged: (value) {
                            setState(() {
                              isCodeCompleted = value.length == 6;
                              if (state is VerifyCodeFailure) {
                                cubit.resetState();
                              }
                            });
                          },
                          onCompleted: (pin) {
                            setState(() {
                              isCodeCompleted = true;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 15),

                      if (state is VerifyCodeFailure)
                        Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Color(0xFFEA5455),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Incorrect Code, Please try again",
                              style: TextStyle(
                                color: Color(0xFFEA5455),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                      if (state is VerifyCodeSuccess)
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFF28C76F),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Accepted",
                              style: TextStyle(
                                color: Color(0xFF28C76F),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: context.usableHeight * 0.03),

                      Center(
                        child: Text(
                          "00:${_start.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      SizedBox(height: context.usableHeight * 0.03),

                      state is VerifyCodeLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )
                          : SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: isCodeCompleted
                                    ? () {
                                        cubit.verifyResetOtp(
                                          code: codeController.text,
                                          email: email,
                                        );
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff194B96),
                                  disabledBackgroundColor: Color(0xffC1C5C9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  "Verify",
                                  style: TextStyle(
                                    color: Colors.white,

                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                      SizedBox(height: context.usableHeight * 0.02),

                      // زرار إعادة الإرسال
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive the code? ",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: _start == 0
                                ? () {
                                    setState(() {
                                      _start = 30;
                                      startTimer();
                                      codeController.clear();
                                      isCodeCompleted = false;
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
                                      fontSize: 14,
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
