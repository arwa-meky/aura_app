import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/style/colors.dart';
import 'package:flutter/material.dart';

class CustomAuthTitleDesc extends StatelessWidget {
  final String title;
  final String description;
  const CustomAuthTitleDesc({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: context.getResponsiveFontSize(
              24,
              minSize: 20,
              maxSize: 28,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.usableHeight * 0.01),
        Text(
          description,
          style: TextStyle(
            fontSize: context.getResponsiveFontSize(
              15,
              minSize: 13,
              maxSize: 18,
            ),
            color: AppColors.textBodyColor,
          ),
        ),
      ],
    );
  }
}
