import 'dart:ffi';

import 'package:bmi_calculator/utils/dimentions.dart';
import 'package:bmi_calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ResultWidget extends StatelessWidget {
  final double bmiResult;
  final String textResult;
  final String textInfo;

  const ResultWidget(
      {super.key,
      required this.bmiResult,
      required this.textResult,
      required this.textInfo});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 275,
      width: (Dimentions.screenWidth - Dimentions.width10 * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              ranges: const <LinearGaugeRange>[
                LinearGaugeRange(
                  startValue: 0,
                  startWidth: 8,
                  endWidth: 8,
                  endValue: 18.5,
                  position: LinearElementPosition.outside,
                  color: Color(0xffFFC93E),
                ),
                LinearGaugeRange(
                  startValue: 18.5,
                  endValue: 25,
                  startWidth: 8,
                  endWidth: 8,
                  position: LinearElementPosition.outside,
                  color: Color(0xff0DC9AB),
                ),
                LinearGaugeRange(
                  startValue: 25,
                  endValue: 50,
                  startWidth: 8,
                  endWidth: 8,
                  position: LinearElementPosition.outside,
                  color: Color(0xffF45656),
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
            child: Text(
              textResult,
              style: TextStyle(
                color: AppColors.mainColor,
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
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
        ],
      ),
    );
  }
}
