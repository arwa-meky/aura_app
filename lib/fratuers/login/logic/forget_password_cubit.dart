import 'package:aura_project/core/networking/auth_api_service.dart';
import 'package:aura_project/fratuers/login/logic/forget_password_state.dart';
import 'package:aura_project/fratuers/login/logic/login_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  final AuthApiService _apiService = AuthApiService();
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void sendResetLink() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    emit(ForgotPasswordLoading());
    try {
      await _apiService.forgotPassword(email: emailController.text);

      emit(ForgotPasswordSuccess());
    } on DioException catch (e) {
      emit(ForgotPasswordFailure(handleDioError(e, "Email not found")));
    } catch (e) {
      emit(ForgotPasswordFailure("An unexpected error occurred."));
    }
  }

  static String? emailValidator(String? value) {
    if (value == null || !value.contains('@') || value.isEmpty) {
      return "Please enter a valid email";
    }
    return null;
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
}
