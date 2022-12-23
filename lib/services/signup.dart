import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_food_hamza/model/food.dart';
import 'package:flutter_food_hamza/notifier/auth_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_food_hamza/model/user.dart';
import 'package:flutter_food_hamza/notifier/food_notifier.dart';
import 'package:flutter_food_hamza/screens/auth/login_signup_page.dart';
import 'package:flutter_food_hamza/screens/admin/navigation_bar.dart';
import 'package:flutter_food_hamza/screens/user/navigation_bar_user.dart';
import 'package:flutter_food_hamza/services/services.dart';
import 'package:flutter_food_hamza/services/storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;


signUp(Users user, AuthNotifier authNotifier, BuildContext context) async {
  bool userDataUploaded = false;
  UserCredential authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: user.email.trim(), password: user.password)
      .catchError((error) => print(error));

  if (authResult != null) {
    //   UserUpdateInfo updateInfo = UserUpdateInfo();
    // updateInfo.displayName = user.displayName;

    User firebaseUser = authResult.user;

    if (firebaseUser != null) {
      // await firebaseUser.updateProfile(updateInfo);
      await firebaseUser.reload();

      print("Sign Up: $firebaseUser");

      User currentUser = await FirebaseAuth.instance.currentUser;

      authNotifier.setUser(currentUser);

      uploadUserData(user, userDataUploaded);

      await getUserDetails(authNotifier);
      if (authNotifier.userDetails.role == "ADMIN") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return NavigationBarPage(selectedIndex: 0);
          }),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return NavigationBarUserPage(selectedIndex: 0);
          }),
        );
      }
    }
  }
}