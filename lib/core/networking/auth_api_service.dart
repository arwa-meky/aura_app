import 'package:aura_project/core/helpers/storage/local_storage.dart';
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
    required String phoneNumber,
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
        'mobilePhone': phoneNumber,
        'role': role,
      },
    );
  }

  Future<Response> validateOtp({
    required String email,
    required String otp,
  }) async {
    return await DioFactory.postData(
      path: ApiConstants.validateOtp,
      data: {'email': email, 'otp': otp},
    );
  }

  Future<Response> completeProfile({
    required String gender,
    required int age,
    required int weight,
  }) async {
    return await DioFactory.postData(
      path: ApiConstants.completeProfile,
      data: {'gender': gender, 'age': age, 'weight': weight},
      token: LocalStorage.token,
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

  Future<Response> resetPassword({
    required String token,
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await DioFactory.patchData(
      path: "${ApiConstants.resetPassword}/$token",
      data: {
        'email': email,
        'password': newPassword,
        'passwordConfirm': confirmPassword,
      },
    );
  }

  Future<Response> updateMyPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await DioFactory.postData(
      path: ApiConstants.updateMyPassword,
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'passwordConfirm': confirmPassword,
      },
      token: LocalStorage.token,
    );
  }

  Future<Response> loginWithGoogle({required String googleIdToken}) async {
    return await DioFactory.getData(
      path: ApiConstants.loginWithGoogle,
      token: googleIdToken,
    );
  }

  Future<Response> loginWithFacebook({required String accessToken}) async {
    return await DioFactory.getData(
      path: ApiConstants.loginWithFacebook,
      token: accessToken,
    );
  }

  Future<Response> linkDevice({
    required String deviceId,
    required String deviceName,
  }) async {
    return await DioFactory.postData(
      path: ApiConstants.linkDevice,
      data: {'deviceId': deviceId, 'deviceName': deviceName},
      token: LocalStorage.token,
    );
  }

  Future<Response> getPairedDevices() async {
    return await DioFactory.getData(
      path: ApiConstants.pairedDevices,
      token: LocalStorage.token,
    );
  }

  Future<Response> unlinkDevice({required String deviceId}) async {
    return await DioFactory.deleteData(
      path: '${ApiConstants.disconnectDevice}/$deviceId',
      token: LocalStorage.token,
    );
  }
}
