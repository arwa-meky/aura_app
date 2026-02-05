import 'package:aura_project/core/helpers/storage/local_storage.dart';
import 'package:aura_project/core/networking/auth_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
      emit(LoginSuccess(isProfileComplete: true));
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
        serverClientId:
            "1054613969192-94sm2a01bbpnl41cvnh4i6kjkbecadvm.apps.googleusercontent.com",
        scopes: ['email', "profile"],
      );
      final user = await googleSignIn.signIn();
      if (user == null) {
        emit(LoginInitial());
        return;
      }
      final auth = await user.authentication;
      final idToken = auth.idToken;
      if (idToken == null) throw Exception("No idToken found");
      final response = await _apiService.loginWithGoogle(
        googleIdToken: idToken,
      );
      if (response.data != null && response.data['data']['token'] != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(
          response.data['data']['token'],
        );

        print("🔓 Decoded Data: $decodedToken");

        String userId =
            decodedToken['id'] ??
            decodedToken['_id'] ??
            decodedToken['sub'] ??
            "";

        await LocalStorage.saveToken(response.data['data']['token']);

        if (userId.isNotEmpty) {
          await LocalStorage.saveUserId(userId);
          print("✅ User ID Saved: $userId");
        } else {
          print("❌ Could not find User ID in token!");
        }
        bool isComplete = response.data['isProfileComplete'] ?? false;
        emit(LoginGoogleSuccess(isProfileComplete: isComplete));
      } else {
        emit(LoginGoogleFailure("Invalid response from server"));
      }
    } catch (e) {
      if (e is DioException) {
        emit(LoginGoogleFailure(handleDioError(e)));
      } else {
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
        if (response.data != null && response.data['data']['token'] != null) {
          Map<String, dynamic> decodedToken = JwtDecoder.decode(
            response.data['data']['token'],
          );

          print("🔓 Decoded Data: $decodedToken");

          String userId =
              decodedToken['id'] ??
              decodedToken['_id'] ??
              decodedToken['sub'] ??
              "";

          await LocalStorage.saveToken(response.data['data']['token']);

          if (userId.isNotEmpty) {
            await LocalStorage.saveUserId(userId);
            print("✅ User ID Saved: $userId");
          } else {
            print("❌ Could not find User ID in token!");
          }
        }

        bool isComplete = response.data['isProfileComplete'] ?? false;
        emit(LoginFacebookSuccess(isProfileComplete: isComplete));
      } else if (result.status == LoginStatus.cancelled) {
        emit(LoginInitial());
      } else {
        emit(LoginFacebookFailure(result.message ?? "Facebook login failed"));
      }
    } catch (e) {
      if (e is DioException) {
        emit(LoginFacebookFailure(handleDioError(e)));
      } else {
        emit(LoginFacebookFailure(e.toString()));
      }
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
