abstract class CompleteProfileState {}

class CompleteProfileInitial extends CompleteProfileState {}

class CompleteProfileLoading extends CompleteProfileState {}

class CompleteProfileSuccess extends CompleteProfileState {}

class CompleteProfileFailure extends CompleteProfileState {
  final String errorMessage;
  CompleteProfileFailure(this.errorMessage);
}
