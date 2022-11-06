import 'package:bmi_calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key,
      required this.onPressed,
      required this.btnText,
      this.width = 200.0,
      this.icon,
      required this.isHaveIcon,
      this.disabled = false});

  final VoidCallback onPressed;
  final String btnText;
  final IconData? icon;
  final bool isHaveIcon;
  final double width;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: disabled ? () {} : onPressed,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isHaveIcon
                  ? FaIcon(
                      icon,
                      color: Colors.white,
                      size: 16.0,
                    )
                  : Container(),
              isHaveIcon ? const SizedBox(width: 15.0) : Container(),
              Text(
                btnText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
