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
    required int hight,
  }) async {
    return await DioFactory.postData(
      path: ApiConstants.completeProfile,
      data: {'gender': gender, 'age': age, 'weight': weight, 'height': hight},
    );
  }

  Future<Response> logout() async {
    return await DioFactory.postData(path: ApiConstants.logout, data: {});
  }

  Future<Response> forgotPassword({required String email}) async {
    return await DioFactory.postData(
      path: ApiConstants.forgotPassword,
      data: {'email': email},
    );
  }

  Future<Response> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await DioFactory.patchData(
      path: ApiConstants.resetPassword,
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
    );
  }

  Future<Response> loginWithGoogle({required String googleIdToken}) async {
    String role = 'patient';
    return await DioFactory.postData(
      path: ApiConstants.loginWithGoogle,
      data: {'idToken': googleIdToken, 'role': role},
    );
  }

  Future<Response> loginWithFacebook({required String accessToken}) async {
    String role = 'patient';

    return await DioFactory.postData(
      path: ApiConstants.loginWithFacebook,
      data: {'accessToken': accessToken, 'role': role},
    );
  }

  Future<dynamic> verifyResetCode({
    required String email,
    required String code,
  }) async {
    final response = await DioFactory.postData(
      path: ApiConstants.validateOtp,
      data: {'email': email, 'otp': code},
    );

    return response.data;
  }

  Future<Response> linkDevice({
    required String deviceId,
    required String deviceName,
  }) async {
    return await DioFactory.postData(
      path: ApiConstants.linkDevice,
      data: {'deviceId': deviceId, 'deviceName': deviceName},
    );
  }

  Future<Response> getPairedDevices() async {
    return await DioFactory.getData(path: ApiConstants.pairedDevices);
  }

  Future<Response> unlinkDevice({required String deviceId}) async {
    return await DioFactory.deleteData(
      path: '${ApiConstants.disconnectDevice}/$deviceId',
    );
  }

  Future<Response> getPatientProfile() async {
    return await DioFactory.getData(path: ApiConstants.profileData);
  }

  Future<Response> updateProfileData(Map<String, dynamic> data) async {
    return await DioFactory.postData(
      path: ApiConstants.updateCompleteProfile,
      data: data,
    );
  }

  Future<Response> updateProfileImage(String imagePath) async {
    FormData formData = FormData.fromMap({
      "photo": await MultipartFile.fromFile(imagePath, filename: "profile.jpg"),
    });

    return await DioFactory.postData(
      path: ApiConstants.userPhoto,
      data: formData,
    );
  }
}
