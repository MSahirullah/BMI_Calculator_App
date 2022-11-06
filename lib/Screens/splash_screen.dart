import 'package:bmi_calculator/provider/google_sign_in.dart';
import 'package:bmi_calculator/utils/utils.dart';
import 'package:bmi_calculator/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.btnDisableStatus = false});

  final bool btnDisableStatus;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
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
                disabled: widget.btnDisableStatus,
                isHaveIcon: true,
                icon: FontAwesomeIcons.google,
                btnText: "Sign in with Google",
                width: Dimentions.screenWidth * 0.65,
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();
                },
              ),
            ],
          ),
          Visibility(
            visible: widget.btnDisableStatus,
            child: Positioned(
              bottom: 0,
              child: Container(
                color: AppColors.redColor,
                width: Dimentions.screenWidth,
                padding: const EdgeInsets.symmetric(
                  vertical: 1.0,
                  horizontal: 10.0,
                ),
                child: const Text(
                  "No Internet connection.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
