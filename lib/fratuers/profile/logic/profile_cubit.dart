import 'dart:io';
import 'package:aura_project/core/helpers/storage/local_storage.dart';
import 'package:aura_project/core/networking/api_constants.dart';
import 'package:aura_project/core/networking/dio_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:aura_project/fratuers/profile/model/user_data_model.dart';
import 'package:aura_project/core/networking/auth_api_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);
  final AuthApiService _apiService = AuthApiService();

  UserModel? currentUser;
  File? profileImage;
  final ImagePicker _picker = ImagePicker();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final dobController = TextEditingController();

  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  String selectedGender = "Male";
  String selectedCountryCode = "+20";
  int _calculatedAge = 0;

  String get userAge => _calculatedAge.toString();

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    heightController.dispose();
    weightController.dispose();
    dobController.dispose();
    currentPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    return super.close();
  }

  void changeGender(String gender) {
    selectedGender = gender;
    if (currentUser != null) emit(ProfileLoaded(currentUser!));
  }

  void updateCountryCode(CountryCode code) {
    selectedCountryCode = code.dialCode ?? "+20";
  }

  void updateBirthDate(DateTime pickedDate) {
    dobController.text =
        "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";

    _calculateAgeFromDate(pickedDate);

    if (currentUser != null) emit(ProfileLoaded(currentUser!));
  }

  void _calculateAgeFromDate(DateTime date) {
    DateTime now = DateTime.now();
    int age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }
    _calculatedAge = age;
    print("User Age Calculated: $_calculatedAge");
  }

  void initProfile() async {
    await getUserData();
    await loadNotificationSettings();
  }

  void initEditProfile() {
    if (currentUser != null) {
      String full = currentUser!.fullName ?? "";
      List<String> nameParts = full.split(" ");

      firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : "";
      lastNameController.text = nameParts.length > 1
          ? nameParts.sublist(1).join(" ")
          : "";
      emailController.text = currentUser!.email ?? "";
      phoneController.text =
          currentUser!.phoneNumber?.replaceAll("+20", "").trim() ?? "";
      heightController.text = currentUser!.height ?? "0";
      weightController.text = currentUser!.weight ?? "0";
      selectedGender = currentUser!.gender ?? "Male";

      if (currentUser!.age != null) {
        _calculatedAge = int.tryParse(currentUser!.age.toString()) ?? 0;
      }
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ProfileImagePicked());
      if (currentUser != null) emit(ProfileLoaded(currentUser!));
    }
  }

  Future<void> getUserData() async {
    emit(ProfileLoading());
    try {
      final response = await _apiService.getPatientProfile();
      if (response.statusCode == 200) {
        currentUser = UserModel.fromJson(response.data);
        emit(ProfileLoaded(currentUser!));
      } else {
        emit(ProfileError("Failed to fetch data: ${response.statusMessage}"));
      }
    } catch (e) {
      emit(ProfileError("Failed to load profile: ${e.toString()}"));
    }
  }

  Future<void> updateUserData() async {
    if (isClosed) return;
    emit(ProfileInfoUpdateLoading());

    try {
      String cleanPhone = phoneController.text.trim();
      if (cleanPhone.startsWith('0')) {
        cleanPhone = cleanPhone.substring(1);
      }

      String fullPhoneNumber = "$selectedCountryCode$cleanPhone";

      print("📤 Sending Phone: $fullPhoneNumber");
      final Map<String, dynamic> jsonData = {
        "mobilePhone": fullPhoneNumber,
        "weight": weightController.text,
        "height": heightController.text,
        "age": _calculatedAge,
      };

      print("📤 Sending JSON: $jsonData");

      final response = await DioFactory.postData(
        path: ApiConstants.updateCompleteProfile,
        data: jsonData,
        token: LocalStorage.token,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(ProfileInfoUpdateSuccess());
        await getUserData();
      }
    } catch (e) {
      print("❌ Update Error: $e");
      emit(ProfileInfoUpdateError("Update failed: ${e.toString()}"));

      if (currentUser != null) emit(ProfileLoaded(currentUser!));
    }
  }

  void changePassword() async {
    if (currentPassController.text.isEmpty ||
        newPassController.text.isEmpty ||
        confirmPassController.text.isEmpty) {
      emit(PasswordUpdateError("Please fill all fields"));
      return;
    }
    if (newPassController.text != confirmPassController.text) {
      emit(PasswordUpdateError("Passwords do not match!"));
      return;
    }
    if (newPassController.text.length < 8) {
      emit(PasswordUpdateError("New password must be at least 8 characters"));
      return;
    }

    emit(PasswordUpdateLoading());
    try {
      final response = await _apiService.updateMyPassword(
        currentPassword: currentPassController.text,
        newPassword: newPassController.text,
        confirmPassword: confirmPassController.text,
      );

      if (response.statusCode == 200) {
        currentPassController.clear();
        newPassController.clear();
        confirmPassController.clear();
        emit(PasswordUpdateSuccess());
        if (currentUser != null) emit(ProfileLoaded(currentUser!));
      }
    } catch (e) {
      emit(PasswordUpdateError("Failed: ${e.toString()}"));
      if (currentUser != null) emit(ProfileLoaded(currentUser!));
    }
  }

  bool notifyGeneral = true;
  bool notifySound = true;
  bool notifyVibrate = true;
  bool notifyUpdates = false;
  bool notifyNewService = true;
  bool notifyTips = false;

  Future<void> loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    notifyGeneral = prefs.getBool('notify_general') ?? true;
    notifySound = prefs.getBool('notify_sound') ?? true;
    notifyVibrate = prefs.getBool('notify_vibrate') ?? true;
    notifyUpdates = prefs.getBool('notify_updates') ?? false;
    notifyNewService = prefs.getBool('notify_service') ?? true;
    notifyTips = prefs.getBool('notify_tips') ?? false;

    if (currentUser != null) emit(ProfileLoaded(currentUser!));
  }

  void changeNotificationSwitch(String type, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    switch (type) {
      case 'general':
        notifyGeneral = value;
        prefs.setBool('notify_general', value);
        break;
      case 'sound':
        notifySound = value;
        prefs.setBool('notify_sound', value);
        break;
      case 'vibrate':
        notifyVibrate = value;
        prefs.setBool('notify_vibrate', value);
        break;
      case 'updates':
        notifyUpdates = value;
        prefs.setBool('notify_updates', value);
        break;
      case 'service':
        notifyNewService = value;
        prefs.setBool('notify_service', value);
        break;
      case 'tips':
        notifyTips = value;
        prefs.setBool('notify_tips', value);
        break;
    }
    if (currentUser != null) emit(ProfileLoaded(currentUser!));
  }

  Future<void> logOut() async {
    emit(ProfileLogOutLoading());
    try {
      await _apiService.logout();
    } catch (e) {
      print("Logout API Error: $e");
    } finally {
      await LocalStorage.clearToken();
      currentUser = null;
      emit(ProfileLogOutSuccess());
    }
  }
}
