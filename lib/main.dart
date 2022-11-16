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
  runApp(const MyApp());
  configLoading();
  await Preferences.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = {
      50: AppColors.mainColor.withOpacity(.1),
      100: AppColors.mainColor.withOpacity(.2),
      200: AppColors.mainColor.withOpacity(.3),
      300: AppColors.mainColor.withOpacity(.4),
      400: AppColors.mainColor.withOpacity(.5),
      500: AppColors.mainColor.withOpacity(.6),
      600: AppColors.mainColor.withOpacity(.7),
      700: AppColors.mainColor.withOpacity(.8),
      800: AppColors.mainColor.withOpacity(.9),
      900: AppColors.mainColor.withOpacity(1),
    };

    MaterialColor colorCustom = MaterialColor(0xFF606BA1, color);

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
              primarySwatch: colorCustom,
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

// when user input value the meter value should be bold



  // print(_weight);

  // setState(() {
  //   weightScrollController.animateToItem(
  //       ((_weight - 1) * 2).toInt(),
  //       duration: const Duration(seconds: 1),
  //       curve: Curves.linear);
  // });