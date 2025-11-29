import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/style/colors.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        title: title,
        description: description,
        buttonText: buttonText,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.screenWidth * 0.05,
          vertical: context.usableHeight * 0.04,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo_name.png',
              width: context.screenWidth * 0.3,
              fit: BoxFit.contain,
            ),

            SizedBox(height: context.usableHeight * 0.04),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.getResponsiveFontSize(
                  20,
                  minSize: 18,
                  maxSize: 24,
                ),
                fontWeight: FontWeight.bold,
                color: AppColors.text100Color,
              ),
            ),

            SizedBox(height: context.usableHeight * 0.015),

            Text(
              description,
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

            SizedBox(height: context.usableHeight * 0.04),

            CustomButton(text: buttonText, onPressed: onPressed),
          ],
        ),
      ),
    );
  }
}
