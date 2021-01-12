import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_secure/model/firestore-services.dart';
import 'package:home_secure/model/user.dart';

class Authentication {
  static String MAIL = '';

  FirebaseAuth auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  Future<bool> googleSignInMethod() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      CircularProgressIndicator();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      AuthResult authResult = await auth.signInWithCredential(credential);
      FirebaseUser user = await auth.currentUser();
      print(
          'gooogle sign in is working............................${user.email}');
      print('display name: ...................${user.displayName}');
      print('phone number........................${user.phoneNumber}');
      print(user.uid);
      MAIL = user.email;
      //create a user model
      UserModel newUser = new UserModel(
        id: user.uid,
        name: user.displayName,
        email: user.email,
      );
      //add user into database
      await FirestoreService().addUser(newUser);
    }
    return Future.value(true);
  }

  Future<bool> loginMethod(String email, String password) async {
    try {
      final newUser = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (newUser != null)
        return Future.value(true);
      else {
        return Future.value(false);
      }
    } catch (e) {
      switch (e.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          print('error');
          break;
        case 'ERROR_INVALID_EMAIL':
          print('error');
          break;
      }
    }
    return Future.value(true);
  }

  Future<bool> registerMethod(String email, String password) async {
    try {
      final newUser = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (newUser != null)
        return Future.value(true);
      else {
        return Future.value(false);
      }
    } catch (e) {
      print('Error occurred.......................$e');
    }
    return Future.value(true);
  }

  Future<bool> logout() async {
    await googleSignIn.signOut();
    await auth.signOut();
    return Future.value(true);
  }

  Future<bool> exitUser() async {
    FirebaseUser user = await auth.currentUser();
    if (user.providerData[1].providerId == 'google.com') {
      await googleSignIn.disconnect();
    }
    await auth.signOut();
    return Future.value(true);
  }
}
