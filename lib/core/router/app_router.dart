import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/fratuers/compelete_profile/ui/complete_profile_screen.dart';
import 'package:aura_project/fratuers/home/home_screen.dart';
import 'package:aura_project/fratuers/login/ui/forget_password_screen.dart';
import 'package:aura_project/fratuers/login/ui/login_screen.dart';
import 'package:aura_project/fratuers/login/ui/reset_password_screen.dart';
import 'package:aura_project/fratuers/on_boarding/ui/on_boarding_screen.dart';
import 'package:aura_project/fratuers/register/ui/register_screen.dart';
import 'package:aura_project/fratuers/register/ui/validate_otp_screen.dart';
import 'package:aura_project/fratuers/splach/ui/splach_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (context) => const SplachScreen());
      case Routes.onBoarding:
        return MaterialPageRoute(
          builder: (context) => const OnBoardingScreen(),
        );
      case Routes.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case Routes.forgetPassword:
        return MaterialPageRoute(
          builder: (context) => const ForgotPasswordScreen(),
        );
      case Routes.resetPassword:
        return MaterialPageRoute(
          builder: (context) => const ResetPasswordScreen(),
        );
      case Routes.validateOtp:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ValidateOtpScreen(email: email),
          settings: settings,
        );
      case Routes.register:
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case Routes.completeProfile:
        return MaterialPageRoute(
          builder: (context) => const CompleteProfileScreen(),
        );

      default:
        return MaterialPageRoute(builder: (context) => Container());
    }
  }
}
