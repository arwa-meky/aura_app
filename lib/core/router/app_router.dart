import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/fratuers/compelete_profile/ui/complete_profile_screen.dart';
import 'package:aura_project/fratuers/home/home_screen.dart';
import 'package:aura_project/fratuers/login/ui/forget_password_screen.dart';
import 'package:aura_project/fratuers/login/ui/login_screen.dart';
import 'package:aura_project/fratuers/login/ui/new_password_screen.dart';
import 'package:aura_project/fratuers/login/ui/verify_resetcode_creen.dart';
import 'package:aura_project/fratuers/on_boarding/ui/on_boarding_screen.dart';
import 'package:aura_project/fratuers/on_boarding/ui/welcome_screen.dart';
import 'package:aura_project/fratuers/register/ui/register_screen.dart';
import 'package:aura_project/fratuers/vildate_otp/ui/validate_otp_screen.dart';
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

      case Routes.validateOtp:
        return MaterialPageRoute(
          builder: (_) => ValidateOtpScreen(),
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
      case Routes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case Routes.verifyResetCode:
        return MaterialPageRoute(
          builder: (_) => const VerifyResetCodeScreen(),
          settings: settings,
        );

      case Routes.newPassword:
        return MaterialPageRoute(
          builder: (_) => const NewPasswordScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(builder: (context) => Container());
    }
  }
}
