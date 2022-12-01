import 'package:bmi_calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key,
      required this.onPressed,
      required this.btnText,
      this.width = 0.0,
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
          borderRadius: BorderRadius.circular(Dimentions.pxH * 30),
        ),
      ),
      child: Ink(
        width: width == 0.0 ? Dimentions.pxW * 200 : width,
        decoration: BoxDecoration(
          gradient: AppColors.linearGradient,
          borderRadius: BorderRadius.circular(Dimentions.pxH * 50),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: Dimentions.pxH * 13,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isHaveIcon
                  ? FaIcon(
                      icon,
                      color: Colors.white,
                      size: Dimentions.pxH * 17,
                    )
                  : Container(),
              isHaveIcon ? SizedBox(width: Dimentions.width15) : Container(),
              Text(
                btnText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimentions.pxH * 17,
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
