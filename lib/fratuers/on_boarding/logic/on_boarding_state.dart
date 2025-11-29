abstract class OnBoardingState {}

class OnBoardingInitial extends OnBoardingState {
  final int currentPage;
  OnBoardingInitial(this.currentPage);
}

class OnBoardingNavigateToWelcome extends OnBoardingState {}
