import 'package:aura_project/core/helpers/local_storage.dart';
import 'package:aura_project/core/networking/api_constants.dart';
import 'package:aura_project/core/networking/dio_factory.dart';
import 'package:dio/dio.dart';

class AuthApiService {
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await DioFactory.postData(
      path: ApiConstants.login,
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirm,
    required String role,
  }) async {
    return await DioFactory.postData(
      path: ApiConstants.register,
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
        'role': role,
      },
    );
  }

  Future<Response> logout() async {
    return await DioFactory.postData(
      path: ApiConstants.logout,
      data: {},
      token: LocalStorage.token,
    );
  }

  Future<Response> forgotPassword({required String email}) async {
    return await DioFactory.postData(
      path: ApiConstants.forgotPassword,
      data: {'email': email},
    );
  }

  Future<Response> loginWithGoogle({required String googleIdToken}) async {
    return await DioFactory.postData(
      path: ApiConstants.loginWithGoogle,
      data: {'id_token': googleIdToken},
    );
  }

  Future<Response> validateOtp({required String otp}) async {
    return await DioFactory.postData(
      path: ApiConstants.validateOtp,
      data: {'otp': otp},
      // Note: Your API might require the user's token here.
      // If so, add: token: LocalStorage.token
    );
  }

  Future<Response> resetPassword({
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await DioFactory.patchData(
      path: ApiConstants.resetPassword,
      data: {
        'otp': otp,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      },
    );
  }
}
