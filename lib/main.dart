import 'package:bmi_calculator/Screens/screens.dart';
import 'package:bmi_calculator/provider/google_sign_in.dart';
import 'package:bmi_calculator/services/preferences.dart';
import 'package:bmi_calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Preferences.init();

  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<InternetConnectionStatus>(
      initialData: InternetConnectionStatus.connected,
      create: (_) {
        return InternetConnectionChecker().onStatusChange;
      },
      child: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: MaterialApp(
            title: 'BMI Calculator',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: AppColors.customAppColor,
              fontFamily: 'OpenSans',
            ),
            home: const LoadingScreen(),
            builder: EasyLoading.init(),
          )),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1750)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = AppColors.greyColor.withOpacity(0.5)
    ..userInteractions = false
    ..toastPosition = EasyLoadingToastPosition.bottom
    ..contentPadding =
        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0)
    ..dismissOnTap = true;
}
