import 'package:aura_project/core/networking/auth_api_service.dart';
import 'package:aura_project/fratuers/login/logic/login_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  final AuthApiService _apiService = AuthApiService();

  final TextEditingController tokenController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

  void resetPassword() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      emit(ResetPasswordFailure("Passwords do not match"));
      return;
    }

    emit(ResetPasswordLoading());
    try {
      await _apiService.resetPassword(
        token: tokenController.text.trim(),
        email: emailController.text.trim(),
        newPassword: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      emit(ResetPasswordSuccess());
    } on DioException catch (e) {
      emit(ResetPasswordFailure(handleDioError(e, "Failed to reset password")));
    } catch (e) {
      emit(ResetPasswordFailure(e.toString()));
    }
  }

  static String? tokenValidator(String? value) {
    if (value == null || value.isEmpty)
      return "Please enter the token from your email";
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || !value.contains('@'))
      return "Please enter a valid email";
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.length < 6)
      return "Password too short (min 6 chars)";
    return null;
  }

  @override
  Future<void> close() {
    tokenController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
