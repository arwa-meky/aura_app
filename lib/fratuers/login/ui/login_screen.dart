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
  bool _isPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit()..loadSavedCredentials(),
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
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          } else if (state is LoginGoogleFailure) {
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
          } else if (state is LoginFacebookSuccess) {
            context.pushNamedAndRemoveAll(Routes.home);
          } else if (state is LoginFacebookFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
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
          final cubit = context.read<LoginCubit>();

          return Scaffold(
            backgroundColor: const Color(0xffF5F8FF),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.04,
                        vertical: context.usableHeight * 0.01,
                      ),
                      child: Column(
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
                          SizedBox(height: context.usableHeight * 0.02),
                        ],
                      ),
                    ),
                  ),

                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xffF5F8FF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.06,
                          vertical: context.usableHeight * 0.04,
                        ),
                        child: Form(
                          key: cubit.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Welcome Back",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text100Color,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Monitor your health anytime, anywhere.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textBodyColor,
                                ),
                              ),
                              const SizedBox(height: 30),

                              const Row(
                                children: [
                                  Icon(Icons.email_outlined),
                                  SizedBox(width: 2),
                                  Text(
                                    "Email Address",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                controller: cubit.emailController,
                                hintText: "Enter Your Email",
                                keyboardType: TextInputType.emailAddress,
                                validator: LoginCubit.emailValidator,
                                backgroundColor: const Color(0xffEEEEEE),
                                hasBorder: true,
                              ),

                              const SizedBox(height: 10),

                              // Password Field
                              const Row(
                                children: [
                                  Icon(Icons.lock_outline),
                                  SizedBox(width: 2),
                                  Text(
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
                                    color: const Color(0xffACACAC),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordObscure = !_isPasswordObscure;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 5),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: cubit.isRememberMe,
                                        side: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        activeColor: AppColors.primaryColor,
                                        onChanged: (v) => setState(
                                          () =>
                                              cubit.changeRememberMeStatus(v!),
                                        ),
                                      ),
                                      const Text(
                                        "Remember Me",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
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
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 5),

                              (state is LoginLoading)
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : CustomButton(
                                      text: "Login",
                                      onPressed: cubit.loginWithEmail,
                                    ),

                              const SizedBox(height: 20),

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

                              const SizedBox(height: 10),

                              const Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: Color(0xffC1C5C9)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      "Or",
                                      style: TextStyle(
                                        color: Color(0xffC1C5C9),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Color(0xffC1C5C9)),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              (state is LoginGoogleLoading)
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : BuildSocialButton(
                                      text: "Continue with Google",
                                      iconPath: 'assets/images/google.png',
                                      onPressed: cubit.loginWithGoogle,
                                    ),
                              const SizedBox(height: 15),
                              (state is LoginFacebookLoading)
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : BuildSocialButton(
                                      text: "Continue with Facebook",
                                      iconPath: 'assets/images/facebook.png',
                                      onPressed: cubit.loginWithFacebook,
                                    ),
                              const SizedBox(height: 15),
                              BuildSocialButton(
                                text: "Continue with Apple",
                                iconPath: 'assets/images/apple.png',
                                onPressed: () {},
                              ),

                              const SizedBox(height: 40),
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
