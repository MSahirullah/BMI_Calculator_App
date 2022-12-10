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
                height: Dimentions.height10 * 0.5,
              ),
              Text(
                "Let's control your fitness",
                style: TextStyle(
                  color: AppColors.greyColor,
                  fontSize: Dimentions.height10 * 1.7,
                ),
              ),
              SizedBox(
                height: Dimentions.height10 * 4,
              ),
              const Image(
                image: AssetImage(
                  "assets/images/splash-image.png",
                ),
              ),
              SizedBox(
                height: Dimentions.height10 * 7,
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
                padding: EdgeInsets.symmetric(
                  vertical: Dimentions.pxH,
                  horizontal: Dimentions.width10,
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
