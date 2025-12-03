import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ClipPath(
            clipper: BigArcClipper(),
            child: Container(
              height: context.screenHeight * 0.38,
              width: double.infinity,
              decoration: const BoxDecoration(color: Color(0xFFD6E4F0)),
            ),
          ),

          SafeArea(
            bottom: false,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: context.screenHeight * 0.02),

                  Image.asset(
                    'assets/images/logo_image.png',
                    width: context.screenWidth * 0.8,
                    fit: BoxFit.contain,
                  ),

                  const Spacer(),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.06,
                    ),
                    child: Column(
                      children: [
                        CustomButton(
                          text: "Login",
                          onPressed: () {
                            context.pushNamed(Routes.login);
                          },
                        ),

                        SizedBox(height: context.usableHeight * 0.02),

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

                  SizedBox(height: context.screenHeight * 0.4),
                ],
              ),
            ),
          ),
        ],
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
      size.height + 100,
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
