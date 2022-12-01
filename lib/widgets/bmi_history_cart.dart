import 'package:bmi_calculator/models/bmi_data.dart';
import 'package:bmi_calculator/utils/dimentions.dart';
import 'package:flutter/material.dart';

class BMIHistoryCard extends StatelessWidget {
  const BMIHistoryCard({super.key, required this.bmiData});

  final BMIModel bmiData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Dimentions.pxH * 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(bmiData.date.substring(0, 11)),
            Text(bmiData.weight),
            Text(bmiData.height, textAlign: TextAlign.end),
            Text(bmiData.bmi),
          ],
        ),
        SizedBox(height: Dimentions.pxH * 5),
        Divider(height: Dimentions.pxH * 5),
      ],
    );
  }
}
