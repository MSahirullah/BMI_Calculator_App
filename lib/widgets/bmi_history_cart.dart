import 'package:bmi_calculator/models/bmi_data.dart';
import 'package:flutter/material.dart';

class BMIHistoryCard extends StatelessWidget {
  const BMIHistoryCard({super.key, required this.bmiData});

  final BMIModel bmiData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5.0),
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
        const SizedBox(height: 5.0),
        const Divider(height: 5),
      ],
    );
  }
}
