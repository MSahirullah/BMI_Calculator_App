import 'package:bmi_calculator/services/store_service.dart';
import 'package:bmi_calculator/utils/colors.dart';
import 'package:bmi_calculator/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    readData();
    genderController.text = "Male";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        title: const Text(
          "Edit Profile",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  height: 175.0,
                  width: 175.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/profile.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(
                        10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.edit,
                        color: AppColors.mainColor,
                      ),
                    ),
                  ),
                ),
              ],
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
                  TextField(
                    readOnly: true,
                    controller: genderController,
                    key: const ValueKey("gender"),
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
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
                          setState(() {
                            genderController.text = value;
                          });
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
                  TextField(
                    readOnly: true,
                    controller: bdateController,
                    key: const ValueKey("birth_day"),
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      labelText: "Date of Birth",
                      labelStyle: TextStyle(
                        color: AppColors.secondaryColor,
                        fontSize: 15.0,
                      ),
                      prefixIcon: Icon(
                        Icons.date_range,
                        color: AppColors.secondaryColor,
                        size: 18.0,
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          fieldHintText: 'Date/Month/Year',
                          fieldLabelText: 'Date of Birth',
                          helpText: 'Date of Birth',
                          firstDate: DateTime(1920, 03),
                          lastDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day));

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);

                        setState(() {
                          bdateController.text = formattedDate;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    maxLength: 3,
                    controller: weightController,
                    keyboardType: TextInputType.number,
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
                    maxLength: 3,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.accessibility_new_rounded),
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
            CustomTextButton(
              type: "",
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  String error = '';
                  if (nameController.text.isEmpty) {
                    error = 'Please enter name';
                  } else if (genderController.text.isEmpty) {
                    error = 'Please select gender';
                  } else if (bdateController.text.isEmpty) {
                    error = 'Please select date of birth';
                  } else if (weightController.text.isEmpty) {
                    error = 'Please select weight';
                  } else if (heightController.text.isEmpty) {
                    error = 'Please select height';
                  }
                  if (error.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error),
                      ),
                    );
                    return;
                  }
                  saveData('str', 'name', nameController.text);
                  saveData('str', 'gender', genderController.text);
                  saveData('str', 'dob', bdateController.text);
                  saveData('str', 'weight', weightController.text);
                  saveData('str', 'height', heightController.text);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Changes saved."),
                    ),
                  );
                },
                btnText: "Save Changes"),
            const SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }

  void saveData(type, key, value) async {
    final prefs = await SharedPreferences.getInstance();
    StoreServices(sharedPreferences: prefs).saveData(type, key, value);
  }

  void readData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = StoreServices(sharedPreferences: prefs)
                  .retriveData('str', 'name') !=
              ''
          ? StoreServices(sharedPreferences: prefs).retriveData('str', 'name')
          : '';
      genderController.text = StoreServices(sharedPreferences: prefs)
                  .retriveData('str', 'gender') !=
              ''
          ? StoreServices(sharedPreferences: prefs).retriveData('str', 'gender')
          : '';
      bdateController.text = StoreServices(sharedPreferences: prefs)
                  .retriveData('str', 'dob') !=
              ''
          ? StoreServices(sharedPreferences: prefs).retriveData('str', 'dob')
          : '';
      weightController.text = StoreServices(sharedPreferences: prefs)
                  .retriveData('str', 'weight') !=
              ''
          ? StoreServices(sharedPreferences: prefs).retriveData('str', 'weight')
          : '';
      heightController.text = StoreServices(sharedPreferences: prefs)
                  .retriveData('str', 'height') !=
              ''
          ? StoreServices(sharedPreferences: prefs).retriveData('str', 'height')
          : '';
    });
  }
}
