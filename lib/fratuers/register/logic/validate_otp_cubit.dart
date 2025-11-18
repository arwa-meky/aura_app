import 'package:aura_project/core/networking/auth_api_service.dart';
import 'package:aura_project/fratuers/login/logic/login_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'validate_otp_state.dart';

class ValidateOtpCubit extends Cubit<ValidateOtpState> {
  ValidateOtpCubit() : super(ValidateOtpInitial());

  final AuthApiService _apiService = AuthApiService();
  final TextEditingController otpController = TextEditingController();

  void verifyOtp() async {
    if (otpController.text.isEmpty || otpController.text.length < 4) {
      emit(ValidateOtpFailure("Please enter a valid OTP"));
      return;
    }

    emit(ValidateOtpLoading());
    try {
      await _apiService.validateOtp(otp: otpController.text);
      emit(ValidateOtpSuccess());
    } on DioException catch (e) {
      emit(ValidateOtpFailure(handleDioError(e, "Invalid OTP")));
    } catch (e) {
      emit(ValidateOtpFailure("An unexpected error occurred."));
    }
  }

  @override
  Future<void> close() {
    otpController.dispose();
    return super.close();
  }
}
