import 'package:aura_project/core/helpers/local_storage.dart';
import 'package:aura_project/fratuers/splach/logic/splach_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  void decideRoute() {
    Future.delayed(const Duration(seconds: 3), () {
      final String? token = LocalStorage.token;
      final bool hasToken = (token != null && token.isNotEmpty);

      if (hasToken) {
        emit(SplashNavigateToHome());
      } else {
        final bool hasSeenOnBoarding = LocalStorage.getHasSeenOnBoarding();
        if (hasSeenOnBoarding) {
          emit(SplashNavigateToLogin());
        } else {
          emit(SplashNavigateToOnBoarding());
        }
      }
    });
  }
}
