class ApiConstants {
  ApiConstants._();
  static const String baseUrl = "http://10.0.2.2:3000/";
  static const String login = 'api/v1/users/auth/login';
  static const String register = 'api/v1/users/auth/signup';
  static const String forgotPassword = "api/v1/users/auth/forget-password";
  static const String loginWithGoogle = "api/v1/users/auth/google";
  static const String logout = "api/v1/users/auth/logout";
  static const String validateOtp = "api/v1/users/auth/validate-otp";
  static const String completeProfile = "api/v1/users/auth/complete-profile";
  static const String updateMyPassword = "api/v1/users/auth/update-my-password";
  static const String refreshToken = "api/v1/users/auth/refresh-token";
  static const String resetPassword = "api/v1/users/auth/reset-password";
}
