import 'dart:async';

import 'package:ar_games_v0/features/photo_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      print("Entered the Sign in code");
      final GoogleSignIn _googleSignIn = GoogleSignIn(
          clientId:
          "398810094819-f37hruk93ckq8479aka0e7pvvb5dpvab.apps.googleusercontent.com");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication? googleAuth =
      await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential =
      await _firebaseAuth.signInWithCredential(credential);
      debugPrint("Login successful, I think");
      print(userCredential);

      // Navigate to PhotoPickerScreen on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PhotoPickerScreen()),
      );

      return userCredential;
    } on Exception catch (e) {
      // Handle exceptions (similar to MyHomePage)
      print('Error signing in: $e');
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: signInWithGoogle,
              child: Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
