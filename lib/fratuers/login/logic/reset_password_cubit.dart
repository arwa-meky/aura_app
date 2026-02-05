import 'package:aura_project/core/networking/auth_api_service.dart';
import 'package:aura_project/fratuers/login/logic/login_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  final AuthApiService _apiService = AuthApiService();

  String? email;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

  void resetPassword() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    if (email == null) {
      emit(ResetPasswordFailure("Missing email info"));
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      emit(ResetPasswordFailure("Passwords do not match"));
      return;
    }

    emit(ResetPasswordLoading());
    try {
      await _apiService.resetPassword(
        email: email!,
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

  static String? passwordValidator(String? value) {
    if (value == null || value.length < 6) {
      return "Password too short (min 6 chars)";
    }
    return null;
  }

  @override
  Future<void> close() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
