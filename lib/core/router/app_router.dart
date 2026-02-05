import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/fratuers/bluetooth/ui/bluetooth_screen.dart';
import 'package:aura_project/fratuers/bluetooth/ui/permission_screen.dart';
import 'package:aura_project/fratuers/calendar/ui/calender_screen.dart';
import 'package:aura_project/fratuers/compelete_profile/ui/complete_profile_screen.dart';
import 'package:aura_project/fratuers/device/ui/device_screen.dart';
import 'package:aura_project/fratuers/home_test/ui/home_screen.dart';
import 'package:aura_project/fratuers/login/ui/forget_password_screen.dart';
import 'package:aura_project/fratuers/login/ui/login_screen.dart';
import 'package:aura_project/fratuers/login/ui/new_password_screen.dart';
import 'package:aura_project/fratuers/login/ui/verify_resetcode_screen.dart';
import 'package:aura_project/fratuers/on_boarding/ui/on_boarding_screen.dart';
import 'package:aura_project/fratuers/on_boarding/ui/welcome_screen.dart';
import 'package:aura_project/fratuers/profile/logic/profile_cubit.dart';
import 'package:aura_project/fratuers/profile/ui/change_password_screen.dart';
import 'package:aura_project/fratuers/profile/ui/edit_profile_screen.dart';
import 'package:aura_project/fratuers/register/ui/register_screen.dart';
import 'package:aura_project/fratuers/tab_bar/ui/tabBar_screen.dart';
import 'package:aura_project/fratuers/vildate_otp/ui/validate_otp_screen.dart';
import 'package:aura_project/fratuers/splach/ui/splach_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return MaterialPageRoute(builder: (context) => const HomeTestScreen());
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
      case Routes.bluetoothConnect:
        return MaterialPageRoute(builder: (_) => const BluetoothScreen());

      case Routes.bluetoothPermission:
        return MaterialPageRoute(builder: (_) => const PermissionsScreen());

      case Routes.calender:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case Routes.device:
        return MaterialPageRoute(builder: (_) => const DeviceScreen());
      case Routes.appBar:
        return MaterialPageRoute(builder: (_) => const LayoutScreen());
      case Routes.changePassword:
        final cubit = settings.arguments as ProfileCubit;

        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: cubit,
            child: const ChangePasswordScreen(),
          ),
        );
      case Routes.editProfile:
        final cubit = settings.arguments as ProfileCubit;

        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: cubit,
            child: const EditProfileScreen(),
          ),
        );

      default:
        return MaterialPageRoute(builder: (context) => Container());
    }
  }
}
