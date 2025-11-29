import 'package:aura_project/core/style/colors.dart';
import 'package:flutter/material.dart';

class BuildInputLabel extends StatelessWidget {
  final String text;
  final IconData icon;
  const BuildInputLabel({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.text100Color),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.text100Color,
            ),
          ),
        ],
      ),
    );
  }
}
