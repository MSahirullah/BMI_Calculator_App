import 'package:flutter/material.dart';

class Dimentions {
  static MediaQueryData mediaQueryData =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  static double screenHeight = mediaQueryData.size.height; //857
  static double screenWidth = mediaQueryData.size.width; //393

  static double pxH = screenHeight / 857;
  static double height10 = screenHeight / 85.7;
  static double height15 = screenHeight / 57.13;

  static double pxW = screenWidth / 393;
  static double width10 = screenWidth / 39.3;
  static double width15 = screenWidth / 26.2;
}
