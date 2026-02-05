import 'package:aura_project/core/networking/auth_api_service.dart';
import 'package:aura_project/fratuers/login/logic/login_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'complete_profile_state.dart';

class CompleteProfileCubit extends Cubit<CompleteProfileState> {
  CompleteProfileCubit() : super(CompleteProfileInitial());

  final AuthApiService _apiService = AuthApiService();

  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  final TextEditingController hightController = TextEditingController();

  String selectedGender = "Male";

  final formKey = GlobalKey<FormState>();

  void submitProfile() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    emit(CompleteProfileLoading());

    try {
      final int age = int.parse(ageController.text);
      final int weight = int.parse(weightController.text);
      final int hight = int.parse(hightController.text);

      await _apiService.completeProfile(
        gender: selectedGender,
        age: age,
        weight: weight,
        hight: hight,
      );

      emit(CompleteProfileSuccess());
    } on DioException catch (e) {
      emit(
        CompleteProfileFailure(handleDioError(e, "Failed to update profile")),
      );
    } catch (e) {
      emit(CompleteProfileFailure(e.toString()));
    }
  }

  static String? numberValidator(String? value) {
    if (value == null || value.isEmpty) return "Field required";
    if (int.tryParse(value) == null) return "Must be a number";
    return null;
  }

  @override
  Future<void> close() {
    ageController.dispose();
    weightController.dispose();
    hightController.dispose();
    return super.close();
  }
}
