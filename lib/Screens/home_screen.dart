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
    _minHeight = double.parse(Preferences.getMinHeight() ?? "1.00");
    _maxHeight = double.parse(Preferences.getMaxHeight() ?? "400.00");
    _minWeight = double.parse(Preferences.getMinWeight() ?? "30.00");
    _maxWeight = double.parse(Preferences.getMaxWeight() ?? "255.00");

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
    //
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
              signOut();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10.0),
              padding: const EdgeInsets.all(10.0),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.rightFromBracket,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.backgroundColor,
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
                  //Gender Card
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
                                      _genderSelected = 'Male';
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
                                            color: _genderSelected == 'Male'
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
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                              28.0,
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
                          const SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Age Card
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
              const SizedBox(height: 20.0),
              //Weight Card
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
                                      _weight = weightController.text.isEmpty
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
                                  size: 22.0,
                                  color: AppColors.secondaryColor,
                                ),
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
                        child: weightInputChanger
                            ? HorizontalPicker(
                                scrollController: weightScrollController,
                                initialPositionX: weightPosition,
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
                                onChanged: (value) {
                                  setState(() {
                                    _weight = value;
                                  });
                                },
                                height: 75.0,
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    top: 13.0, bottom: 10.0),
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      if (weightController.text.isEmpty) {
                                        _weight = -1;
                                      } else {
                                        _weight =
                                            double.parse(weightController.text);
                                      }
                                    });
                                  },
                                  controller: weightController,
                                  key: const ValueKey('Weight'),
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                  ),
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
                                    contentPadding: const EdgeInsets.all(16.0),
                                    labelText: "",
                                    labelStyle: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontSize: 15.0,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.inputFieldBorder),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: AppColors.inputFieldBorder),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: AppColors.inputFieldBorder),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              //Height Card
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
                                  "Height (cm)",
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
                                      _height = heightController.text.isEmpty
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
                                  size: 22.0,
                                  color: AppColors.secondaryColor,
                                ),
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
                                onChanged: (value) {
                                  setState(() {
                                    _height = value;
                                  });
                                },
                                height: 75.0,
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    top: 13.0, bottom: 10.0),
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      _height = heightController.text.isEmpty
                                          ? -1
                                          : double.parse(double.parse(
                                                  heightController.text)
                                              .toStringAsFixed(2));
                                    });
                                  },
                                  controller: heightController,
                                  key: const ValueKey('Height'),
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                  ),
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
                                    contentPadding: const EdgeInsets.all(16.0),
                                    labelText: "",
                                    labelStyle: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontSize: 15.0,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.inputFieldBorder),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: AppColors.inputFieldBorder),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: AppColors.inputFieldBorder),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
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
                  const SizedBox(width: 2.0),
                  Text(
                    'Save weight & height as my profile data',
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              Align(
                alignment: Alignment.center,
                child: CustomTextButton(
                  isHaveIcon: false,
                  icon: null,
                  onPressed: () {
                    dismissSnackBar();
                    if (_genderSelected == 'null') {
                      showSnackBar("Please select gender.");
                      return;
                    }

                    String errorText = "";
                    if (heightController.text.isEmpty &&
                        weightController.text.isEmpty) {
                      errorText = "Please input valid weight & height.";
                    } else if (heightController.text.isEmpty) {
                      errorText = "Please input valid height.";
                    } else if (weightController.text.isEmpty) {
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
                        actionsPadding: const EdgeInsets.only(bottom: 20.0),
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
                              size: 26.0,
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
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: const Icon(
                                Icons.refresh,
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
                      )
                          .then((value) {
                        if (!value) {
                          showSnackBar("Profile data not saved.");
                        }
                      });
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

  signOut() async {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.logout();
  }
}
