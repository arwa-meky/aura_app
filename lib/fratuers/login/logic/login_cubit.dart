import 'package:aura_project/core/helpers/storage/local_storage.dart';
import 'package:aura_project/core/networking/auth_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final AuthApiService _apiService = AuthApiService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isRememberMe = false;

  void changeRememberMeStatus(bool value) {
    isRememberMe = value;
    emit(LoginInitial());
  }

  void loadSavedCredentials() {
    final savedEmail = LocalStorage.getCachedEmail();
    final savedPassword = LocalStorage.getCachedPassword();
    if (savedEmail != null && savedPassword != null) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      isRememberMe = true;
      emit(LoginInitial());
    }
  }

  void loginWithEmail() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    emit(LoginLoading());
    try {
      await _apiService.login(
        email: emailController.text,
        password: passwordController.text,
      );
      if (isRememberMe) {
        await LocalStorage.saveUserCredentials(
          emailController.text,
          passwordController.text,
        );
      } else {
        await LocalStorage.clearUserCredentials();
      }
      emit(LoginSuccess());
    } on DioException catch (e) {
      emit(LoginFailure(handleDioError(e, "Login failed")));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  void loginWithGoogle() async {
    emit(LoginGoogleLoading());

    try {
      final googleSignIn = GoogleSignIn(
        serverClientId: "",
        scopes: ['email', "profile"],
      );

      final user = await googleSignIn.signIn();
      if (user == null) {
        emit(LoginInitial());
        return;
      }

      final auth = await user.authentication;
      final idToken = auth.idToken;
      if (idToken == null) throw Exception("No idToken");

      final response = await _apiService.loginWithGoogle(
        googleIdToken: idToken,
      );
      if (response.data != null && response.data['token'] != null) {
        await LocalStorage.saveToken(response.data['token']);
        emit(LoginGoogleSuccess());
      } else {
        emit(LoginGoogleFailure("Invaild response from server"));
      }
    } catch (e) {
      if (e is DioException) {
        emit(LoginGoogleFailure(e.toString()));
      }
    }
  }

  void loginWithFacebook() async {
    emit(LoginFacebookLoading());

    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        final response = await _apiService.loginWithFacebook(
          accessToken: accessToken.tokenString,
        );

        await LocalStorage.saveToken(response.data['token']);

        emit(LoginFacebookSuccess());
      } else {
        emit(
          LoginFacebookFailure(result.message ?? "Facebook login cancelled"),
        );
      }
    } catch (e) {
      emit(LoginFacebookFailure(e.toString()));
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
    final msg = e.response?.data['message'];
    if (msg != null) return msg;
    return defaultError;
  } else {
    return "Check your internet connection";
  }
}
