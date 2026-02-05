abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final bool isProfileComplete;

  LoginSuccess({required this.isProfileComplete});
}

class LoginFailure extends LoginState {
  final String errorMessage;
  LoginFailure(this.errorMessage);
}

class LoginGoogleLoading extends LoginState {}

class LoginGoogleSuccess extends LoginState {
  final bool isProfileComplete;

  LoginGoogleSuccess({required this.isProfileComplete});
}

class LoginGoogleFailure extends LoginState {
  final String errorMessage;
  LoginGoogleFailure(this.errorMessage);
}

class LoginFacebookLoading extends LoginState {}

class LoginFacebookSuccess extends LoginState {
  final bool isProfileComplete;

  LoginFacebookSuccess({required this.isProfileComplete});
}

class LoginFacebookFailure extends LoginState {
  final String errorMessage;
  LoginFacebookFailure(this.errorMessage);
}
