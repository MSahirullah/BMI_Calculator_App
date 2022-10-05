import 'package:flutter/material.dart';

class AppColors {
  static Color mainColor = const Color(0xFF606BA1);
  static Color secondaryColor = const Color(0xFF515151);
  static Color greyColor = const Color(0xFF9F9F9F);

  static LinearGradient linearGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 96, 107, 161),
      Color.fromARGB(255, 132, 142, 188),
    ],
  );
}
