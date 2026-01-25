import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double headerHeight = context.screenHeight * 0.42;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(
                        height: headerHeight,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipPath(
                                clipper: BigArcClipper(),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFc9d5ea),
                                  ),
                                ),
                              ),
                            ),

                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 400,
                                  ),
                                  child: Image.asset(
                                    'assets/images/logo_image.png',
                                    width: context.screenWidth * 0.8,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.06,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Column(
                              children: [
                                CustomButton(
                                  text: "Login",
                                  onPressed: () {
                                    context.pushNamed(Routes.login);
                                  },
                                ),

                                const SizedBox(height: 16),

                                CustomButton(
                                  text: "Create Account",
                                  isOutlined: true,
                                  onPressed: () {
                                    context.pushNamed(Routes.register);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 5),

                      SizedBox(height: context.screenHeight * 0.05),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BigArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 120);

    path.quadraticBezierTo(
      size.width / 2,
      size.height + 40,
      size.width,
      size.height - 120,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
