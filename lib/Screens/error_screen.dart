import 'package:bmi_calculator/Screens/screens.dart';
import 'package:bmi_calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bmi_calculator/widgets/widgets.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

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
          Container(
            margin: const EdgeInsets.all(25.0),
            child: const Image(
              image: AssetImage(
                "assets/images/error-image.png",
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          CustomTextButton(
            icon: FontAwesomeIcons.arrowRotateLeft,
            isHaveIcon: true,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LoadingScreen(),
                ),
              );
            },
            btnText: "Try again",
            width: Dimentions.screenWidth * 0.65,
          ),
        ],
      ),
    );
  }
}
