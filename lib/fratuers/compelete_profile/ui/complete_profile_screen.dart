import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/style/colors.dart';
import 'package:aura_project/fratuers/compelete_profile/logic/complete_profile_cubit.dart';
import 'package:aura_project/fratuers/compelete_profile/logic/complete_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura_project/core/widgets/custom_auth_title_desc.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/core/widgets/custom_text_field.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompleteProfileCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Complete Profile")),
        body: BlocConsumer<CompleteProfileCubit, CompleteProfileState>(
          listener: (context, state) {
            if (state is CompleteProfileSuccess) {
              context.pushNamedAndRemoveAll(Routes.home);
            } else if (state is CompleteProfileFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<CompleteProfileCubit>();

            final borderRadius = BorderRadius.circular(
              context.screenWidth * 0.04,
            );
            final inputDecoration = InputDecoration(
              filled: true,
              fillColor: const Color(0xffFDFDFF),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.text30Color),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.text30Color),
                borderRadius: borderRadius,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primaryColor),
                borderRadius: borderRadius,
              ),
            );

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.screenWidth * 0.04,
              ),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  children: [
                    SizedBox(height: context.usableHeight * 0.05),

                    const CustomAuthTitleDesc(
                      title: "Tell Us About Yourself",
                      description:
                          "Please provide your details to personalize your experience.",
                    ),

                    SizedBox(height: context.usableHeight * 0.05),

                    DropdownButtonFormField<String>(
                      value: cubit.selectedGender,
                      decoration: inputDecoration.copyWith(
                        labelText: "Gender",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: context.getResponsiveFontSize(
                            15,
                            minSize: 13,
                            maxSize: 17,
                          ),
                        ),
                      ),
                      items: ["Male", "Female"]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontSize: context.getResponsiveFontSize(
                                    16,
                                    minSize: 14,
                                    maxSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) cubit.selectedGender = val;
                      },
                    ),

                    SizedBox(height: context.usableHeight * 0.02),

                    CustomTextField(
                      controller: cubit.ageController,
                      hintText: "Age (years)",
                      keyboardType: TextInputType.number,
                      validator: CompleteProfileCubit.numberValidator,
                    ),

                    SizedBox(height: context.usableHeight * 0.02),

                    CustomTextField(
                      controller: cubit.weightController,
                      hintText: "Weight (kg)",
                      keyboardType: TextInputType.number,
                      validator: CompleteProfileCubit.numberValidator,
                    ),

                    SizedBox(height: context.usableHeight * 0.05),

                    (state is CompleteProfileLoading)
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            text: "Save & Continue",
                            onPressed: cubit.submitProfile,
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
