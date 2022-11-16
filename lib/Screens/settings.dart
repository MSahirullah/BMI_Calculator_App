import 'package:bmi_calculator/utils/utils.dart';
import 'package:bmi_calculator/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.mainColor,
        centerTitle: true,
        title: const Text(
          "Settings",
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Center(
                  child: FaIcon(
                FontAwesomeIcons.check,
                color: Colors.white,
                size: 20.0,
              )),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.mainColorWithO1,
      body: Container(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Weight Settings",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  color: AppColors.secondaryColor,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 1.0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: minWeightController,
                        keyboardType: TextInputType.number,
                        validator: (String? fieldContent) {
                          if (fieldContent == null ||
                              fieldContent.isEmpty ||
                              double.parse(fieldContent) < 0 ||
                              double.parse(fieldContent) > 400) {
                            return 'Please enter a valid min weight';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffix: const Text("cm"),
                          contentPadding: const EdgeInsets.all(8.0),
                          labelText: "Min Weight",
                          labelStyle: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        controller: maxWeightController,
                        keyboardType: TextInputType.number,
                        validator: (String? fieldContent) {
                          if (fieldContent == null ||
                              fieldContent.isEmpty ||
                              double.parse(fieldContent) < 0 ||
                              double.parse(fieldContent) > 400) {
                            return 'Please enter a valid max weight';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffix: const Text("cm"),
                          contentPadding: const EdgeInsets.all(8.0),
                          labelText: "Max Weight",
                          labelStyle: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Text(
                "Height Settings",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  color: AppColors.secondaryColor,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 1.0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: minHeightController,
                        keyboardType: TextInputType.number,
                        validator: (String? fieldContent) {
                          if (fieldContent == null ||
                              fieldContent.isEmpty ||
                              double.parse(fieldContent) < 0 ||
                              double.parse(fieldContent) > 300) {
                            return 'Please enter a valid min height';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffix: const Text("cm"),
                          contentPadding: const EdgeInsets.all(8.0),
                          labelText: "Min Height",
                          labelStyle: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        controller: maxHeightController,
                        keyboardType: TextInputType.number,
                        validator: (String? fieldContent) {
                          if (fieldContent == null ||
                              fieldContent.isEmpty ||
                              double.parse(fieldContent) < 0 ||
                              double.parse(fieldContent) > 300) {
                            return 'Please enter a valid max height';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffix: const Text("cm"),
                          contentPadding: const EdgeInsets.all(8.0),
                          labelText: "Max Height",
                          labelStyle: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 35.0,
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: CustomTextButton(
                    isHaveIcon: false,
                    icon: null,
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();

                      //ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      // if (!_loadProfile) {
                      //   showSnackBar(
                      //       "Please wait, uploading profile \npicture is in process.");
                      // } else if (_formKey.currentState!.validate() &&
                      //     _loadProfile) {
                      //   Database(
                      //           auth: widget.auth,
                      //           fireStore: widget.fireStore)
                      //       .updateUserDetails(
                      //     uid: widget.auth.currentUser!.uid,
                      //     name: nameController.text,
                      //     weight: weightController.text,
                      //     height: heightController.text,
                      //     gender: genderController.text,
                      //     dob: bdateController.text,
                      //     profile: _profilePic,
                      //   )
                      //       .then((value) async {
                      //     if (value) {
                      //       updateStatus = true;
                      //       if (_oldProfile != '') {
                      //         await Storage(
                      //           auth: widget.auth,
                      //         ).deleteUserProfilePicture(_oldProfile);
                      //       }
                      //       Preferences.setUserData(
                      //           nameController.text,
                      //           _profilePic,
                      //           genderController.text,
                      //           bdateController.text);
                      //       Preferences.setBMIData(
                      //           double.parse(heightController.text)
                      //               .toStringAsFixed(2),
                      //           double.parse(weightController.text)
                      //               .toStringAsFixed(2));
                      //       showSuccess(_timer,
                      //           "Profile details\nsuccessfully updated.");
                      //     } else {
                      //       showSnackBar(
                      //           "Something went wrong. \nPlease try again.");
                      //     }
                      // });
                    },
                    btnText: "Save Changes"),
              ),
              const SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
