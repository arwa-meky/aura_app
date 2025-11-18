import 'package:aura_project/core/networking/auth_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final AuthApiService _apiService = AuthApiService();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController roleController = TextEditingController(
    text: "patient",
  );

  final formKey = GlobalKey<FormState>();

  void register() async {
    if (formKey.currentState == null || !formKey.currentState!.validate())
      return;

    if (passwordController.text != confirmPasswordController.text) {
      emit(RegisterFailure("Passwords do not match"));
      return;
    }

    emit(RegisterLoading());
    try {
      await _apiService.register(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        password: passwordController.text,
        passwordConfirm: confirmPasswordController.text,
        role: roleController.text,
      );
      emit(RegisterSuccess());
    } on DioException catch (e) {
      emit(RegisterFailure(handleDioError(e)));
    } catch (e) {
      emit(RegisterFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }

  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) return "Please enter your name";
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || !value.contains('@') || value.isEmpty) {
      return "Please enter a valid email";
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    roleController.dispose();
    return super.close();
  }
}

String handleDioError(DioException e) {
  if (e.response != null) {
    if (e.response?.statusCode == 422) {
      final errors = e.response?.data['errors'];
      if (errors != null && errors['email'] != null) {
        return errors['email'][0];
      }
    }
    return e.response?.data['message'] ?? "Server error";
  } else {
    return "Check your internet connection";
  }
}
