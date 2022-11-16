import 'package:bmi_calculator/Screens/screens.dart';
import 'package:bmi_calculator/models/bmi_data.dart';
import 'package:bmi_calculator/services/database.dart';
import 'package:bmi_calculator/utils/utils.dart';
import 'package:bmi_calculator/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.mainColor,
        centerTitle: true,
        title: const Text(
          "History",
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20.0),
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
                    ? const FaIcon(
                        FontAwesomeIcons.trash,
                        color: Colors.white,
                        size: 18.0,
                      )
                    : const SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(
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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Card(
              elevation: 0.0,
              child: Container(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 4.0, right: 4.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('Date', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('Weight',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('Height',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('BMI', style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: StreamBuilder(
                    stream:
                        Database(fireStore: widget.fireStore, auth: widget.auth)
                            .bmiHistory(uid: widget.auth.currentUser!.uid),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<BMIModel>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.data!.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("You don't have any history data."),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            const LoadingScreen(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "Go to Home",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.arrowRight,
                                        size: 16.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount:
                              snapshot.data != null ? snapshot.data?.length : 0,
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
    );
  }
}
