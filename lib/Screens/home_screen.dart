import 'dart:convert';

import 'package:bmi_calculator/services/store_service.dart';
import 'package:bmi_calculator/utils/dimentions.dart';
import 'package:bmi_calculator/utils/utils.dart';
import 'package:bmi_calculator/widgets/result_widget.dart';
import 'package:bmi_calculator/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _genderSelected = 'null';
  double _age = 20;
  double _weight = 220;
  double _height = 150;
  bool _saveAsProfileData = true;
  double bmiResult = 0.0;
  String _textResult = "";
  String _textInfo = "";
  int _result = 0;

  FixedExtentScrollController weightScrollController =
      FixedExtentScrollController();
  FixedExtentScrollController heightScrollController =
      FixedExtentScrollController();

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    weightController.text = "0.0";
    heightController.text = "0.0";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        title: const Text(
          "BMI Calculator",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(244, 255, 255, 255),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(
            20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 1.0,
                    child: Container(
                      height: 145.0,
                      width:
                          (Dimentions.screenWidth - (Dimentions.width10 * 6)) /
                              2,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            "GENDER",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _genderSelected = 'male';
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                              28.0,
                                            ),
                                          ),
                                          border: Border.all(
                                            color: _genderSelected == 'male'
                                                ? AppColors.mainColor
                                                : Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          maxRadius: 26.0,
                                          child: ClipOval(
                                            child: Image.asset(
                                              'assets/images/male.png',
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        "Male",
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color: _genderSelected == 'male'
                                              ? AppColors.secondaryColor
                                              : AppColors.greyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _genderSelected = 'female';
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                              28.0,
                                            ),
                                          ),
                                          border: Border.all(
                                            color: _genderSelected == 'female'
                                                ? AppColors.mainColor
                                                : Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          maxRadius: 26.0,
                                          child: ClipOval(
                                            child: Image.asset(
                                              'assets/images/female.png',
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        "Female",
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color: _genderSelected == 'female'
                                              ? AppColors.secondaryColor
                                              : AppColors.greyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 1.0,
                    child: Container(
                      height: 145,
                      width:
                          (Dimentions.screenWidth - (Dimentions.width10 * 6)) /
                              2,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 9.0,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "AGE",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SliderTheme(
                                  data: SliderThemeData(
                                    overlayShape: SliderComponentShape.noThumb,
                                    activeTrackColor:
                                        AppColors.mainColor.withOpacity(0.9),
                                    thumbColor: AppColors.mainColor,
                                    inactiveTrackColor:
                                        AppColors.mainColor.withOpacity(0.3),
                                  ),
                                  child: SizedBox(
                                    width: (Dimentions.screenWidth -
                                            (Dimentions.width10 * 10)) /
                                        2,
                                    child: Slider(
                                      value: _age,
                                      max: 100,
                                      min: 1,
                                      label: _age.round().toString(),
                                      onChanged: (double value) {
                                        setState(() {
                                          _age = value;
                                          // weightScrollController.animateToItem(
                                          //     _weight.toInt()*2,
                                          //     duration: Duration(seconds: 1),
                                          //     curve: Curves.linear);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            _age.toInt().toString(),
                            style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 1.0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "WEIGHT (kg)",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 0,
                              child: Icon(
                                Icons.edit,
                                size: 22.0,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: HorizontalPicker(
                          scrollController: weightScrollController,
                          initialPositionX: 0.0,
                          minValue: 1,
                          initialPosition: InitialPosition.center,
                          maxValue: _weight,
                          divisions: 440,
                          suffix: " kg",
                          cursorColor: AppColors.mainColor,
                          showCursor: true,
                          backgroundColor: Colors.transparent,
                          activeItemTextColor: AppColors.mainColor,
                          passiveItemsTextColor: AppColors.greyColor,
                          onChanged: (value) {
                            setState(() {
                              _weight = value;
                            });
                          },
                          height: 75.0,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 1.0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "HEIGHT (cm)",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 0,
                              child: Icon(
                                Icons.edit,
                                size: 22.0,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: HorizontalPicker(
                          scrollController: heightScrollController,
                          initialPositionX: 0.0,
                          minValue: 50,
                          initialPosition: InitialPosition.center,
                          maxValue: 220,
                          divisions: 170,
                          suffix: " cm",
                          cursorColor: AppColors.mainColor,
                          showCursor: true,
                          backgroundColor: Colors.transparent,
                          activeItemTextColor: AppColors.mainColor,
                          passiveItemsTextColor: AppColors.greyColor,
                          onChanged: (value) {
                            setState(() {
                              _height = value;
                            });
                          },
                          height: 75.0,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 80.0,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Align(
                alignment: Alignment.center,
                child: CustomTextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    if (_genderSelected == 'null') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select gender."),
                        ),
                      );
                      return;
                    }

                    double w = _weight != 0.0 ? _weight : 0.00;
                    double h = _height != 0 ? _height : 0.00;

                    setState(() {
                      h = h / 100;
                      bmiResult = w / (h * h);

                      if ((h <= 0) || (w <= 0)) {
                        bmiResult = 0.0;
                        _textResult = " ";
                        _textInfo = " ";
                        _result = 0;
                      } else if (bmiResult > 25) {
                        _textResult = "You're OVER WEIGHT!";
                        _textInfo = "Over weight BMI ranges \nabove 25";

                        _result = 1;
                      } else if (bmiResult >= 18.5 && bmiResult <= 25) {
                        _textResult = "You're NORMAL WEIGHT!";
                        _textInfo =
                            "Normal weight BMI ranges \nbetween 18.5 - 24.9";

                        _result = 2;
                      } else {
                        _textResult = "You're UNDER WEIGHT!";
                        _textInfo = "Under weight BMI ranges \nbelow 18.5";
                        _result = 3;
                      }
                    });
                    if (_result != 0) {
                      if (_saveAsProfileData) {}

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: ResultWidget(
                              bmiResult: bmiResult,
                              textResult: _textResult,
                              textInfo: _textInfo),
                          actionsPadding: const EdgeInsets.only(bottom: 20.0),
                          actionsAlignment: MainAxisAlignment.spaceAround,
                          actions: <Widget>[
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.refresh,
                                color: AppColors.secondaryColor,
                                size: 26.0,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _genderSelected = 'null';
                                  _age = 20;
                                  _weight = 70;
                                  _height = 150;
                                  _saveAsProfileData = false;
                                  bmiResult = 0.0;
                                  _textResult = "";
                                  _textInfo = "";
                                  _result = 0;
                                });
                                Navigator.of(context).pop();
                              },
                              icon: Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Icon(
                                  Icons.home,
                                  color: Colors.white,
                                  size: 26.0,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await Share.share(
                                    'My BMI is ${bmiResult.toStringAsFixed(2)}.');
                              },
                              icon: Icon(
                                Icons.share,
                                color: AppColors.secondaryColor,
                                size: 26.0,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  btnText: "Calculate",
                  width: Dimentions.screenWidth * 0.75,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void saveBMIData() async {
    final prefs = await SharedPreferences.getInstance();
    StoreServices(sharedPreferences: prefs).saveData(
        'list',
        'bmi',
        jsonEncode({
          "name": "",
        }));
  }
}
