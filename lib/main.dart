import 'package:bmi_calculator/Screens/screens.dart';
import 'package:bmi_calculator/utils/colors.dart';
import 'package:bmi_calculator/widgets/scrollwidget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = {
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

    MaterialColor colorCustom = MaterialColor(0xFF606BA1, color);

    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: colorCustom,
        fontFamily: 'OpenSans',
      ),
      home: const SplashScreen(),
    );
  }
}

//tell user to how much weight that he/she needs to reduce
//
