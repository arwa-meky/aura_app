abstract class ValidateOtpState {}

class ValidateOtpInitial extends ValidateOtpState {}

class ValidateOtpLoading extends ValidateOtpState {}

class ValidateOtpSuccess extends ValidateOtpState {}

class ValidateOtpNavigateToCompleteProfile extends ValidateOtpState {}

class ValidateOtpFailure extends ValidateOtpState {
  final String errorMessage;
  ValidateOtpFailure(this.errorMessage);
}
