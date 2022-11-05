import 'package:bmi_calculator/utils/utils.dart';
import 'package:flutter/material.dart';

class BMIHistoryScreen extends StatefulWidget {
  const BMIHistoryScreen({super.key});

  @override
  State<BMIHistoryScreen> createState() => _BMIHistoryScreenState();
}

class _BMIHistoryScreenState extends State<BMIHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        title: const Text(
          "History",
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: const Card(),
      ),
    );
  }

  void readName() async {
    // final prefs = await SharedPreferences.getInstance();
    setState(() {});
  }
}
