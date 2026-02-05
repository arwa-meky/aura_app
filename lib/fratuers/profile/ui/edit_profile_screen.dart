import 'package:aura_project/core/widgets/build_field_label.dart';
import 'package:aura_project/core/widgets/custom_dialog.dart';
import 'package:aura_project/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:aura_project/fratuers/profile/logic/profile_cubit.dart';
import 'package:aura_project/fratuers/profile/logic/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().initEditProfile();
  }

  Widget buildCounterSuffix(TextEditingController controller) {
    return Container(
      height: 20,
      width: 20,
      alignment: Alignment.center,
      child: Column(
        children: [
          Transform.translate(
            offset: const Offset(0, 6),
            child: GestureDetector(
              onTap: () {
                int currentValue = int.tryParse(controller.text) ?? 0;
                setState(() {
                  controller.text = (currentValue + 1).toString();
                });
              },
              child: const Icon(Icons.arrow_drop_up, color: Colors.grey),
            ),
          ),

          Transform.translate(
            offset: const Offset(0, -8),
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

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileInfoUpdateSuccess) {
          SuccessDialog.show(
            context,
            title: 'Changes Saved Successfully',
            description: 'Your profile informationhas been updated.',
            buttonText: 'Submit',
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        } else if (state is ProfileInfoUpdateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
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
        final user = cubit.currentUser;
        return Scaffold(
          backgroundColor: const Color(0xffF8F9FD),
          appBar: AppBar(
            title: const Text(
              "Edit Profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: cubit.profileImage != null
                            ? FileImage(cubit.profileImage!) as ImageProvider
                            : (user?.photoUrl != null)
                            ? NetworkImage(user!.photoUrl!) as ImageProvider
                            : null,
                        child:
                            (cubit.profileImage == null &&
                                user?.photoUrl == null)
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      InkWell(
                        onTap: () => cubit.pickImage(),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: const Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  "Personal Data",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Color(0xff194B96).withOpacity(.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.person,
                              color: Color(0xff194B96),
                              size: 25,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Personal Information",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: _buildLabelAndField(
                              "First Name",
                              Color(0xffEEEEEE),

                              cubit.firstNameController,
                              isReadOnly: true,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildLabelAndField(
                              "Last Name",
                              Color(0xffEEEEEE),
                              cubit.lastNameController,
                              isReadOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      const Text(
                        "Mobile Phone",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xffFFFFFF),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xffE0E0E0),
                              ),
                            ),
                            child: CountryCodePicker(
                              onChanged: cubit.updateCountryCode,
                              initialSelection: 'EG',
                              favorite: const ['+20', 'EG'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              showFlag: true,
                              padding: EdgeInsets.zero,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFFFF),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xffE0E0E0),
                                ),
                              ),
                              child: TextField(
                                controller: cubit.phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  hintText: "10xxxxxxxx",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: _buildLabelAndField(
                              "Date of Birth",
                              Color(0xffFFFFFF),
                              cubit.dobController,
                              suffixIcon: const Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                                color: Colors.grey,
                              ),
                              isReadOnly: true,
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2003, 9, 17),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: Color(0xff194B96),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  cubit.updateBirthDate(picked);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(child: _buildAgeField(cubit.userAge)),
                        ],
                      ),
                      const SizedBox(height: 15),

                      const Text(
                        "Gender",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildGenderOption("Male", cubit),
                          const SizedBox(width: 10),
                          _buildGenderOption("Female", cubit),
                          const SizedBox(width: 10),
                          _buildGenderOption("Prefer not to say", cubit),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildFieldLabel('Height (cm)'),
                                CustomTextField(
                                  controller: cubit.heightController,
                                  hintText: '0',
                                  keyboardType: TextInputType.number,
                                  backgroundColor: const Color(0xffFFFFFF),
                                  hasBorder: true,
                                  suffixIcon: buildCounterSuffix(
                                    cubit.heightController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildFieldLabel('Weight (kg)'),
                                CustomTextField(
                                  controller: cubit.weightController,
                                  hintText: '0',
                                  keyboardType: TextInputType.number,
                                  backgroundColor: const Color(0xffFFFFFF),
                                  hasBorder: true,
                                  suffixIcon: buildCounterSuffix(
                                    cubit.weightController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      cubit.updateUserData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff194B96),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: (state is ProfileInfoUpdateLoading)
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Save Changes",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabelAndField(
    String label,
    Color color,
    TextEditingController controller, {
    bool isReadOnly = false,
    VoidCallback? onTap,
    Icon? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xffE0E0E0)),
          ),
          child: TextField(
            controller: controller,
            readOnly: isReadOnly,
            onTap: onTap,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeField(String age) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your Age",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xffEEEEEE),

            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xffE0E0E0)),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$age ",
                  style: const TextStyle(
                    color: Color(0xff194B96),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const TextSpan(
                  text: "years",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption(String label, ProfileCubit cubit) {
    bool isSelected = cubit.selectedGender == label.replaceAll("\n", " ");
    return Expanded(
      child: GestureDetector(
        onTap: null,
        child: Container(
          padding: EdgeInsets.all(4),
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xff194B96)
                  : const Color(0xffE0E0E0),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
