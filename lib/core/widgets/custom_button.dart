import 'package:aura_project/core/helpers/extension.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final backgroundColor = isOutlined ? Colors.white : primaryColor;
    final textColor = isOutlined ? primaryColor : Colors.white;
    final border = isOutlined ? Border.all(color: primaryColor) : null;

    return Container(
      height: context.usableHeight * 0.06,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(context.screenWidth * 0.8),
        border: border,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        elevation: 0,
        highlightElevation: 0,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: context.getResponsiveFontSize(
              16,
              minSize: 14,
              maxSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
