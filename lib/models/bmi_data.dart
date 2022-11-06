import 'package:cloud_firestore/cloud_firestore.dart';

class BMIModel {
  late String weight;
  late String height;
  late String bmi;
  late String date;

  BMIModel(
      {required this.weight,
      required this.bmi,
      required this.date,
      required this.height});

  BMIModel.fromDocumentSnapshot({DocumentSnapshot? documentSnapshot}) {
    weight = documentSnapshot!.get('weight');
    height = documentSnapshot.get('height');
    bmi = documentSnapshot.get('bmi');
    date = documentSnapshot.get('date');
  }
}
