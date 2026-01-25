import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/widgets/custom_input_label.dart';
import 'package:aura_project/fratuers/compelete_profile/logic/complete_profile_cubit.dart';
import 'package:aura_project/fratuers/compelete_profile/logic/complete_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura_project/core/widgets/custom_text_field.dart';
import 'package:aura_project/core/widgets/custom_auth_title_desc.dart';
import 'package:aura_project/core/widgets/custom_button.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  String selectedActivity = 'Moderate';
  Widget _buildCounterSuffix(TextEditingController controller) {
    return Container(
      height: 20,
      width: 20,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              int currentValue = int.tryParse(controller.text) ?? 0;
              setState(() {
                controller.text = (currentValue + 1).toString();
              });
            },
            child: const Icon(Icons.arrow_drop_up, color: Colors.grey),
          ),

          Transform.translate(
            offset: const Offset(0, -6),
            child: GestureDetector(
              onTap: () {
                int currentValue = int.tryParse(controller.text) ?? 0;
                if (currentValue > 0) {
                  setState(() {
                    controller.text = (currentValue - 1).toString();
                  });
                }
              },
              child: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    CompleteProfileCubit cubit,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final age = DateTime.now().year - picked.year;
      cubit.ageController.text = age.toString();
      cubit.dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompleteProfileCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xffF5F8FF),
        body: SafeArea(
          child: BlocConsumer<CompleteProfileCubit, CompleteProfileState>(
            listener: (context, state) {
              if (state is CompleteProfileSuccess) {
                context.pushNamedAndRemoveAll(Routes.bluetoothPermission);
              } else if (state is CompleteProfileFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Color(0xffD32F2F),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<CompleteProfileCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 10,
                ),
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo_name.png',
                              width: context.screenWidth * 0.3,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: context.usableHeight * 0.03),
                          ],
                        ),
                      ),

                      const CustomAuthTitleDesc(
                        title: 'Complete Your Health Profile',
                        description:
                            'This helps Aura analyze your heart rate zones more accurately.',
                      ),

                      SizedBox(height: context.usableHeight * 0.04),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.05),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BuildInputLabel(
                              text: 'Personal Information',
                              icon: Icons.person,
                              iconColor: Color(0xff194B96),
                            ),

                            const SizedBox(height: 15),

                            _buildFieldLabel('Gender'),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildGenderButton(cubit, 'Male'),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildGenderButton(cubit, 'Female'),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildGenderButton(
                                    cubit,
                                    'Prefer not \nto say',
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel('Date of Birth'),
                                      GestureDetector(
                                        onTap: () =>
                                            _selectDate(context, cubit),
                                        child: AbsorbPointer(
                                          child: CustomTextField(
                                            controller: cubit.dobController,
                                            hintText: '00/00/0000',
                                            suffixIcon: const Icon(
                                              Icons.calendar_today_outlined,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            backgroundColor: const Color(
                                              0xffEEEEEE,
                                            ),
                                            hasBorder: false,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel('Your Age'),
                                      Container(
                                        height: 56,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffEEEEEE),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${cubit.ageController.text.isEmpty ? '0' : cubit.ageController.text} ",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff2979FF),
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              'Years',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff212121),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel('Height (cm)'),
                                      CustomTextField(
                                        controller: cubit.hightController,
                                        hintText: '0',
                                        keyboardType: TextInputType.number,
                                        backgroundColor: const Color(
                                          0xffEEEEEE,
                                        ),
                                        hasBorder: false,
                                        suffixIcon: _buildCounterSuffix(
                                          cubit.hightController,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel('Weight (kg)'),
                                      CustomTextField(
                                        controller: cubit.weightController,
                                        hintText: '0',
                                        keyboardType: TextInputType.number,
                                        backgroundColor: const Color(
                                          0xffEEEEEE,
                                        ),
                                        hasBorder: false,
                                        suffixIcon: _buildCounterSuffix(
                                          cubit.weightController,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            const BuildInputLabel(
                              text: 'Activity Level',
                              icon: Icons.directions_run,
                              iconColor: Color(0xff194B96),
                            ),
                            const SizedBox(height: 10),

                            _buildActivityCard(
                              'Low',
                              'Mostly sedentary, little to no exercise',
                            ),
                            const SizedBox(height: 10),
                            _buildActivityCard(
                              'Moderate',
                              'Light exercise 1-3 days per week',
                            ),
                            const SizedBox(height: 10),
                            _buildActivityCard(
                              'High',
                              'Vigorous exercise 4+ days per week',
                            ),

                            const SizedBox(height: 20),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.lock,
                                  size: 22,
                                  color: Color(0xff194B96),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Your data is encrypted and securely stored. We never share your personal health information with third parties.',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xff616161),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      (state is CompleteProfileLoading)
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              text: "Save & Continue",
                              onPressed: () {
                                cubit.submitProfile();
                              },
                            ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildGenderButton(CompleteProfileCubit cubit, String gender) {
    bool isSelected = cubit.selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          cubit.selectedGender = gender;
        });
      },
      child: Container(
        height: context.usableHeight * 0.13,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xffEEEEEE),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: const Color(0xff2979FF))
              : Border.all(color: Colors.transparent),
        ),
        child: Center(
          child: Text(
            gender,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(String title, String subtitle) {
    bool isSelected = selectedActivity == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedActivity = title;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffEEEEEE),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Color(0xff2979FF), width: 1.5)
              : Border.all(color: Color(0xffE0E0E0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isSelected ? Color(0xff2979FF) : Color(0xff212121),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Color(0xff616161)),
            ),
          ],
        ),
      ),
    );
  }
}
