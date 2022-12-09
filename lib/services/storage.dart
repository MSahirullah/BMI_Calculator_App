import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

import 'dart:io';

class Storage {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseAuth auth;

  Storage({required this.auth});

  Future<String> uploadUserProfilePicture(
      String filePath, String userID) async {
    String uploadedFileURL = '';
    File image = File(filePath);
    try {
      firebase_storage.Reference ref =
          storage.ref().child('users/$userID/${path.basename(image.path)}');

      firebase_storage.UploadTask uploadTask = ref.putFile(image);
      await uploadTask;
      await ref.getDownloadURL().then((value) => {uploadedFileURL = value});

      return uploadedFileURL;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteUserProfilePicture(String url) async {
    try {
      await firebase_storage.FirebaseStorage.instance.refFromURL(url).delete();
      return '1';
    } catch (e) {
      return '0';
    }
  }
}
