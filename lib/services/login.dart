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

//USER PART
login(Users user, AuthNotifier authNotifier, BuildContext context) async {
  UserCredential authResult =
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: user.email, password: user.password).catchError((error) => print(error));

  if (authResult != null) {
    User firebaseUser = authResult.user;
    if (firebaseUser != null) {
      print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
      var userData = await getUserDetails(authNotifier);
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
