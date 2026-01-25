abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String errorMessage;
  ForgotPasswordFailure(this.errorMessage);
}

class VerifyCodeLoading extends ForgotPasswordState {}

class VerifyCodeSuccess extends ForgotPasswordState {}

class VerifyCodeFailure extends ForgotPasswordState {
  final String errorMessage;
  VerifyCodeFailure(this.errorMessage);
}
