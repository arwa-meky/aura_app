import 'package:aura_project/core/style/colors.dart';
import 'package:flutter/material.dart';

class BuildInputLabel extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  const BuildInputLabel({
    super.key,
    required this.text,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 26, color: iconColor),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.text100Color,
            ),
          ),
        ],
      ),
    );
  }
}
