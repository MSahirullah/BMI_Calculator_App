import 'package:bmi_calculator/Screens/screens.dart';
import 'package:bmi_calculator/services/preferences.dart';
import 'package:bmi_calculator/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key, required this.auth, required this.fireStore});

  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late String name;
  late String profile;
  @override
  void initState() {
    super.initState();
    name = Preferences.getUsername() ?? widget.auth.currentUser!.displayName!;
    profile = Preferences.getProfile() ?? widget.auth.currentUser!.photoURL!;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.mainColor,
      width: Dimentions.pxW * 275,
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Dimentions.width10 * 2,
              vertical: Dimentions.height10 * 2,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimentions.width15,
                      vertical: Dimentions.height10 / 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: Dimentions.height10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              Dimentions.height10 * 10,
                            ),
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: Dimentions.pxW * 2,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyProfileScreen(
                                  auth: widget.auth,
                                  fireStore: widget.fireStore,
                                ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: Dimentions.height10 * 6,
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                              imageUrl: profile,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: Dimentions.width10 * 12,
                                height: Dimentions.height10 * 12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Dimentions.height10 * 7),
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
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProfileScreen(
                                auth: widget.auth,
                                fireStore: widget.fireStore,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: Dimentions.height15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Dimentions.height10 * 2,
                ),
                Divider(
                  color: Colors.white,
                  height: Dimentions.pxH * 2,
                ),
                SizedBox(
                  height: Dimentions.height10,
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
                            builder: (context) => MyProfileScreen(
                              auth: widget.auth,
                              fireStore: widget.fireStore,
                            ),
                          ),
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
                            builder: (context) => BMIHistoryScreen(
                              auth: widget.auth,
                              fireStore: widget.fireStore,
                            ),
                          ),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(
                              auth: widget.auth,
                              fireStore: widget.fireStore,
                            ),
                          ),
                        );
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          'Settings',
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
}
