abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String errorMessage;
  LoginFailure(this.errorMessage);
}

class LoginGoogleLoading extends LoginState {}

class LoginGoogleSuccess extends LoginState {}

class LoginGoogleFailure extends LoginState {
  final String errorMessage;
  LoginGoogleFailure(this.errorMessage);
}

class LoginFacebookLoading extends LoginState {}

class LoginFacebookSuccess extends LoginState {}

class LoginFacebookFailure extends LoginState {
  final String errMessage;
  LoginFacebookFailure(this.errMessage);
}
