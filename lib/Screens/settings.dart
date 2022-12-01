import 'dart:async';

import 'package:bmi_calculator/Screens/screens.dart';
import 'package:bmi_calculator/services/database.dart';
import 'package:bmi_calculator/services/preferences.dart';
import 'package:bmi_calculator/utils/utils.dart';
import 'package:bmi_calculator/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen(
      {super.key, required this.auth, required this.fireStore});

  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController minHeightController = TextEditingController();
  TextEditingController maxHeightController = TextEditingController();
  TextEditingController minWeightController = TextEditingController();
  TextEditingController maxWeightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    minWeightController.text = Preferences.getMinWeight() ?? "";
    maxWeightController.text = Preferences.getMaxWeight() ?? "";
    minHeightController.text = Preferences.getMinHeight() ?? "";
    maxHeightController.text = Preferences.getMaxHeight() ?? "";

    final reg = RegExp(r'^(\d{1,3}|\d{0,3}\.\d{1,2})$');

    return Provider.of<InternetConnectionStatus>(context) !=
            InternetConnectionStatus.disconnected
        ? WillPopScope(
            onWillPop: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    auth: widget.auth,
                    fireStore: widget.fireStore,
                  ),
                ),
              );
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                // backgroundColor: AppColors.mainColor,
                centerTitle: true,
                title: const Text(
                  "Settings",
                ),
                actions: [
                  GestureDetector(
                    onTap: () => onPressed(),
                    child: Container(
                      margin: EdgeInsets.only(right: Dimentions.width10 * 2),
                      child: Center(
                          child: FaIcon(
                        FontAwesomeIcons.check,
                        color: Colors.white,
                        size: Dimentions.height10 * 2.3,
                      )),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.mainColorWithO1,
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimentions.width10 * 2.5,
                      vertical: Dimentions.height10 * 2.5),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Weight Settings",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimentions.pxH * 18,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        SizedBox(
                          height: Dimentions.height10,
                        ),
                        Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Dimentions.height10),
                          ),
                          elevation: 1.0,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimentions.width10 * 1.5,
                                vertical: Dimentions.height10 * 1.5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  style: TextStyle(
                                    fontSize: Dimentions.height10 * 1.8,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  controller: minWeightController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  validator: (String? fieldContent) {
                                    if (fieldContent == null ||
                                        fieldContent.isEmpty ||
                                        double.parse(fieldContent) < 0 ||
                                        double.parse(fieldContent) > 400 ||
                                        !reg.hasMatch(fieldContent)) {
                                      return 'Please enter a valid min weight';
                                    }
                                    if (maxWeightController.text.isNotEmpty &&
                                        reg.hasMatch(
                                            maxWeightController.text)) {
                                      if (double.parse(fieldContent) >
                                          double.parse(
                                              maxWeightController.text)) {
                                        return 'Please enter a valid min weight';
                                      }
                                    }
                                    return null;
                                  },
                                  onTap: () => minWeightController.selection =
                                      TextSelection(
                                          baseOffset: 0,
                                          extentOffset: minWeightController
                                              .value.text.length),
                                  decoration: InputDecoration(
                                    suffix: const Text("kg"),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: Dimentions.width10 * 0.8,
                                        vertical: Dimentions.height10 * 0.8),
                                    labelText: "Min Weight",
                                    labelStyle: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontSize: Dimentions.height10 * 1.8,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(height: Dimentions.height15),
                                TextFormField(
                                  style: TextStyle(
                                    fontSize: Dimentions.height10 * 1.8,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  controller: maxWeightController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  validator: (String? fieldContent) {
                                    if (fieldContent == null ||
                                        fieldContent.isEmpty ||
                                        double.parse(fieldContent) < 0 ||
                                        double.parse(fieldContent) > 400 ||
                                        !reg.hasMatch(fieldContent)) {
                                      return 'Please enter a valid max weight';
                                    }
                                    if (minWeightController.text.isNotEmpty &&
                                        reg.hasMatch(
                                            minWeightController.text)) {
                                      if (double.parse(fieldContent) <
                                          double.parse(
                                              minWeightController.text)) {
                                        return 'Please enter a valid max weight';
                                      }
                                    }
                                    return null;
                                  },
                                  onTap: () => maxWeightController.selection =
                                      TextSelection(
                                          baseOffset: 0,
                                          extentOffset: maxWeightController
                                              .value.text.length),
                                  decoration: InputDecoration(
                                    suffix: const Text("kg"),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: Dimentions.width10 * 0.8,
                                        vertical: Dimentions.height10 * 0.8),
                                    labelText: "Max Weight",
                                    labelStyle: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontSize: Dimentions.height10 * 1.8,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dimentions.height10 * 2.5,
                        ),
                        Text(
                          "Height Settings",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimentions.pxH * 18,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        SizedBox(
                          height: Dimentions.height10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Dimentions.height10),
                          ),
                          margin: EdgeInsets.zero,
                          elevation: 1.0,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimentions.width15,
                                vertical: Dimentions.height15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  style: TextStyle(
                                    fontSize: Dimentions.height10 * 1.8,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  controller: minHeightController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  validator: (String? fieldContent) {
                                    if (fieldContent == null ||
                                        fieldContent.isEmpty ||
                                        double.parse(fieldContent) < 0 ||
                                        double.parse(fieldContent) > 300 ||
                                        !reg.hasMatch(fieldContent)) {
                                      return 'Please enter a valid min height';
                                    }
                                    if (maxHeightController.text.isNotEmpty &&
                                        reg.hasMatch(
                                            maxHeightController.text)) {
                                      if (double.parse(fieldContent) >
                                          double.parse(
                                              maxHeightController.text)) {
                                        return 'Please enter a valid min height';
                                      }
                                    }
                                    return null;
                                  },
                                  onTap: () => minHeightController.selection =
                                      TextSelection(
                                          baseOffset: 0,
                                          extentOffset: minHeightController
                                              .value.text.length),
                                  decoration: InputDecoration(
                                    suffix: const Text("cm"),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: Dimentions.width10 * 0.8,
                                        vertical: Dimentions.height10 * 0.8),
                                    labelText: "Min Height",
                                    labelStyle: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontSize: Dimentions.height10 * 1.8,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(height: Dimentions.height15),
                                TextFormField(
                                  style: TextStyle(
                                    fontSize: Dimentions.height10 * 1.8,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  controller: maxHeightController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  validator: (String? fieldContent) {
                                    if (fieldContent == null ||
                                        fieldContent.isEmpty ||
                                        double.parse(fieldContent) < 0 ||
                                        double.parse(fieldContent) > 300 ||
                                        !reg.hasMatch(fieldContent)) {
                                      return 'Please enter a valid max height';
                                    }
                                    if (minHeightController.text.isNotEmpty &&
                                        reg.hasMatch(
                                            minHeightController.text)) {
                                      if (double.parse(fieldContent) <
                                          double.parse(
                                              minHeightController.text)) {
                                        return 'Please enter a valid max height';
                                      }
                                    }
                                    return null;
                                  },
                                  onTap: () => maxHeightController.selection =
                                      TextSelection(
                                          baseOffset: 0,
                                          extentOffset: maxHeightController
                                              .value.text.length),
                                  decoration: InputDecoration(
                                    suffix: const Text("cm"),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: Dimentions.width10 * 0.8,
                                        vertical: Dimentions.height10 * 0.8),
                                    labelText: "Max Height",
                                    labelStyle: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontSize: Dimentions.height10 * 1.8,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dimentions.height10 * 3.5,
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: CustomTextButton(
                              isHaveIcon: false,
                              icon: null,
                              onPressed: () => onPressed(),
                              btnText: "Save Changes"),
                        ),
                        SizedBox(
                          height: Dimentions.height10 * 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SplashScreen(
            btnDisableStatus: true,
          );
  }

  void onPressed() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      Database(auth: widget.auth, fireStore: widget.fireStore)
          .updateSettingsData(
        uid: widget.auth.currentUser!.uid,
        minHeight: double.parse(minHeightController.text).toStringAsFixed(2),
        maxHeight: double.parse(maxHeightController.text).toStringAsFixed(2),
        minWeight: double.parse(minWeightController.text).toStringAsFixed(2),
        maxWeight: double.parse(maxWeightController.text).toStringAsFixed(2),
      )
          .then((value) {
        if (value) {
          showSuccess(_timer, "Settings successfully\nupdated.");
          saveSettingsData(
              double.parse(minHeightController.text).toStringAsFixed(2),
              double.parse(maxHeightController.text).toStringAsFixed(2),
              double.parse(minWeightController.text).toStringAsFixed(2),
              double.parse(maxWeightController.text).toStringAsFixed(2));
        }
      });
    }
  }

  Future<void> saveSettingsData(String minHeight, String maxHeight,
      String minWeight, String maxWeight) async {
    await Preferences.setSettingsData(
        minHeight, maxHeight, minWeight, maxWeight);
  }
}
