abstract class OnBoardingState {}

class OnBoardingInitial extends OnBoardingState {
  final int currentPage;
  OnBoardingInitial(this.currentPage);
}

class OnBoardingNavigateToLogin extends OnBoardingState {}
