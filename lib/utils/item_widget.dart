import 'dart:math';

import 'package:bmi_calculator/utils/dimentions.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatefulWidget {
  final Map curItem;
  final Color backgroundColor;
  final String suffix;
  final Color initColor;

  const ItemWidget({
    required this.curItem,
    required this.backgroundColor,
    required this.suffix,
    required this.initColor,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  late List<String> textParts;
  late String leftText, rightText;

  @override
  void initState() {
    super.initState();
    int decimalCount = 1;
    num fac = pow(10, decimalCount);

    var mtext = ((widget.curItem["value"] * fac).round() / fac).toString();
    textParts = mtext.split(".");
    leftText = textParts.first;
    rightText = textParts.last;
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimentions.width10,
          vertical: Dimentions.pxH,
        ),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(Dimentions.height10),
        ),
        child: RotatedBox(
          quarterTurns: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "|",
                style: TextStyle(
                  fontSize: Dimentions.pxH * 8,
                  color: (widget.initColor == const Color(0xff9f9f9f)
                      ? widget.curItem["color"]
                      : widget.initColor),
                ),
              ),
              SizedBox(height: Dimentions.pxH * 5),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: leftText,
                      style: TextStyle(
                        fontSize: widget.curItem["fontSize"],
                        color: (widget.initColor == const Color(0xff9f9f9f)
                            ? widget.curItem["color"]
                            : widget.initColor),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: rightText == "0" ? "" : ".",
                      style: TextStyle(
                        fontSize: widget.curItem["fontSize"] - 2,
                        color: (widget.initColor == const Color(0xff9f9f9f)
                            ? widget.curItem["color"]
                            : widget.initColor),
                      ),
                    ),
                    TextSpan(
                      text: rightText == "0" ? "" : rightText,
                      style: TextStyle(
                        fontSize: widget.curItem["fontSize"] - 2,
                        color: (widget.initColor == const Color(0xff9f9f9f)
                            ? widget.curItem["color"]
                            : widget.initColor),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: widget.suffix.isEmpty ? "" : widget.suffix,
                      style: TextStyle(
                        fontSize: widget.curItem["fontSize"],
                        color: (widget.initColor == const Color(0xff9f9f9f)
                            ? widget.curItem["color"]
                            : widget.initColor),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: Dimentions.pxH * 5),
              Text(
                "|",
                style: TextStyle(
                  fontSize: Dimentions.pxH * 8,
                  color: (widget.initColor == const Color(0xff9f9f9f)
                      ? widget.curItem["color"]
                      : widget.initColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
