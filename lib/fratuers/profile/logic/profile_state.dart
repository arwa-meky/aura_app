import 'package:aura_project/fratuers/profile/model/user_data_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

// --- Get User Data  ---
class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel userModel;
  ProfileLoaded(this.userModel);
}

class ProfileError extends ProfileState {
  final String error;
  ProfileError(this.error);
}

// --- Local Image Update  ---
class ProfileImagePicked extends ProfileState {}

// ---  Edit Profile Info States ---
class ProfileInfoUpdateLoading extends ProfileState {}

class ProfileInfoUpdateSuccess extends ProfileState {}

class ProfileInfoUpdateError extends ProfileState {
  final String error;
  ProfileInfoUpdateError(this.error);
}

// ---  Change Password States ---
class PasswordUpdateLoading extends ProfileState {}

class PasswordUpdateSuccess extends ProfileState {}

class PasswordUpdateError extends ProfileState {
  final String error;
  PasswordUpdateError(this.error);
}

// --- Logout ---
class ProfileLogOutLoading extends ProfileState {}

class ProfileLogOutSuccess extends ProfileState {}

class ProfileLogOutError extends ProfileState {
  final String error;
  ProfileLogOutError(this.error);
}
