import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/style/colors.dart';
import 'package:aura_project/fratuers/on_boarding/logic/on_boarding_cubit.dart';
import 'package:aura_project/fratuers/on_boarding/logic/on_boarding_state.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura_project/core/widgets/custom_text_button.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingCubit(),
      child: BlocConsumer<OnBoardingCubit, OnBoardingState>(
        listener: (context, state) {
          if (state is OnBoardingNavigateToWelcome) {
            context.pushNamedAndRemoveAll(Routes.welcome);
          }
        },
        builder: (context, state) {
          final cubit = context.read<OnBoardingCubit>();
          int currentPage = 0;
          if (state is OnBoardingInitial) {
            currentPage = state.currentPage;
          }

          final bool isLastPage =
              currentPage == cubit.onBoardingModels.length - 1;
          final Color activeColor = Theme.of(context).colorScheme.primary;
          final Color inactiveColor = AppColors.text30Color;

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.06,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: context.usableHeight * 0.04),

                          Row(
                            children: List.generate(
                              cubit.onBoardingModels.length,
                              (index) {
                                return Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: index <= currentPage
                                          ? activeColor
                                          : inactiveColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: context.usableHeight * 0.03),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              'assets/images/logo_name.png',
                              height: context.usableHeight * 0.07,
                              fit: BoxFit.contain,
                            ),
                          ),

                          Expanded(
                            child: CarouselSlider.builder(
                              carouselController: cubit.carouselController,
                              itemCount: cubit.onBoardingModels.length,
                              itemBuilder: (context, index, realIndex) {
                                return Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(
                                    context.screenWidth * 0.05,
                                  ),
                                  child: Image.asset(
                                    cubit.onBoardingModels[index].imagePath,
                                    fit: BoxFit.contain,
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: double.infinity,
                                viewportFraction: 1.0,
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason) {
                                  cubit.onPageChanged(index);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 4,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.08,
                          vertical: context.usableHeight * 0.04,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  cubit.onBoardingModels[currentPage].title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: context.getResponsiveFontSize(
                                      22,
                                      minSize: 20,
                                      maxSize: 26,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text100Color,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: context.usableHeight * 0.02),
                                Text(
                                  cubit
                                      .onBoardingModels[currentPage]
                                      .descraption,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: context.getResponsiveFontSize(
                                      14,
                                      minSize: 12,
                                      maxSize: 16,
                                    ),
                                    color: AppColors.textBodyColor,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: !isLastPage,
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  child: CustomTextButton(
                                    color: 0xff000000,
                                    text: "Skip",
                                    onPressed: cubit.skip,
                                  ),
                                ),

                                ElevatedButton(
                                  onPressed: cubit.nextOrGetStarted,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.screenWidth * 0.08,
                                      vertical: context.usableHeight * 0.014,
                                    ),
                                  ),
                                  child: Text(
                                    isLastPage ? "Get Started" : "Next",
                                    style: TextStyle(
                                      fontSize: context.getResponsiveFontSize(
                                        10,
                                        minSize: 14,
                                        maxSize: 18,
                                      ),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
