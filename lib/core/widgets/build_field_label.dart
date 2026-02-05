import 'package:flutter/material.dart';

Widget buildFieldLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Colors.black87,
      ),
    ),
  );
}
