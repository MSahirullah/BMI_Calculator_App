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
          Image(
            image: const AssetImage(
              "assets/logo/bmi-logo-png.png",
            ),
            height: Dimentions.height10 * 6.5,
          ),
          SizedBox(
            height: Dimentions.height15,
          ),
          Text(
            "BMI CALCULATOR",
            style: TextStyle(
              color: AppColors.mainColor,
              fontSize: Dimentions.height10 * 2.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: Dimentions.pxH * 5,
          ),
          Text(
            "Let's control your fitness",
            style: TextStyle(color: AppColors.greyColor),
          ),
          SizedBox(
            height: Dimentions.height10 * 2.5,
          ),
          Container(
            margin: EdgeInsets.symmetric(
                vertical: Dimentions.height10 * 2.5,
                horizontal: Dimentions.width10 * 2.5),
            child: const Image(
              image: AssetImage(
                "assets/images/error-image.png",
              ),
            ),
          ),
          SizedBox(
            height: Dimentions.height10 * 3,
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
