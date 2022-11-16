import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String name;
  late String weight;
  late String height;
  late String gender;
  late DateTime dob;
  late String profile;

  UserModel(
    this.profile, {
    required this.name,
    required this.weight,
    required this.height,
    required this.gender,
    required this.dob,
  });

  UserModel.fromDocumentSnapshot({DocumentSnapshot? documentSnapshot}) {
    name = documentSnapshot!.get('name');
    weight = documentSnapshot.get('weightt');
    height = documentSnapshot.get('height');
    gender = documentSnapshot.get('gender');
    dob = documentSnapshot.get('dob');
    profile = documentSnapshot.get('profile');
  }
}
