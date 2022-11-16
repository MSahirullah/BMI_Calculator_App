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
                              100.0,
                            ),
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
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
                            radius: 60.0,
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                              imageUrl: profile,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(70.0),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                          ),
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
