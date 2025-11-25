import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/fratuers/register/logic/register_cubit.dart';
import 'package:aura_project/fratuers/register/logic/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura_project/core/widgets/custom_auth_title_desc.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/core/widgets/custom_text_button.dart';
import 'package:aura_project/core/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Create New Account")),
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Account created successfully! Please verify."),
                  backgroundColor: Colors.green,
                ),
              );
              context.pushNamed(
                Routes.validateOtp,
                arguments: context.read<RegisterCubit>().emailController.text,
              );
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<RegisterCubit>();
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.04,
                ),
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    children: [
                      SizedBox(height: context.usableHeight * 0.03),
                      const CustomAuthTitleDesc(
                        title: "Welcome!",
                        description: "Create your account to get started",
                      ),
                      SizedBox(height: context.usableHeight * 0.03),

                      CustomTextField(
                        controller: cubit.firstNameController,
                        hintText: "First Name",
                        validator: RegisterCubit.nameValidator,
                      ),
                      SizedBox(height: context.usableHeight * 0.02),
                      CustomTextField(
                        controller: cubit.lastNameController,
                        hintText: "Last Name",
                        validator: RegisterCubit.nameValidator,
                      ),

                      SizedBox(height: context.usableHeight * 0.02),
                      CustomTextField(
                        controller: cubit.emailController,
                        hintText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: RegisterCubit.emailValidator,
                      ),
                      SizedBox(height: context.usableHeight * 0.02),
                      CustomTextField(
                        controller: cubit.passwordController,
                        hintText: "Password",
                        obscureText: isPasswordObscure,
                        validator: RegisterCubit.passwordValidator,
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
                        hintText: "Confirm Password",
                        obscureText: isConfirmPasswordObscure,
                        validator: (value) {
                          if (value != cubit.passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        suffixIcon: isConfirmPasswordObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onSuffixIcon: () {
                          setState(() {
                            isConfirmPasswordObscure =
                                !isConfirmPasswordObscure;
                          });
                        },
                      ),

                      SizedBox(height: context.usableHeight * 0.03),

                      (state is RegisterLoading)
                          ? const CircularProgressIndicator()
                          : CustomButton(
                              text: "Create Account",
                              onPressed: cubit.register,
                            ),

                      SizedBox(height: context.usableHeight * 0.02),

                      CustomTextButton(
                        text: "Already have an account? Login",
                        color: 0xff000000,
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
