import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/style/colors.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/core/widgets/custom_input_label.dart';
import 'package:aura_project/core/widgets/custom_text_field.dart';
import 'package:aura_project/core/widgets/custom_soical_button.dart';
import 'package:aura_project/fratuers/register/logic/register_cubit.dart';
import 'package:aura_project/fratuers/register/logic/register_state.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _isAgreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            context.pushNamed(
              Routes.validateOtp,
              arguments: {
                'email': context.read<RegisterCubit>().emailController.text,
                'isSignup': true,
              },
            );
          } else if (state is RegisterFailure) {
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
          final cubit = context.read<RegisterCubit>();

          return Scaffold(
            backgroundColor: Color(0xffF5F8FF),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.06,
                ),
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.usableHeight * 0.01),
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

                      Text(
                        "Create Your Account",
                        style: TextStyle(
                          fontSize: context.getResponsiveFontSize(
                            24,
                            minSize: 16,
                            maxSize: 25,
                          ),
                          fontWeight: FontWeight.bold,
                          color: AppColors.text100Color,
                        ),
                      ),
                      SizedBox(height: context.usableHeight * 0.01),
                      Text(
                        "Start your journey with smart, \ncontinuous health monitoring.",
                        style: TextStyle(
                          fontSize: context.getResponsiveFontSize(
                            16,
                            minSize: 12,
                            maxSize: 16,
                          ),
                          color: AppColors.textBodyColor,
                        ),
                      ),
                      SizedBox(height: context.usableHeight * 0.03),

                      Row(
                        children: [
                          const Icon(Icons.person_outline),
                          SizedBox(width: 2),
                          const Text(
                            "Full Name",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: cubit.firstNameController,
                              hintText: "First Name",
                              backgroundColor: const Color(0xffEEEEEE),
                              validator: RegisterCubit.nameValidator,
                              hasBorder: true,
                            ),
                          ),
                          SizedBox(width: context.screenWidth * 0.03),
                          Expanded(
                            child: CustomTextField(
                              controller: cubit.lastNameController,
                              hintText: "Last Name",
                              backgroundColor: const Color(0xffEEEEEE),
                              validator: RegisterCubit.nameValidator,
                              hasBorder: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.usableHeight * 0.02),

                      Row(
                        children: [
                          const Icon(Icons.email_outlined),
                          SizedBox(width: 2),
                          const Text(
                            "Email Address",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      CustomTextField(
                        controller: cubit.emailController,
                        hintText: "Enter Your Email",
                        backgroundColor: const Color(0xffEEEEEE),
                        keyboardType: TextInputType.emailAddress,
                        validator: RegisterCubit.emailValidator,
                        hasBorder: true,
                      ),
                      SizedBox(height: context.usableHeight * 0.02),

                      Row(
                        children: [
                          const Icon(Icons.lock_outline),
                          SizedBox(width: 2),
                          const Text(
                            "Password",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      CustomTextField(
                        controller: cubit.passwordController,
                        hintText: "Enter your password",

                        obscureText: _isPasswordObscure,
                        hasBorder: true,
                        backgroundColor: const Color(0xffEEEEEE),
                        validator: RegisterCubit.passwordValidator,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordObscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(
                            () => _isPasswordObscure = !_isPasswordObscure,
                          ),
                        ),
                      ),
                      SizedBox(height: context.usableHeight * 0.02),

                      Row(
                        children: [
                          const Icon(Icons.lock_outline),
                          SizedBox(width: 2),
                          const Text(
                            " Confirm Password",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      CustomTextField(
                        controller: cubit.confirmPasswordController,
                        hintText: "Re-enter your password",

                        obscureText: _isConfirmPasswordObscure,
                        hasBorder: true,
                        backgroundColor: const Color(0xffEEEEEE),
                        validator: (value) =>
                            RegisterCubit.confirmPasswordValidator(
                              value,
                              cubit.passwordController.text,
                            ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordObscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(
                            () => _isConfirmPasswordObscure =
                                !_isConfirmPasswordObscure,
                          ),
                        ),
                      ),
                      SizedBox(height: context.usableHeight * 0.02),

                      BuildInputLabel(
                        text: "Phone Number",
                        icon: Icons.phone_outlined,
                        iconColor: AppColors.text100Color,
                      ),
                      SizedBox(height: 1),

                      Row(
                        children: [
                          Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: const Color(0xffEEEEEE),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xffE0E0E0),
                              ),
                            ),
                            child: CountryCodePicker(
                              onChanged: (country) {
                                if (country.dialCode != null) {
                                  cubit.selectedCountryCode = country.dialCode!;
                                }
                              },
                              initialSelection: 'EG',
                              closeIcon: Icon(Icons.keyboard_arrow_down),
                              favorite: const ['+20', 'EG'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              padding: EdgeInsets.zero,
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              flagWidth: 25,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              controller: cubit.phoneController,
                              hintText: "Enter Your Phone Number",
                              keyboardType: TextInputType.phone,
                              backgroundColor: const Color(0xffEEEEEE),
                              hasBorder: true,
                              validator: RegisterCubit.phoneValidator,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: context.usableHeight * 0.02),

                      Row(
                        children: [
                          Checkbox(
                            value: _isAgreedToTerms,
                            activeColor: AppColors.primaryColor,
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _isAgreedToTerms = value!;
                              });
                            },
                          ),

                          const SizedBox(width: 5),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: context.getResponsiveFontSize(
                                    13,
                                    minSize: 12,
                                    maxSize: 14,
                                  ),
                                ),
                                children: [
                                  const TextSpan(
                                    text: "I agree to the ",
                                    style: TextStyle(color: Color(0xff212121)),
                                  ),
                                  TextSpan(
                                    text: "Terms & Conditions",
                                    style: const TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // TODO: فتح صفحة الشروط
                                      },
                                  ),
                                  const TextSpan(
                                    text: " and ",
                                    style: TextStyle(color: Color(0xff212121)),
                                  ),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: const TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // TODO: فتح صفحة الخصوصية
                                      },
                                  ),
                                  const TextSpan(text: "."),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.usableHeight * 0.02),

                      (state is RegisterLoading)
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              text: "Create Account",
                              onPressed: () {
                                if (!_isAgreedToTerms) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        "Please agree to the Terms & Conditions",
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                cubit.register();
                              },
                            ),
                      SizedBox(height: context.usableHeight * 0.02),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: AppColors.textBodyColor,
                              fontSize: context.getResponsiveFontSize(
                                14,
                                minSize: 12,
                                maxSize: 16,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.pushNamed(Routes.login),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: context.getResponsiveFontSize(
                                  14,
                                  minSize: 12,
                                  maxSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.usableHeight * 0.02),

                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: AppColors.text30Color),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Or",
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: AppColors.text30Color),
                          ),
                        ],
                      ),
                      SizedBox(height: context.usableHeight * 0.01),

                      BuildSocialButton(
                        text: "Continue with Google",
                        iconPath: 'assets/images/google.png',
                        onPressed: () {},
                      ),
                      SizedBox(height: context.usableHeight * 0.01),
                      BuildSocialButton(
                        text: "Continue with Facebook",
                        iconPath: 'assets/images/facebook.png',
                        onPressed: () {},
                      ),
                      SizedBox(height: context.usableHeight * 0.01),
                      BuildSocialButton(
                        text: "Continue with Apple",
                        iconPath: 'assets/images/apple.png',
                        onPressed: () {},
                      ),

                      SizedBox(height: context.usableHeight * 0.01),
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
