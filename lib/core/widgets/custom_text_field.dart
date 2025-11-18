import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/style/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIcon;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.onSuffixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(context.screenWidth * 0.04);

    final textStyle = TextStyle(
      fontSize: context.getResponsiveFontSize(16, minSize: 14, maxSize: 18),
    );

    final hintStyle = TextStyle(
      color: Colors.grey,
      fontSize: context.getResponsiveFontSize(15, minSize: 13, maxSize: 17),
      fontWeight: FontWeight.w500,
    );

    return TextFormField(
      controller: controller,
      style: textStyle,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        filled: true,
        fillColor: const Color(0xffFDFDFF),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.text30Color),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.text30Color),
          borderRadius: borderRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor),
          borderRadius: borderRadius,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: borderRadius,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: borderRadius,
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(onPressed: onSuffixIcon, icon: Icon(suffixIcon))
            : null,
      ),
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
