import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/style/colors.dart';
import 'package:aura_project/core/widgets/custom_soical_button.dart';
import 'package:aura_project/fratuers/login/logic/login_cubit.dart';
import 'package:aura_project/fratuers/login/logic/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/core/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isRememberMeChecked = false;
  bool _isPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.pushNamed(
              Routes.validateOtp,
              arguments: {
                'email': context.read<LoginCubit>().emailController.text,
                'isSignup': false,
              },
            );
          } else if (state is LoginGoogleSuccess) {
            context.pushNamedAndRemoveAll(Routes.home);
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is LoginGoogleFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<LoginCubit>();

          return Scaffold(
            backgroundColor: Color(0xffF5F8FF),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.04,
                      vertical: context.usableHeight * 0.01,
                    ),
                    child: Row(
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
                  ),

                  SizedBox(height: context.usableHeight * 0.02),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xffF5F8FF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.06,
                          vertical: context.usableHeight * 0.04,
                        ),
                        child: Form(
                          key: cubit.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome Back",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text100Color,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Monitor your health anytime, anywhere.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textBodyColor,
                                ),
                              ),
                              SizedBox(height: 30),
                              Row(
                                children: [
                                  const Icon(Icons.email_outlined),
                                  SizedBox(width: 2),
                                  const Text(
                                    "Email Address",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              CustomTextField(
                                controller: cubit.emailController,
                                hintText: "Enter Your Email",

                                keyboardType: TextInputType.emailAddress,
                                validator: LoginCubit.emailValidator,

                                backgroundColor: const Color(0xffEEEEEE),
                                hasBorder: true,
                              ),

                              SizedBox(height: 20),

                              Row(
                                children: [
                                  const Icon(Icons.lock_outline),
                                  SizedBox(width: 2),
                                  const Text(
                                    "Password",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: context.usableHeight * 0.01),
                              CustomTextField(
                                controller: cubit.passwordController,
                                hintText: "Enter Your Password",

                                obscureText: _isPasswordObscure,
                                validator: LoginCubit.passwordValidator,

                                backgroundColor: const Color(0xffEEEEEE),
                                hasBorder: true,

                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordObscure
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.textBodyColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordObscure = !_isPasswordObscure;
                                    });
                                  },
                                ),
                              ),

                              SizedBox(height: 10),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _isRememberMeChecked,
                                        activeColor: AppColors.primaryColor,
                                        onChanged: (v) => setState(
                                          () => _isRememberMeChecked = v!,
                                        ),
                                      ),
                                      const Text("Remember Me"),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () => context.pushNamed(
                                      Routes.forgetPassword,
                                    ),
                                    child: const Text(
                                      "Forget Your Password?",
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20),

                              (state is LoginLoading)
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : CustomButton(
                                      text: "Login",
                                      onPressed: cubit.loginWithEmail,
                                    ),

                              SizedBox(height: 20),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don’t have an account? "),
                                  GestureDetector(
                                    onTap: () =>
                                        context.pushNamed(Routes.register),
                                    child: const Text(
                                      "Create Account",
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20),
                              const Row(
                                children: [
                                  Expanded(child: Divider()),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text("Or"),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                              SizedBox(height: 20),

                              (state is LoginGoogleLoading)
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : BuildSocialButton(
                                      text: "Continue with Google",
                                      iconPath: 'assets/images/google.png',
                                      onPressed: cubit.loginWithGoogle,
                                    ),
                              SizedBox(height: 15),
                              BuildSocialButton(
                                text: "Continue with Facebook",
                                iconPath: 'assets/images/facebook.png',
                                onPressed: () {},
                              ),
                              SizedBox(height: 15),
                              BuildSocialButton(
                                text: "Continue with Apple",
                                iconPath: 'assets/images/apple.png',
                                onPressed: () {},
                              ),
                              SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
