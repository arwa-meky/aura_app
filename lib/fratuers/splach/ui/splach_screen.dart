import 'package:aura_project/core/helpers/extension.dart';

import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/fratuers/splach/logic/splach_cubit.dart';
import 'package:aura_project/fratuers/splach/logic/splach_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplachScreen extends StatelessWidget {
  const SplachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..decideRoute(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateToOnBoarding) {
            context.pushNamedAndRemoveAll(Routes.onBoarding);
          } else if (state is SplashNavigateToWelcome) {
            context.pushNamedAndRemoveAll(Routes.welcome);
          } else if (state is SplashNavigateToHome) {
            context.pushNamedAndRemoveAll(Routes.home);
          }
        },
        child: Scaffold(
          body: Center(
            child: Image.asset(
              'assets/images/logo_image.png',
              width: context.screenWidth * 0.6,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
