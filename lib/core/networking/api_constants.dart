class ApiConstants {
  ApiConstants._();
  static const String baseUrl = "https://aura-health-monitor.vercel.app";
  static const String login = '/api/v1/users/auth/login';
  static const String register = '/api/v1/users/auth/signup';
  static const String forgotPassword = "/api/v1/users/auth/forget-password";
  static const String loginWithGoogle = "/api/v1/users/auth/google";
  static const String logout = "/api/v1/users/auth/logout";
  static const String validateOtp = "/api/v1/users/auth/validate-otp";

  static const String resetPassword =
      "/api/v1/users/auth/reset-password/a9549e6f42a1e57c6d0503fe4870860eb403c5ce1a073bc8b4a7741c13d1f775";
}
