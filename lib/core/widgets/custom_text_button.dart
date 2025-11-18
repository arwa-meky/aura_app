import 'package:aura_project/core/helpers/extension.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.screenWidth * 0.03),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: context.getResponsiveFontSize(14, minSize: 12, maxSize: 16),
        ),
      ),
    );
  }
}
