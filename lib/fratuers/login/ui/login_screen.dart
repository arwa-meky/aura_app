import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/fratuers/login/logic/login_cubit.dart';
import 'package:aura_project/fratuers/login/logic/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura_project/core/widgets/custom_auth_title_desc.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/core/widgets/custom_text_button.dart';
import 'package:aura_project/core/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.pushNamed(
                Routes.validateOtp,
                arguments: context.read<LoginCubit>().emailController.text,
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
                        title: "Welcome Back!",
                        description: "Login to continue using the app",
                      ),

                      SizedBox(height: context.usableHeight * 0.03),

                      CustomTextField(
                        controller: cubit.emailController,
                        hintText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: LoginCubit.emailValidator,
                      ),

                      SizedBox(height: context.usableHeight * 0.02),

                      CustomTextField(
                        controller: cubit.passwordController,
                        hintText: "Password",
                        obscureText: isPasswordObscure,
                        validator: LoginCubit.passwordValidator,
                        suffixIcon: isPasswordObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onSuffixIcon: () {
                          setState(() {
                            isPasswordObscure = !isPasswordObscure;
                          });
                        },
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: CustomTextButton(
                          text: "Forgot Password?",
                          color: 0xff000000,
                          onPressed: () {
                            context.pushNamed(Routes.forgetPassword);
                          },
                        ),
                      ),

                      SizedBox(height: context.usableHeight * 0.03),

                      (state is LoginLoading)
                          ? const CircularProgressIndicator()
                          : CustomButton(
                              text: "Login",
                              onPressed: cubit.loginWithEmail,
                            ),

                      SizedBox(height: context.usableHeight * 0.02),

                      (state is LoginGoogleLoading)
                          ? const CircularProgressIndicator(color: Colors.blue)
                          : SizedBox(
                              width: double.infinity,
                              height: context.usableHeight * 0.06,
                              child: ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.g_mobiledata,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                label: Text(
                                  "Sign in with Google",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: context.getResponsiveFontSize(
                                      16,
                                      minSize: 14,
                                      maxSize: 18,
                                    ),
                                  ),
                                ),
                                onPressed: cubit.loginWithGoogle,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      context.screenWidth * 0.04,
                                    ),
                                    side: const BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),

                      SizedBox(height: context.usableHeight * 0.03),

                      CustomTextButton(
                        text: "Don't have an account? Sign up",
                        onPressed: () {
                          context.pushNamed(Routes.register);
                        },
                        color: 0xff000000,
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
