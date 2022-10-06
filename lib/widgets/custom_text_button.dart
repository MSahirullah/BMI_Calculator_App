import 'package:bmi_calculator/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key, required this.onPressed, required this.btnText, this.width = 200.0});

  final VoidCallback onPressed;
  final String btnText;
  final double width;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        elevation: 2.0,
        padding: const EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Ink(
        width: width,
        decoration: BoxDecoration(
          gradient: AppColors.linearGradient,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 13.0,
          ),
          alignment: Alignment.center,
          child: Text(
            btnText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}