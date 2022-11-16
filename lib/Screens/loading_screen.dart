import 'package:bmi_calculator/Screens/screens.dart';
import 'package:bmi_calculator/services/database.dart';
import 'package:bmi_calculator/services/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<InternetConnectionStatus>(context) !=
            InternetConnectionStatus.disconnected
        ? Scaffold(
            body: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                  //
                } else if (snapshot.hasData) {
                  Database(auth: _auth, fireStore: _fireStore)
                      .checkUserExist(uid: _auth.currentUser!.uid)
                      .then((value) {
                    if (value == false) {
                      Database(auth: _auth, fireStore: _fireStore)
                          .addUserDetails(
                        uid: _auth.currentUser!.uid,
                        name: _auth.currentUser!.displayName!,
                        profile: _auth.currentUser!.photoURL!,
                      );

                      Database(auth: _auth, fireStore: _fireStore)
                          .addSettingsDetails(
                        uid: _auth.currentUser!.uid,
                      );

                      saveUserData(_auth.currentUser!.displayName!,
                          _auth.currentUser!.photoURL!, "", "");
                      saveBMIData("", "");
                      saveSettingsData("30", "255", "1", "400");
                    } else {
                      Database(auth: _auth, fireStore: _fireStore)
                          .getUserBasicDetails(uid: _auth.currentUser!.uid)
                          .then((value) {
                        saveUserData(value[0], value[1], value[2], value[3]);
                        saveBMIData(value[4], value[5]);
                      });

                      Database(auth: _auth, fireStore: _fireStore)
                          .getSettingsDetails(uid: _auth.currentUser!.uid)
                          .then((value) {
                        saveSettingsData(
                            value[0], value[1], value[2], value[3]);
                      });
                    }
                  });
                  return HomeScreen(
                    auth: _auth,
                    fireStore: _fireStore,
                  );
                  //
                } else if (snapshot.hasError) {
                  return const ErrorScreen();
                  //
                } else {
                  return const SplashScreen();
                  //
                }
              },
            ),
          )
        : const SplashScreen(
            btnDisableStatus: true,
          );
  }

  Future<void> saveUserData(
      String name, String profile, String gender, String dob) async {
    await Preferences.setUserData(name, profile, gender, dob);
  }

  Future<void> saveBMIData(String height, String weight) async {
    await Preferences.setBMIData(height, weight);
  }

  Future<void> saveSettingsData(String minHeight, String maxHeight,
      String minWeight, String maxWeight) async {
    await Preferences.setSettingsData(
        minHeight, maxHeight, minWeight, maxWeight);
  }
}
