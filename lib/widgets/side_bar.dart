import 'package:bmi_calculator/Screens/screens.dart';
import 'package:bmi_calculator/services/store_service.dart';
import 'package:bmi_calculator/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String name = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readName();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.mainColor,
      width: 275.0,
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              50.0,
                            ),
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: AppColors.mainColor,
                          maxRadius: 45.0,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/profile.jpg',
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Divider(
                  color: Colors.white,
                  height: 2.0,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemExtent: 40.0,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyProfileScreen()),
                        );
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.person_outline_rounded,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          'My Profile',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BMIHistoryScreen()),
                        );
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          'BMI History',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void readName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = StoreServices(sharedPreferences: prefs)
                  .retriveData('str', 'name') ==
              ''
          ? StoreServices(sharedPreferences: prefs).retriveData('str', 'name')
          : 'Mohamed Sahirullah';
    });
  }
}
