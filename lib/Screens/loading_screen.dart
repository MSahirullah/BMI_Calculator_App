import 'package:bmi_calculator/Screens/screens.dart';
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
}
