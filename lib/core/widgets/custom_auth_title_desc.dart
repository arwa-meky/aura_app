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
              20,
              minSize: 18,
              maxSize: 24,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.usableHeight * 0.01),
        Text(
          description,
          style: TextStyle(
            fontSize: context.getResponsiveFontSize(
              13,
              minSize: 10,
              maxSize: 18,
            ),
            color: AppColors.textBodyColor,
          ),
        ),
      ],
    );
  }
}
