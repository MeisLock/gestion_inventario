import 'package:flutter/material.dart';

Widget buildLabel(String text, ColorScheme colorScheme) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface, 
      ),
    ),
  );
}
