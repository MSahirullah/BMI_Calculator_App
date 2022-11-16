// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:bmi_calculator/Screens/home_screen.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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

  double _minWeight = 1;
  double _maxWeight = 400;

  double _minHeight = 30;
  double _maxHeight = 255;

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
    return WillPopScope(
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
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  constraints: const BoxConstraints(minHeight: 165.0),
                  height: MediaQuery.of(context).size.height * 0.18,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 165.0,
                            height: 165.0,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 80.0,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(
                                      strokeWidth: 3,
                                    ),
                                    imageUrl: _profilePic,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 165.0,
                                      height: 165.0,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(100.0),
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          alignment: FractionalOffset.center,
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
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(80.0),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
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
                                              size: 25.0,
                                            )
                                          : const SizedBox(
                                              width: 25.0,
                                              height: 25.0,
                                              child: Padding(
                                                padding: EdgeInsets.all(2.0),
                                                child:
                                                    CircularProgressIndicator(
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
                  margin: const EdgeInsets.symmetric(
                    vertical: 30.0,
                    horizontal: 25.0,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
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
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          prefixIconColor: AppColors.greyColor,
                          contentPadding: const EdgeInsets.all(8.0),
                          labelText: "Enter your name",
                          labelStyle: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        readOnly: true,
                        controller: genderController,
                        key: const ValueKey("gender"),
                        style: const TextStyle(
                          fontSize: 15.0,
                        ),
                        validator: (String? fieldContent) {
                          if (fieldContent == null || fieldContent.isEmpty) {
                            return 'Please select your gender';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(genderController.text == 'Female'
                              ? Icons.girl_rounded
                              : Icons.boy_rounded),
                          prefixIconColor: AppColors.greyColor,
                          contentPadding: const EdgeInsets.all(8.0),
                          labelText: "Gender",
                          labelStyle: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 15.0,
                          ),
                          suffixIcon: PopupMenuButton<String>(
                            elevation: 4,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.mainColor,
                              size: 25.0,
                            ),
                            onSelected: (String value) {
                              genderController.text = value;
                            },
                            itemBuilder: (BuildContext context) {
                              return genders
                                  .map<PopupMenuItem<String>>((String value) {
                                return PopupMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        readOnly: true,
                        controller: bdateController,
                        key: const ValueKey("birth_day"),
                        style: const TextStyle(
                          fontSize: 15.0,
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (String? fieldContent) {
                          if (fieldContent == null || fieldContent.isEmpty) {
                            return 'Please enter a valid date of birth';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8.0),
                          labelText: "Date of Birth",
                          labelStyle: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 15.0,
                          ),
                          prefixIcon: Icon(
                            Icons.date_range,
                            color: AppColors.greyColor,
                            size: 18.0,
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
                              firstDate: DateTime(DateTime.now().year - 100),
                              lastDate: DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day));

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);

                            bdateController.text = formattedDate;
                          }
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: weightController,
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
                          prefixIcon: const Icon(Icons.monitor_weight_outlined),
                          prefixIconColor: AppColors.greyColor,
                          suffix: const Text("kg"),
                          contentPadding: const EdgeInsets.all(8.0),
                          labelText: "Enter your weight",
                          labelStyle: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
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
                          contentPadding: const EdgeInsets.all(8.0),
                          labelText: "Enter your height",
                          labelStyle: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                CustomTextButton(
                    isHaveIcon: false,
                    icon: null,
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      if (!_loadProfile) {
                        showSnackBar(
                            "Please wait, uploading profile \npicture is in process.");
                      } else if (_formKey.currentState!.validate() &&
                          _loadProfile) {
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
                            Preferences.setUserData(
                                nameController.text,
                                _profilePic,
                                genderController.text,
                                bdateController.text);
                            Preferences.setBMIData(
                                double.parse(heightController.text)
                                    .toStringAsFixed(2),
                                double.parse(weightController.text)
                                    .toStringAsFixed(2));
                            showSuccess(_timer,
                                "Profile details\nsuccessfully updated.");
                          } else {
                            showSnackBar(
                                "Something went wrong. \nPlease try again.");
                          }
                        });
                      }
                    },
                    btnText: "Save Changes"),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 80.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Column(
        children: [
          Text(
            "Choose Profile Photo",
            style: TextStyle(
              fontSize: 15,
              color: AppColors.greyColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10.0,
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
              const SizedBox(
                width: 10.0,
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
}
