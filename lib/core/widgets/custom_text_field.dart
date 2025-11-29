import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/style/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onSuffixIcon;
  final TextInputType keyboardType;
  final Color? backgroundColor;
  final bool hasBorder;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.onSuffixIcon,
    this.keyboardType = TextInputType.text,
    this.backgroundColor,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderSide = hasBorder
        ? const BorderSide(color: AppColors.text30Color)
        : BorderSide.none;

    final borderRadius = BorderRadius.circular(12);

    return TextFormField(
      controller: controller,
      style: TextStyle(
        fontSize: context.getResponsiveFontSize(14, minSize: 10, maxSize: 16),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: context.getResponsiveFontSize(14, minSize: 10, maxSize: 16),
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: backgroundColor ?? Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),

        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: borderSide,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: borderSide,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: hasBorder
              ? const BorderSide(color: AppColors.primaryColor)
              : BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: Colors.red),
        ),

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
