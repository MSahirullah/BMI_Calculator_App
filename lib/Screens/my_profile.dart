// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:bmi_calculator/Screens/screens.dart';
import 'package:bmi_calculator/services/database.dart';
import 'package:bmi_calculator/services/preferences.dart';
import 'package:bmi_calculator/services/storage.dart';
import 'package:bmi_calculator/utils/utils.dart';
import 'package:bmi_calculator/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  const MyProfileScreen(
      {super.key, required this.auth, required this.fireStore});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  var genders = [
    'Male',
    'Female',
    'Other',
  ];

  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController bdateController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  final _formKey = GlobalKey<FormState>();
  String _profilePic = '';
  bool _loadProfile = true;
  Timer? _timer;
  bool updateStatus = false;
  String _oldProfile = '';

  double _minWeight = 1.00;
  double _maxWeight = 400.00;

  double _minHeight = 30.00;
  double _maxHeight = 255.00;

  @override
  void initState() {
    super.initState();
    nameController.text =
        Preferences.getUsername() ?? widget.auth.currentUser!.displayName!;
    _profilePic =
        Preferences.getProfile() ?? widget.auth.currentUser!.photoURL!;
    genderController.text = Preferences.getGender() ?? "";
    heightController.text = Preferences.getHeight() ?? "";
    weightController.text = Preferences.getWeight() ?? "";
    bdateController.text = Preferences.getDOB() ?? "";

    _minHeight = double.parse(Preferences.getMinHeight() ?? "1.00");
    _maxHeight = double.parse(Preferences.getMaxHeight() ?? "400.00");
    _minWeight = double.parse(Preferences.getMinHeight() ?? "30.00");
    _maxWeight = double.parse(Preferences.getMaxWeight() ?? "255.00");
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<InternetConnectionStatus>(context) !=
            InternetConnectionStatus.disconnected
        ? WillPopScope(
            onWillPop: () async {
              if (!_loadProfile) {
                showSnackBar(
                    "Please wait, uploading profile \npicture is in process.");
                return false;
              }
              if (!updateStatus &&
                  _loadProfile &&
                  _profilePic !=
                      (Preferences.getProfile() ??
                          widget.auth.currentUser!.photoURL!)) {
                await Storage(
                  auth: widget.auth,
                ).deleteUserProfilePicture(_profilePic);
              }
              Navigator.pop(context);
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
                backgroundColor: AppColors.mainColor,
                centerTitle: true,
                title: const Text(
                  "Edit Profile",
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
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: Dimentions.height10 * 3,
                      ),
                      Container(
                        constraints:
                            BoxConstraints(minHeight: Dimentions.height10 * 17),
                        height: Dimentions.screenHeight * 0.18,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: Dimentions.height10 * 17,
                                  height: Dimentions.height10 * 17,
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: Dimentions.height10 * 9,
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(
                                            strokeWidth: 3,
                                          ),
                                          imageUrl: _profilePic,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: Dimentions.height10 * 17,
                                            height: Dimentions.height10 * 17,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    Dimentions.height10 * 10),
                                              ),
                                              image: DecorationImage(
                                                fit: BoxFit.fitWidth,
                                                alignment:
                                                    FractionalOffset.center,
                                                image: imageProvider,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0.0,
                                        right: 0.0,
                                        child: InkWell(
                                          onTap: () {
                                            _loadProfile
                                                ? showModalBottomSheet(
                                                    context: context,
                                                    builder: ((builder) =>
                                                        bottomSheet()),
                                                  )
                                                : null;
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    Dimentions.width10 * 0.8,
                                                vertical:
                                                    Dimentions.height10 * 0.8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    Dimentions.height10 * 8),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: _loadProfile
                                                ? Icon(
                                                    Icons.camera_alt,
                                                    color: AppColors.bottomBox,
                                                    size:
                                                        Dimentions.height10 * 3,
                                                  )
                                                : SizedBox(
                                                    width:
                                                        Dimentions.height10 * 3,
                                                    height:
                                                        Dimentions.height10 * 3,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal:
                                                            Dimentions.width10 *
                                                                0.2,
                                                        vertical: Dimentions
                                                                .height10 *
                                                            0.2,
                                                      ),
                                                      child:
                                                          const CircularProgressIndicator(
                                                        strokeWidth: 3,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: Dimentions.height10 * 3,
                          horizontal: Dimentions.width10 * 2.5,
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              style: TextStyle(
                                fontSize: Dimentions.height10 * 1.8,
                                fontWeight: FontWeight.w600,
                              ),
                              controller: nameController,
                              validator: (String? fieldContent) {
                                if (fieldContent == null ||
                                    fieldContent.isEmpty ||
                                    fieldContent.length < 4) {
                                  return 'Please enter a valid name';
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[A-Za-z. ]')),
                                LengthLimitingTextInputFormatter(50),
                              ],
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(Icons.person_outline_rounded),
                                prefixIconColor: AppColors.greyColor,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dimentions.width10 * 0.8,
                                  vertical: Dimentions.height10 * 0.8,
                                ),
                                labelText: "Enter your name",
                                labelStyle: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: Dimentions.height10 * 1.8,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: Dimentions.height10 * 2),
                            TextFormField(
                              style: TextStyle(
                                fontSize: Dimentions.height10 * 1.8,
                                fontWeight: FontWeight.w600,
                              ),
                              readOnly: true,
                              controller: genderController,
                              key: const ValueKey("gender"),
                              validator: (String? fieldContent) {
                                if (fieldContent == null ||
                                    fieldContent.isEmpty) {
                                  return 'Please select your gender';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                    genderController.text == 'Female'
                                        ? Icons.girl_rounded
                                        : Icons.boy_rounded),
                                prefixIconColor: AppColors.greyColor,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dimentions.width10 * 0.8,
                                  vertical: Dimentions.height10 * 0.8,
                                ),
                                labelText: "Gender",
                                labelStyle: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: Dimentions.height10 * 1.8,
                                  fontWeight: FontWeight.w500,
                                ),
                                suffixIcon: PopupMenuButton<String>(
                                  elevation: 4,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: AppColors.mainColor,
                                    size: Dimentions.height10 * 2.5,
                                  ),
                                  onSelected: (String value) {
                                    genderController.text = value;
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return genders.map<PopupMenuItem<String>>(
                                        (String value) {
                                      return PopupMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: Dimentions.height10 * 2),
                            TextFormField(
                              style: TextStyle(
                                fontSize: Dimentions.height10 * 1.8,
                                fontWeight: FontWeight.w600,
                              ),
                              readOnly: true,
                              controller: bdateController,
                              key: const ValueKey("birth_day"),
                              keyboardType: TextInputType.datetime,
                              validator: (String? fieldContent) {
                                if (fieldContent == null ||
                                    fieldContent.isEmpty) {
                                  return 'Please enter a valid date of birth';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dimentions.width10 * 0.8,
                                  vertical: Dimentions.height10 * 0.8,
                                ),
                                labelText: "Date of Birth",
                                labelStyle: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: Dimentions.height10 * 1.8,
                                  fontWeight: FontWeight.w500,
                                ),
                                prefixIcon: Icon(
                                  Icons.date_range,
                                  color: AppColors.greyColor,
                                  size: Dimentions.height10 * 1.8,
                                ),
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: bdateController.text == ""
                                        ? DateTime.now()
                                        : DateFormat('y-m-d')
                                            .parse(bdateController.text),
                                    fieldHintText: 'Date/Month/Year',
                                    fieldLabelText: 'Date of Birth',
                                    helpText: 'Date of Birth',
                                    firstDate:
                                        DateTime(DateTime.now().year - 100),
                                    lastDate: DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day));

                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);

                                  bdateController.text = formattedDate;
                                }
                              },
                            ),
                            SizedBox(height: Dimentions.height10 * 2),
                            TextFormField(
                              controller: weightController,
                              style: TextStyle(
                                fontSize: Dimentions.height10 * 1.8,
                                fontWeight: FontWeight.w600,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (String? fieldContent) {
                                if (fieldContent == null ||
                                    fieldContent.isEmpty ||
                                    double.parse(fieldContent) <= _minWeight ||
                                    double.parse(fieldContent) >= _maxWeight) {
                                  return 'Please enter a valid weight';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(Icons.monitor_weight_outlined),
                                prefixIconColor: AppColors.greyColor,
                                suffix: const Text("kg"),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dimentions.width10 * 0.8,
                                  vertical: Dimentions.height10 * 0.8,
                                ),
                                labelText: "Enter your weight",
                                labelStyle: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: Dimentions.height10 * 1.8,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: Dimentions.height10 * 2),
                            TextFormField(
                              style: TextStyle(
                                fontSize: Dimentions.height10 * 1.8,
                                fontWeight: FontWeight.w600,
                              ),
                              controller: heightController,
                              keyboardType: TextInputType.number,
                              validator: (String? fieldContent) {
                                if (fieldContent == null ||
                                    fieldContent.isEmpty ||
                                    double.parse(fieldContent) <= _minHeight ||
                                    double.parse(fieldContent) >= _maxHeight) {
                                  return 'Please enter a valid height';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(Icons.accessibility_new_rounded),
                                prefixIconColor: AppColors.greyColor,
                                suffix: const Text("cm"),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dimentions.width10 * 0.8,
                                  vertical: Dimentions.height10 * 0.8,
                                ),
                                labelText: "Enter your height",
                                labelStyle: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: Dimentions.height10 * 1.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Dimentions.height10 * 2.4,
                      ),
                      CustomTextButton(
                          isHaveIcon: false,
                          icon: null,
                          onPressed: onPressed,
                          btnText: "Save Changes"),
                      SizedBox(
                        height: Dimentions.height10 * 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SplashScreen(
            btnDisableStatus: true,
          );
  }

  Widget bottomSheet() {
    return Container(
      height: Dimentions.height10 * 8.5,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: Dimentions.width10 * 2,
        vertical: Dimentions.height10 * 2,
      ),
      child: Column(
        children: [
          Text(
            "Choose Profile Photo",
            style: TextStyle(
              fontSize: Dimentions.height15,
              color: AppColors.greyColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: Dimentions.height10,
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(
                  Icons.camera,
                  color: AppColors.bottomBox,
                ),
                label: Text(
                  "Camera",
                  style: TextStyle(color: AppColors.bottomBox),
                ),
              ),
              SizedBox(
                width: Dimentions.width10,
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(
                  Icons.image,
                  color: AppColors.bottomBox,
                ),
                label: Text(
                  "Gallery",
                  style: TextStyle(color: AppColors.bottomBox),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    _imageFile = pickedFile;
    if (_imageFile != null) {
      setState(() {
        _loadProfile = false;
      });
      if (_profilePic != widget.auth.currentUser!.photoURL) {
        setState(() {
          _oldProfile = _profilePic;
        });
      }
      Navigator.pop(context);
      await Storage(
        auth: widget.auth,
      )
          .uploadUserProfilePicture(
              _imageFile!.path, widget.auth.currentUser!.uid.toString())
          .then((value) {
        setState(() {
          _profilePic = value;
          _loadProfile = true;
        });
      });
    }
  }

  onPressed() {
    FocusManager.instance.primaryFocus?.unfocus();
    dismissSnackBar();
    if (!_loadProfile) {
      showSnackBar("Please wait, uploading profile \npicture is in process.");
    } else if (_formKey.currentState!.validate() && _loadProfile) {
      Database(auth: widget.auth, fireStore: widget.fireStore)
          .updateUserDetails(
        uid: widget.auth.currentUser!.uid,
        name: nameController.text,
        weight: weightController.text,
        height: heightController.text,
        gender: genderController.text,
        dob: bdateController.text,
        profile: _profilePic,
      )
          .then((value) async {
        if (value) {
          updateStatus = true;
          if (_oldProfile != '') {
            await Storage(
              auth: widget.auth,
            ).deleteUserProfilePicture(_oldProfile);
          }
          Preferences.setUserData(nameController.text, _profilePic,
              genderController.text, bdateController.text);
          Preferences.setBMIData(
              double.parse(heightController.text).toStringAsFixed(2),
              double.parse(weightController.text).toStringAsFixed(2));
          showSuccess(_timer, "Profile details\nsuccessfully updated.");
        } else {
          showSnackBar("Something went wrong. \nPlease try again.");
        }
      });
    }
  }
}
