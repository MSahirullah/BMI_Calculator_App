import 'package:flutter/material.dart';

class AppColors {
  static Color mainColor = const Color(0xFF606BA1);
  static Color mainColorWithO1 = const Color(0xFFEFF0F6);
  
  static Color secondaryColor = const Color(0xFF515151);

  static Color bottomBox = const Color(0xff5E5E5E);
  static Color greyColor = const Color(0xFF9F9F9F);
  static Color inputFieldBorder = const Color.fromARGB(255, 194, 193, 193);
  static Color backgroundColor = const Color(0xFFdbdeea);

  static LinearGradient linearGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 96, 107, 161),
      Color.fromARGB(255, 132, 142, 188),
    ],
  );

  static Color redColor = const Color(0xffF45656);
  static Color greenColor = const Color(0xff0DC9AB);
  static Color yellowColor = const Color(0xffFFC93E);
}
