import 'package:bmi_calculator/Screens/screens.dart';
import 'package:bmi_calculator/models/bmi_data.dart';
import 'package:bmi_calculator/services/database.dart';
import 'package:bmi_calculator/utils/utils.dart';
import 'package:bmi_calculator/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class BMIHistoryScreen extends StatefulWidget {
  const BMIHistoryScreen(
      {super.key, required this.auth, required this.fireStore});

  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  @override
  State<BMIHistoryScreen> createState() => _BMIHistoryScreenState();
}

class _BMIHistoryScreenState extends State<BMIHistoryScreen> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Provider.of<InternetConnectionStatus>(context) !=
            InternetConnectionStatus.disconnected
        ? WillPopScope(
            onWillPop: () async {
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
                centerTitle: true,
                title: const Text(
                  "History",
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.only(right: Dimentions.width10 * 2),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _loading = true;
                        });
                        Database(fireStore: widget.fireStore, auth: widget.auth)
                            .clearHistory(uid: widget.auth.currentUser!.uid)
                            .then((value) {
                          setState(() {
                            _loading = false;
                          });
                        });
                        // _loading = false;
                      },
                      child: Center(
                        child: _loading == false
                            ? FaIcon(
                                FontAwesomeIcons.trash,
                                color: Colors.white,
                                size: Dimentions.pxH * 18,
                              )
                            : SizedBox(
                                height: Dimentions.height10 * 2,
                                width: Dimentions.width10 * 2,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.mainColorWithO1,
              body: Container(
                padding: EdgeInsets.symmetric(
                    vertical: Dimentions.height15,
                    horizontal: Dimentions.width15),
                child: Column(
                  children: [
                    Card(
                      elevation: 0.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimentions.pxH * 8,
                          horizontal: Dimentions.pxW * 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimentions.height10 * 1.6)),
                            Text('Weight',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimentions.height10 * 1.6)),
                            Text('Height',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimentions.height10 * 1.6)),
                            Text('BMI',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimentions.height10 * 1.6)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimentions.pxW * 12,
                              vertical: Dimentions.pxH * 12),
                          child: StreamBuilder(
                            stream: Database(
                                    fireStore: widget.fireStore,
                                    auth: widget.auth)
                                .bmiHistory(uid: widget.auth.currentUser!.uid),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<BMIModel>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                if (snapshot.data!.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "You don't have any history data.",
                                          style: TextStyle(
                                            fontSize: Dimentions.pxH * 15,
                                          ),
                                        ),
                                        SizedBox(
                                          height: Dimentions.height10 * 2,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        const LoadingScreen(),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Go to Home",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: Dimentions.pxH * 16,
                                                ),
                                              ),
                                              SizedBox(
                                                width: Dimentions.pxW * 5,
                                              ),
                                              Icon(
                                                FontAwesomeIcons.arrowRight,
                                                size: Dimentions.pxH * 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  itemCount: snapshot.data != null
                                      ? snapshot.data?.length
                                      : 0,
                                  itemBuilder: (_, index) {
                                    return BMIHistoryCard(
                                      bmiData: snapshot.data![index],
                                    );
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text("loading..."),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SplashScreen(
            btnDisableStatus: true,
          );
  }
}
