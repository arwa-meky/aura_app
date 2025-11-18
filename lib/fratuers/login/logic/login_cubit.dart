import 'package:aura_project/core/helpers/local_storage.dart';
import 'package:aura_project/core/networking/auth_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final AuthApiService _apiService = AuthApiService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void loginWithEmail() async {
    if (formKey.currentState == null || !formKey.currentState!.validate())
      return;

    emit(LoginLoading());
    try {
      final response = await _apiService.login(
        email: emailController.text,
        password: passwordController.text,
      );

      final token = response.data['token'];
      await LocalStorage.saveToken(token);
      emit(LoginSuccess());
    } on DioException catch (e) {
      emit(LoginFailure(handleDioError(e, "Invalid email or password")));
    } catch (e) {
      emit(LoginFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }

  void loginWithGoogle() async {
    emit(LoginGoogleLoading());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        emit(LoginInitial());
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception("Google ID Token was null");
      }

      final response = await _apiService.loginWithGoogle(
        googleIdToken: idToken,
      );

      final token = response.data['token'];

      await LocalStorage.saveToken(token);
      emit(LoginGoogleSuccess());
    } on DioException catch (e) {
      emit(LoginGoogleFailure(handleDioError(e, "Google login failed")));
    } catch (e) {
      emit(LoginGoogleFailure(e.toString()));
    }
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
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}

String handleDioError(
  DioException e, [
  String defaultError = "An error occurred",
]) {
  if (e.response != null) {
    final serverError = e.response?.data['message'];
    return serverError ?? defaultError;
  } else {
    return "Check your internet connection";
  }
}
