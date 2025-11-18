import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/core/widgets/custom_text_button.dart';
import 'package:aura_project/fratuers/on_boarding/logic/on_boarding_cubit.dart';
import 'package:aura_project/fratuers/on_boarding/logic/on_boarding_state.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingCubit(),

      child: BlocConsumer<OnBoardingCubit, OnBoardingState>(
        listener: (context, state) {
          if (state is OnBoardingNavigateToLogin) {
            context.pushNamedAndRemoveAll(Routes.login);
          }
        },
        builder: (context, state) {
          final cubit = context.read<OnBoardingCubit>();

          int currentPage = 0;
          if (state is OnBoardingInitial) {
            currentPage = state.currentPage;
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                CustomTextButton(
                  text: "Skip",
                  onPressed: cubit.finishOnBoarding,
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.screenWidth * 0.04,
                vertical: context.usableHeight * 0.02,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: CarouselSlider.builder(
                      carouselController: cubit.carouselController,
                      itemCount: cubit.onBoardingModels.length,
                      itemBuilder: (context, index, realIndex) {
                        final item = cubit.onBoardingModels[index];

                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                item.imagePath,
                                height: context.usableHeight * 0.4,
                              ),
                              SizedBox(height: context.usableHeight * 0.04),
                              Text(
                                item.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: context.getResponsiveFontSize(
                                    24,
                                    minSize: 20,
                                    maxSize: 28,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: context.usableHeight * 0.02),
                              Text(
                                item.descraption,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: context.getResponsiveFontSize(
                                    15,
                                    minSize: 13,
                                    maxSize: 18,
                                  ),
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: context.usableHeight * 0.02),
                            ],
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: context.usableHeight * 0.7,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          cubit.onPageChanged(index);
                        },
                      ),
                    ),
                  ),

                  AnimatedSmoothIndicator(
                    activeIndex: currentPage,
                    count: cubit.onBoardingModels.length,
                    effect: WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: context.usableHeight * 0.05),

                  CustomButton(
                    text: currentPage == cubit.onBoardingModels.length - 1
                        ? "Get Started"
                        : "Next",
                    onPressed: cubit.nextOrGetStarted,
                  ),
                  SizedBox(height: context.usableHeight * 0.02),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
