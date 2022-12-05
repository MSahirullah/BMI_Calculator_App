import 'package:flutter/material.dart';

class AppColors {
  static Map<int, Color> appMainColor = {
    50: AppColors.mainColor.withOpacity(.1),
    100: AppColors.mainColor.withOpacity(.2),
    200: AppColors.mainColor.withOpacity(.3),
    300: AppColors.mainColor.withOpacity(.4),
    400: AppColors.mainColor.withOpacity(.5),
    500: AppColors.mainColor.withOpacity(.6),
    600: AppColors.mainColor.withOpacity(.7),
    700: AppColors.mainColor.withOpacity(.8),
    800: AppColors.mainColor.withOpacity(.9),
    900: AppColors.mainColor.withOpacity(1),
  };

  static MaterialColor customAppColor = MaterialColor(0xFF606BA1, appMainColor);

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
      Color(0xFF606BA1),
      Color(0xFF848EBC),
    ],
  );

  static Color redColor = const Color(0xffF45656);
  static Color greenColor = const Color(0xff0DC9AB);
  static Color yellowColor = const Color(0xffFFC93E);
}
