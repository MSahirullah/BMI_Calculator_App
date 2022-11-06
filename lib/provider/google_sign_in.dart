import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser =
          await googleSignIn.signIn().catchError((onError) => print(onError));

      if (googleUser == null) return null;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      // ignore: empty_catches
    } catch (e) {}

    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}