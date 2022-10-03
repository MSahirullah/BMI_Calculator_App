import 'package:bmi_calculator/Screens/home_screen.dart';
import 'package:bmi_calculator/utils/dimentions.dart';
import 'package:bmi_calculator/utils/utils.dart';
import 'package:bmi_calculator/widgets/widgets.dart';

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage(
              "assets/logo/bmi-logo-png.png",
            ),
            height: 65.0,
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            "BMI CALCULATOR",
            style: TextStyle(
              color: AppColors.mainColor,
              fontSize: 25.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            "Let's control your fitness",
            style: TextStyle(color: AppColors.greyColor),
          ),
          const SizedBox(
            height: 25.0,
          ),
          const Image(
            image: AssetImage(
              "assets/images/splash-image.png",
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          CustomTextButton(
            onPressed: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const HomeScreen(),
                ),
              );
            },
            btnText: "Get Started",
          ),
        ],
      ),
    );
  }
}
