import 'package:bmi_calculator/Screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
            //
          } else if (snapshot.hasData) {
            return const HomeScreen();
            //
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went worng!"),
              //
            );
          } else {
            return const SplashScreen();
            // 
          }
        },
      ),
    );
  }
}
