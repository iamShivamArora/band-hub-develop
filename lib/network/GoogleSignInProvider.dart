import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(cred);

      if (FirebaseAuth.instance.authStateChanges() == ConnectionState.waiting) {
        CircularProgressIndicator();
      }
      await googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
      notifyListeners();
    } on PlatformException catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
          msg:
              capitalizeOnlyFirstLater(e.code.replaceAll("_", " ").toString()));
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  String capitalizeOnlyFirstLater(String data) {
    if (data.trim().isEmpty) return "";

    return "${data[0].toUpperCase()}${data.substring(1)}";
  }
}
