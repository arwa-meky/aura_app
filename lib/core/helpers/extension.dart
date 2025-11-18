import 'package:flutter/material.dart';

extension ContextEx on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  double get usableHeight {
    final mediaQuery = MediaQuery.of(this);
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = mediaQuery.padding.top;
    return screenHeight - appBarHeight - statusBarHeight;
  }

  void pushNamed(String routeName, {Object? arguments}) {
    Navigator.pushNamed(this, routeName, arguments: arguments);
  }

  void pushNamedAndRemoveAll(String routeName) {
    Navigator.pushNamedAndRemoveUntil(this, routeName, (route) => false);
  }

  void pushReplacmentNamed(String routeName) {
    Navigator.pushReplacementNamed(this, routeName);
  }

  void pop() {
    Navigator.pop(this);
  }

  ColorScheme get colorScheme {
    return Theme.of(this).colorScheme;
  }

  double getResponsiveFontSize(
    double baseSize, {
    required double minSize,
    required double maxSize,
  }) {
    const standardScreenWidth = 390.0;

    double scaleFactor = screenWidth / standardScreenWidth;

    double responsiveSize = baseSize * scaleFactor;

    return responsiveSize.clamp(minSize, maxSize);
  }
}
