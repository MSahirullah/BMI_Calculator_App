import 'dart:async';

import 'package:age_calculator/age_calculator.dart';
import 'package:bmi_calculator/Screens/screens.dart';
import 'package:bmi_calculator/provider/google_sign_in.dart';
import 'package:bmi_calculator/services/database.dart';
import 'package:bmi_calculator/services/preferences.dart';
import 'package:bmi_calculator/utils/utils.dart';
import 'package:bmi_calculator/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.auth, required this.fireStore});

  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  late StreamSubscription<bool> keyboardSubscription;

  String _genderSelected = 'null';
  int _age = 20;

  double _minWeight = 1;
  double _maxWeight = 400;
  double _weight = 65;

  double _minHeight = 30;
  double _maxHeight = 255;
  double _height = 170;

  double bmiResult = 0.0;
  String _textResult = "";
  String _textInfo = "";
  Color _textResultColor = AppColors.mainColor;
  double _reduceMinWeight = 0.0;
  double _reduceMaxWeight = 0.0;

  IconData weighIcon = Icons.edit;
  IconData heightIcon = Icons.edit;

  bool weightInputChanger = true;
  bool heightInputChanger = true;

  int weightPosition = 128;
  int heightPosition = 140;

  bool _saveMyData = true;

  Timer? _timer;

  FixedExtentScrollController weightScrollController =
      FixedExtentScrollController();
  FixedExtentScrollController heightScrollController =
      FixedExtentScrollController();

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _minHeight = double.parse(Preferences.getMinHeight() ?? "30.00");
    _maxHeight = double.parse(Preferences.getMaxHeight() ?? "255.00");
    _minWeight = double.parse(Preferences.getMinWeight() ?? "1.00");
    _maxWeight = double.parse(Preferences.getMaxWeight() ?? "400.00");

    _genderSelected = Preferences.getGender() ?? "";
    heightController.text = Preferences.getHeight() ?? "";
    _weight = Preferences.getWeight() != null && Preferences.getWeight() != ""
        ? double.parse(Preferences.getWeight()!)
        : 65.00;

    if (!(_weight % 1 == 0.5 || _weight % 1 == 0)) {
      weightInputChanger = false;
    }

    _height = Preferences.getHeight() != null && Preferences.getHeight() != ""
        ? double.parse(Preferences.getHeight()!)
        : 170.00;

    if (!(_height % 1 == 0)) {
      heightInputChanger = false;
    }

    weightController.text = _weight.toStringAsFixed(2);
    heightController.text = _height.toStringAsFixed(2);

    weightPosition = ((_weight - 1) * 2).toInt();
    heightPosition = (_height - _minHeight).toInt();

    if (Preferences.getDOB() != null && Preferences.getDOB() != "") {
      DateTime dob = DateFormat('y-m-d').parse(Preferences.getDOB()!);
      DateDuration duration = AgeCalculator.age(dob);
      if (duration.years != 0) {
        _age = duration.years;
      } else {
        _age = 1;
      }
    } else {
      _age = 25;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(
        auth: widget.auth,
        fireStore: widget.fireStore,
      ),
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
        actions: [
          GestureDetector(
            onTap: () {
              showLoading(_timer);
              signOut();
              hideLoading(_timer);
              setState(() {});
            },
            child: Container(
              margin: EdgeInsets.only(right: Dimentions.width10),
              padding: EdgeInsets.symmetric(
                  vertical: Dimentions.height10,
                  horizontal: Dimentions.width10),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.rightFromBracket,
                  color: Colors.white,
                  size: Dimentions.height10 * 2,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: Dimentions.height10 * 2,
            horizontal: Dimentions.width10 * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Gender Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimentions.height10),
                    ),
                    elevation: 1.0,
                    child: Container(
                      height: Dimentions.height10 * 15,
                      width:
                          (Dimentions.screenWidth - (Dimentions.width10 * 6)) /
                              2,
                      padding: EdgeInsets.symmetric(
                          vertical: Dimentions.height10,
                          horizontal: Dimentions.width10),
                      child: Column(
                        children: [
                          Text(
                            "GENDER",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Dimentions.pxH * 18,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                          SizedBox(
                            height: Dimentions.height15,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimentions.pxW * 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _genderSelected = 'Male';
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              Dimentions.pxH * 28,
                                            ),
                                          ),
                                          border: Border.all(
                                            color: _genderSelected == 'Male'
                                                ? AppColors.mainColor
                                                : Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          maxRadius: Dimentions.pxH * 26,
                                          child: ClipOval(
                                            child: Image.asset(
                                              'assets/images/male.png',
                                              fit: BoxFit.cover,
                                              width: Dimentions.width10 * 10,
                                              height: Dimentions.height10 * 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: Dimentions.pxH * 4,
                                      ),
                                      Text(
                                        "Male",
                                        style: TextStyle(
                                          fontSize: Dimentions.pxH * 15,
                                          fontWeight: FontWeight.w500,
                                          color: _genderSelected == 'Male'
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
                                      _genderSelected = 'Female';
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              Dimentions.pxH * 28,
                                            ),
                                          ),
                                          border: Border.all(
                                            color: _genderSelected == 'Female'
                                                ? AppColors.mainColor
                                                : Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          maxRadius: Dimentions.pxH * 26,
                                          child: ClipOval(
                                            child: Image.asset(
                                              'assets/images/female.png',
                                              fit: BoxFit.cover,
                                              width: Dimentions.width10 * 10,
                                              height: Dimentions.height10 * 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: Dimentions.pxH * 4,
                                      ),
                                      Text(
                                        "Female",
                                        style: TextStyle(
                                          fontSize: Dimentions.pxH * 15,
                                          fontWeight: FontWeight.w500,
                                          color: _genderSelected == 'Female'
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
                          SizedBox(
                            height: Dimentions.pxH * 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Age Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimentions.height10),
                    ),
                    elevation: 1.0,
                    child: Container(
                      height: Dimentions.height10 * 15,
                      width:
                          (Dimentions.screenWidth - (Dimentions.width10 * 6)) /
                              2,
                      padding: EdgeInsets.symmetric(
                        vertical: Dimentions.height10,
                        horizontal: Dimentions.pxW * 9,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "AGE",
                            style: TextStyle(
                              fontSize: Dimentions.pxH * 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                          SizedBox(height: Dimentions.height10 * 3),
                          Row(
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
                                    value: _age.toDouble(),
                                    max: 100,
                                    min: 1,
                                    label: _age.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _age = value.toInt();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Dimentions.height15,
                          ),
                          Text(
                            _age.toInt().toString(),
                            style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: Dimentions.pxH * 18,
                            ),
                          ),
                          SizedBox(
                            height: Dimentions.pxH * 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimentions.height10 * 2),
              //Weight Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimentions.height10),
                ),
                elevation: 1.0,
                child: Container(
                  width: double.infinity,
                  height: Dimentions.height10 * 15,
                  padding: EdgeInsets.symmetric(
                      vertical: Dimentions.height10,
                      horizontal: Dimentions.width10),
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
                                    fontSize: Dimentions.pxH * 18,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  if (weightInputChanger) {
                                    setState(() {
                                      weightController.text =
                                          _weight.toStringAsFixed(2);
                                      weighIcon = Icons.monitor_weight_outlined;
                                      weightInputChanger = !weightInputChanger;
                                    });
                                  } else {
                                    setState(() {
                                      _weight = weightController.text.isEmpty ||
                                              !RegExp(r'^(\d{1,5}|\d{0,5}\.\d{1,2})$')
                                                  .hasMatch(
                                                      weightController.text)
                                          ? -1
                                          : double.parse(double.parse(
                                                  weightController.text)
                                              .toStringAsFixed(2));

                                      if (_weight >= _minWeight &&
                                          _weight <= _maxWeight) {
                                        weighIcon = Icons.edit;
                                        weightInputChanger =
                                            !weightInputChanger;
                                      } else {
                                        unfocus();
                                        dismissSnackBar();
                                        showSnackBar(
                                            "Please input valid weight.");
                                        return;
                                      }
                                    });
                                  }
                                  weightPosition = ((_weight - 1) * 2).toInt();
                                },
                                child: Icon(
                                  weighIcon,
                                  size: Dimentions.pxH * 22,
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Dimentions.height15,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimentions.pxH * 8,
                        ),
                        child: weightInputChanger
                            ? HorizontalPicker(
                                scrollController: weightScrollController,
                                initialPositionX: 128,
                                minValue: _minWeight,
                                initialPosition: InitialPosition.center,
                                maxValue: _maxWeight,
                                divisions:
                                    ((_maxWeight - _minWeight) * 2).toInt(),
                                suffix: " kg",
                                cursorColor: AppColors.mainColor,
                                showCursor: true,
                                backgroundColor: Colors.transparent,
                                activeItemTextColor: AppColors.mainColor,
                                passiveItemsTextColor: AppColors.greyColor,
                                initValue: 65,
                                onChanged: (value) {
                                  setState(() {
                                    _weight = value;
                                  });
                                },
                                height: Dimentions.height10 * 7.58,
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                    top: Dimentions.pxH * 13,
                                    bottom: Dimentions.height10),
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      if (weightController.text.isEmpty ||
                                          !RegExp(r'^(\d{1,5}|\d{0,5}\.\d{1,2})$')
                                              .hasMatch(
                                                  weightController.text)) {
                                        _weight = -1;
                                      } else {
                                        _weight =
                                            double.parse(weightController.text);
                                      }
                                    });
                                  },
                                  controller: weightController,
                                  key: const ValueKey('Weight'),
                                  style: TextStyle(
                                      fontSize: Dimentions.pxH * 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondaryColor),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9.]')),
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    suffixText: "kg",
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: Dimentions.pxW * 16,
                                        vertical: Dimentions.pxH * 16),
                                    labelText: "",
                                    labelStyle: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontSize: Dimentions.height10 * 1.5,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.inputFieldBorder),
                                      borderRadius: BorderRadius.circular(
                                          Dimentions.pxH * 8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimentions.pxH * 8),
                                      borderSide: BorderSide(
                                          color: AppColors.inputFieldBorder),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimentions.pxH * 8),
                                      borderSide: BorderSide(
                                          color: AppColors.inputFieldBorder),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(
                        height: Dimentions.pxH * 8,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimentions.height10 * 2),
              //Height Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimentions.height10),
                ),
                elevation: 1.0,
                child: Container(
                  width: double.infinity,
                  height: Dimentions.height10 * 15,
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimentions.width10,
                      vertical: Dimentions.height10),
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
                                    fontSize: Dimentions.pxH * 18,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  if (heightInputChanger) {
                                    setState(() {
                                      heightController.text =
                                          _height.toStringAsFixed(2);
                                      heightIcon =
                                          Icons.accessibility_new_rounded;
                                      heightInputChanger = !heightInputChanger;
                                    });
                                  } else {
                                    setState(() {
                                      _height = heightController.text.isEmpty ||
                                              !RegExp(r'^(\d{1,5}|\d{0,5}\.\d{1,2})$')
                                                  .hasMatch(
                                                      heightController.text)
                                          ? -1
                                          : double.parse(double.parse(
                                                  heightController.text)
                                              .toStringAsFixed(2));

                                      if (_height >= _minHeight &&
                                          _height <= _maxHeight) {
                                        heightIcon = Icons.edit;
                                        heightInputChanger =
                                            !heightInputChanger;
                                      } else {
                                        unfocus();
                                        dismissSnackBar();
                                        showSnackBar(
                                            "Please input valid height.");

                                        return;
                                      }
                                    });
                                  }
                                  heightPosition =
                                      (_height - _minHeight).toInt();
                                },
                                child: Icon(
                                  heightIcon,
                                  size: Dimentions.pxH * 22,
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Dimentions.pxH * 15,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimentions.pxW * 8,
                        ),
                        child: heightInputChanger
                            ? HorizontalPicker(
                                scrollController: heightScrollController,
                                initialPositionX: heightPosition,
                                minValue: _minHeight,
                                initialPosition: InitialPosition.center,
                                maxValue: _maxHeight,
                                divisions: (_maxHeight - _minHeight).toInt(),
                                suffix: " cm",
                                cursorColor: AppColors.mainColor,
                                showCursor: true,
                                backgroundColor: Colors.transparent,
                                activeItemTextColor: AppColors.mainColor,
                                passiveItemsTextColor: AppColors.greyColor,
                                initValue: _height,
                                onChanged: (value) {
                                  setState(() {
                                    _height = value;
                                  });
                                },
                                height: Dimentions.height10 * 7.58,
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                    top: Dimentions.pxH * 13,
                                    bottom: Dimentions.height10),
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      _height = heightController.text.isEmpty ||
                                              !RegExp(r'^(\d{1,5}|\d{0,5}\.\d{1,2})$')
                                                  .hasMatch(
                                                      heightController.text)
                                          ? -1
                                          : double.parse(double.parse(
                                                  heightController.text)
                                              .toStringAsFixed(2));
                                    });
                                  },
                                  controller: heightController,
                                  key: const ValueKey('Height'),
                                  style: TextStyle(
                                      fontSize: Dimentions.pxH * 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondaryColor),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9.]')),
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    suffixText: "cm",
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: Dimentions.pxW * 16,
                                        vertical: Dimentions.pxH * 16),
                                    labelText: "",
                                    labelStyle: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontSize: Dimentions.height15,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.inputFieldBorder),
                                      borderRadius: BorderRadius.circular(
                                          Dimentions.pxH * 8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimentions.pxH * 8),
                                      borderSide: BorderSide(
                                          color: AppColors.inputFieldBorder),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimentions.pxH * 8),
                                      borderSide: BorderSide(
                                          color: AppColors.inputFieldBorder),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(
                        height: Dimentions.pxH * 8,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimentions.height15),
              //Save my Data
              Row(
                children: [
                  Checkbox(
                    value: _saveMyData,
                    onChanged: (value) {
                      setState(() {
                        _saveMyData = value!;
                      });
                    },
                  ),
                  SizedBox(width: Dimentions.pxW * 2),
                  Text(
                    'Save as my profile data',
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: Dimentions.pxH * 15,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimentions.height10 * 2.5),
              Align(
                alignment: Alignment.center,
                child: CustomTextButton(
                  isHaveIcon: false,
                  icon: null,
                  onPressed: () {
                    dismissSnackBar();
                    if (_genderSelected == 'null' || _genderSelected == '') {
                      showSnackBar("Please select gender.");
                      return;
                    }

                    String errorText = "";
                    if (heightController.text.isEmpty &&
                        weightController.text.isEmpty) {
                      errorText = "Please input valid weight & height.";
                    } else if (heightController.text.isEmpty ||
                        !RegExp(r'^(\d{1,5}|\d{0,5}\.\d{1,2})$')
                            .hasMatch(heightController.text)) {
                      errorText = "Please input valid height.";
                    } else if (weightController.text.isEmpty ||
                        !RegExp(r'^(\d{1,5}|\d{0,5}\.\d{1,2})$')
                            .hasMatch(weightController.text)) {
                      errorText = "Please input valid weight.";
                    } else {
                      double tempHeight = double.parse(heightController.text);
                      double tempWeight = double.parse(weightController.text);

                      if ((tempHeight < _minHeight ||
                              tempHeight > _maxHeight) &&
                          (tempWeight < _minWeight ||
                              tempWeight > _maxWeight)) {
                        errorText = "Please input valid weight & height.";
                      } else if (tempHeight < _minHeight ||
                          tempHeight > _maxHeight) {
                        errorText = "Please input valid height.";
                      } else if (tempWeight < _minWeight ||
                          tempWeight > _maxWeight) {
                        errorText = "Please input valid weight.";
                      }
                    }
                    unfocus();
                    if (errorText.isNotEmpty) {
                      showSnackBar(errorText);
                      return;
                    }

                    double w = _weight != 0.0 ? _weight : 0.00;
                    double h = _height != 0 ? _height : 0.00;

                    setState(() {
                      if ((h <= 0) || (w <= 0)) {
                        bmiResult = 0.0;
                        _textResult = " ";
                        _textInfo = " ";
                        return;
                        //
                      } else {
                        h = h / 100;
                        bmiResult = w / (h * h);

                        _reduceMinWeight =
                            double.parse((18.5 * h * h).toStringAsFixed(1));
                        _reduceMaxWeight =
                            double.parse((24.9 * h * h).toStringAsFixed(1));

                        if (bmiResult > 30) {
                          _textResult = "OBESITY!";
                          _textInfo = "Obesity BMI ranges \nabove 30";
                          _textResultColor = const Color(0xffF45656);
                          //
                        } else if (bmiResult > 25) {
                          _textResult = "OVER WEIGHT!";
                          _textInfo =
                              "Over weight BMI ranges \nbetween 25 - 29.9";
                          _textResultColor = const Color(0xffF45656);
                          //
                        } else if (bmiResult >= 18.5 && bmiResult <= 25) {
                          _textResult = "NORMAL WEIGHT!";
                          _textInfo =
                              "Normal weight BMI ranges \nbetween 18.5 - 24.9";
                          _textResultColor = const Color(0xff0DC9AB);
                          //
                        } else {
                          _textResult = "UNDER WEIGHT!";
                          _textInfo = "Under weight BMI ranges \nbelow 18.5";
                          _textResultColor = const Color(0xffffae00);
                          //
                        }
                      }
                    });

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: ResultWidget(
                          reduceMaxWeight: _reduceMaxWeight,
                          reduceMinWeight: _reduceMinWeight,
                          bmiResult: bmiResult,
                          textResult: _textResult,
                          textInfo: _textInfo,
                          textResultColor: _textResultColor,
                        ),
                        actionsPadding:
                            EdgeInsets.only(bottom: Dimentions.height10 * 2),
                        actionsAlignment: MainAxisAlignment.spaceAround,
                        actions: <Widget>[
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      BMIHistoryScreen(
                                    auth: widget.auth,
                                    fireStore: widget.fireStore,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.history,
                              color: AppColors.secondaryColor,
                              size: Dimentions.pxH * 26,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _saveMyData = true;
                                bmiResult = 0.0;
                                _textResult = "";
                                _textInfo = "";
                              });
                              Navigator.of(context).pop();
                            },
                            icon: Container(
                              height: Dimentions.height10 * 5,
                              width: Dimentions.width10 * 5,
                              decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimentions.height10 * 3)),
                              child: Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: Dimentions.pxH * 26,
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
                              size: Dimentions.pxH * 26,
                            ),
                          ),
                        ],
                      ),
                    );

                    Database(auth: widget.auth, fireStore: widget.fireStore)
                        .addBMIData(
                      uid: user.uid,
                      weight: _weight.toStringAsFixed(2),
                      height: _height.toStringAsFixed(2),
                      bmi: bmiResult.toStringAsFixed(2),
                    )
                        .then((value) async {
                      hideLoading(_timer);

                      if (value == "0") {
                        showSnackBar(
                            "Something went wrong. Please try again later.");
                      }
                    });

                    //saveData
                    if (_saveMyData) {
                      Preferences.setBMIData(_height.toStringAsFixed(2),
                          _weight.toStringAsFixed(2));
                      Database(auth: widget.auth, fireStore: widget.fireStore)
                          .updateUserBMIData(
                              uid: user.uid,
                              weight: _weight.toStringAsFixed(2),
                              height: _height.toStringAsFixed(2),
                              gender: _genderSelected,
                              dob: DateFormat('yyyy-MM-dd').format(DateTime(
                                  DateTime.now().year - _age,
                                  DateTime.now().month,
                                  DateTime.now().day)))
                          .then((value) {
                        if (!value) {
                          showSnackBar("Profile data not saved.");
                        } else {
                          Preferences.setGenderAndDoB(
                              _genderSelected,
                              DateFormat('yyyy-MM-dd').format(DateTime(
                                  DateTime.now().year - _age,
                                  DateTime.now().month,
                                  DateTime.now().day)));
                        }
                      });
                    }
                    unfocus();
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

  unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  signOut() async {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.logout(context);
    setState(() {});
  }
}
