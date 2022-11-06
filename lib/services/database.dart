import 'package:bmi_calculator/models/bmi_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  Database({required this.auth, required this.fireStore});

  //add data
  Future<String> addBMIData(
      {required String uid,
      required String weight,
      required String height,
      required String bmi}) async {
    try {
      DateTime now = DateTime.now();
      String date = DateTime(now.year, now.month, now.day).toString();

      fireStore.collection("bmiHistory").doc(uid).collection("bmiData").add({
        "weight": weight,
        "height": height,
        "bmi": bmi,
        "date": date,
      });

      return "1";
    } catch (e) {
      return "0";
    }
  }

  Stream<List<BMIModel>> bmiHistory({required String uid}) {
    try {
      return fireStore
          .collection("bmiHistory")
          .doc(uid)
          .collection("bmiData")
          .snapshots()
          .map((query) {
        final List<BMIModel> result = <BMIModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          result.add(BMIModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return result;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearHistory({required String uid}) async {
    try {
      print(uid);
      await fireStore.collection('bmiHistory').doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }
}
