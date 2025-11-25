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
      title: "Your Partner\nin Smart Health Monitoring",
      descraption:
          "A unified intelligent system for continuous health tracking and early panic attack detection.",
    ),
    OnBoardingModels(
      imagePath: 'assets/images/onboarding2.png',
      title: "Real-Time\nHealth Monitoring",
      descraption:
          "Track your heart rate, oxygen level, temperature, and activity effortlessly all from your wrist.",
    ),
    OnBoardingModels(
      imagePath: 'assets/images/onboarding3.png',
      title: "AI-Powered\nEarly Detection",
      descraption:
          "AURA analyzes your health patterns to detect risks early and alert you before issues escalate.",
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
