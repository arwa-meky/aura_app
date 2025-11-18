import 'package:aura_project/core/helpers/local_storage.dart';
import 'package:aura_project/fratuers/on_boarding/model/on_boarding_models.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial(0));

  final CarouselSliderController carouselController =
      CarouselSliderController();
  final List<OnBoardingModels> onBoardingModels = [
    OnBoardingModels(
      imagePath: 'assets/images/onboarding1.png',
      title: "Welcome to Aura",
      descraption:
          "Discover a new way to connect, share, and enjoy with friends.",
    ),
    OnBoardingModels(
      imagePath: 'assets/images/onboarding2.png',
      title: "Connect with Friends",
      descraption: "Stay in touch and share your moments, all in one place.",
    ),
    OnBoardingModels(
      imagePath: 'assets/images/onboarding3.png',
      title: "Enjoy the Experience",
      descraption: "Let's get started and explore the features together.",
    ),
  ];

  void finishOnBoarding() {
    LocalStorage.setHasSeenOnBoarding(true);
    emit(OnBoardingNavigateToLogin());
  }

  void onPageChanged(int index) {
    emit(OnBoardingInitial(index));
  }

  void skip() {
    finishOnBoarding();
  }

  void nextOrGetStarted() {
    final currentState = state;
    if (currentState is OnBoardingInitial) {
      if (currentState.currentPage == onBoardingModels.length - 1) {
        finishOnBoarding();
      } else {
        carouselController.nextPage();
      }
    }
  }
}
