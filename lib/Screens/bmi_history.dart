import 'package:bmi_calculator/services/store_service.dart';
import 'package:bmi_calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        padding: EdgeInsets.all(20.0),
        child: Card(
          
        ),
      ),
    );
  }

   void readName() async {
    final prefs = await SharedPreferences.getInstance();
    String history;
    setState(() {
      history = StoreServices(sharedPreferences: prefs).retriveData('', 'name');
    });
  }
}
