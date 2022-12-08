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

      fireStore.collection("bmiApp").doc(uid).collection("bmiData").add({
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
          .collection("bmiApp")
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

  // Future<UserModel?> getUserDetails({required String uid}) {
  //   try {
  //     return fireStore
  //         .collection("bmiApp")
  //         .doc(uid)
  //         .collection("userData")
  //         .get()
  //         .then((QuerySnapshot querySnapshot) {
  //       if (querySnapshot.docs.isNotEmpty) {
  //         if (querySnapshot.docs[0].data().toString() != '{}') {
  //           Map<String, dynamic> data =
  //               querySnapshot.data!.data() as Map<String, dynamic>;
  //         }
  //       }
  //       return null;
  //     });
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<void> addUserDetails({
    required String uid,
    required String name,
    required String profile,
  }) async {
    try {
      fireStore
          .collection("bmiApp")
          .doc(uid)
          .collection("userData")
          .doc(uid)
          .set({
        "name": name,
        "weight": "",
        "height": "",
        "gender": "",
        "dob": "",
        "profile": profile,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateUserDetails({
    required String uid,
    required String name,
    required String weight,
    required String height,
    required String gender,
    required String dob,
    required String profile,
  }) async {
    try {
      fireStore
          .collection("bmiApp")
          .doc(uid)
          .collection("userData")
          .doc(uid)
          .update({
        "name": name,
        "weight": weight,
        "height": height,
        "gender": gender,
        "dob": dob,
        "profile": profile,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserBMIData({
    required String uid,
    required String weight,
    required String height,
    required String gender,
    required String dob,
  }) async {
    try {
      fireStore
          .collection("bmiApp")
          .doc(uid)
          .collection("userData")
          .doc(uid)
          .update({
        "weight": weight,
        "height": height,
        "dob": dob,
        "gender": gender,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkUserExist({required String uid}) async {
    try {
      bool status = false;
      await fireStore
          .collection("bmiApp")
          .doc(uid)
          .collection("userData")
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          if (querySnapshot.docs[0].data().toString() != '{}') {
            status = true;
          }
        }
      });
      return status;
    } catch (e) {
      rethrow;
    }
  }

  Future<List> getUserBasicDetails({required String uid}) async {
    try {
      List data = [];
      await fireStore
          .collection("bmiApp")
          .doc(uid)
          .collection("userData")
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          if (querySnapshot.docs[0].data().toString() != '{}') {
            data.add(querySnapshot.docs[0]["name"]);
            data.add(querySnapshot.docs[0]["profile"]);
            data.add(querySnapshot.docs[0]["gender"]);
            data.add(querySnapshot.docs[0]["dob"]);
            data.add(querySnapshot.docs[0]["height"]);
            data.add(querySnapshot.docs[0]["weight"]);
          }
        }
      });
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearHistory({required String uid}) async {
    try {
      var collection =
          fireStore.collection('bmiApp').doc(uid).collection("bmiData");
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addSettingsDetails({
    required String uid,
  }) async {
    try {
      fireStore
          .collection("bmiApp")
          .doc(uid)
          .collection("settings")
          .doc(uid)
          .set({
        "minHeight": "30.00",
        "maxHeight": "255.00",
        "minWeight": "1.00",
        "maxWeight": "300.00",
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateSettingsData({
    required String uid,
    required String minHeight,
    required String maxHeight,
    required String minWeight,
    required String maxWeight,
  }) async {
    try {
      fireStore
          .collection("bmiApp")
          .doc(uid)
          .collection("settings")
          .doc(uid)
          .update({
        "minHeight": minHeight,
        "maxHeight": maxHeight,
        "minWeight": minWeight,
        "maxWeight": maxWeight,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List> getSettingsDetails({required String uid}) async {
    try {
      List data = [];
      await fireStore
          .collection("bmiApp")
          .doc(uid)
          .collection("settings")
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          if (querySnapshot.docs[0].data().toString() != '{}') {
            data.add(querySnapshot.docs[0]["minHeight"]);
            data.add(querySnapshot.docs[0]["maxHeight"]);
            data.add(querySnapshot.docs[0]["minWeight"]);
            data.add(querySnapshot.docs[0]["maxWeight"]);
          }
        }
      });
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
