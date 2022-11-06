import 'package:bmi_calculator/utils/dimentions.dart';
import 'package:bmi_calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ResultWidget extends StatelessWidget {
  final double bmiResult;
  final String textResult;
  final String textInfo;
  final double reduceMinWeight;
  final double reduceMaxWeight;
  final Color textResultColor;

  const ResultWidget(
      {super.key,
      required this.bmiResult,
      required this.textResult,
      required this.textInfo,
      required this.textResultColor,
      required this.reduceMinWeight,
      required this.reduceMaxWeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (Dimentions.screenWidth - Dimentions.width10 * 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  "YOUR BMI IS",
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  bmiResult.toStringAsFixed(2),
                  style: TextStyle(
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 35.0,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
          SfLinearGauge(
              minimum: 0,
              maximum: 50,
              axisTrackStyle: const LinearAxisTrackStyle(
                thickness: 1,
              ),
              useRangeColorForAxis: true,
              animateAxis: true,
              ranges: <LinearGaugeRange>[
                LinearGaugeRange(
                  startValue: 0,
                  startWidth: 8,
                  endWidth: 8,
                  endValue: 18.5,
                  position: LinearElementPosition.outside,
                  color: AppColors.yellowColor,
                ),
                LinearGaugeRange(
                  startValue: 18.5,
                  endValue: 25,
                  startWidth: 8,
                  endWidth: 8,
                  position: LinearElementPosition.outside,
                  color: AppColors.greenColor,
                ),
                LinearGaugeRange(
                  startValue: 25,
                  endValue: 50,
                  startWidth: 8,
                  endWidth: 8,
                  position: LinearElementPosition.outside,
                  color: AppColors.redColor,
                ),
              ],
              markerPointers: [
                LinearShapePointer(
                  color: AppColors.mainColor,
                  value: bmiResult,
                  offset: 8,
                  height: 25,
                  width: 25,
                ),
              ]),
          const SizedBox(
            height: 30.0,
          ),
          Align(
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                text: "You're ",
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: textResult,
                    style: TextStyle(
                      color: textResultColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              textInfo,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          textResult != "NORMAL WEIGHT!"
              ? Container(
                  padding: const EdgeInsets.all(10.0),
                  width: Dimentions.screenWidth * 0.75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10.0),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            text:
                                "A healthy weight range for your height is between ",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "${reduceMinWeight}kg",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                              ),
                              const TextSpan(
                                text: " & ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                              TextSpan(
                                text: "${reduceMaxWeight}kg",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                              const TextSpan(
                                text: ".",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
