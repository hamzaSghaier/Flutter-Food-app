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
import 'package:flutter_food_hamza/services/storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;



signOut(AuthNotifier authNotifier, BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  authNotifier.setUser(null);
  print('log out');
  Navigator.push(
    context,
    MaterialPageRoute(builder: (BuildContext context) {
      return LoginPage();
    }),
  );
}

initializeCurrentUser(AuthNotifier authNotifier, BuildContext context) async {
  User firebaseUser = await FirebaseAuth.instance.currentUser;
  if (firebaseUser != null) {
    authNotifier.setUser(firebaseUser);
    await getUserDetails(authNotifier);
  }
}



uploadProfilePic(File localFile, Users user) async {
  User currentUser = await FirebaseAuth.instance.currentUser;
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

  if (localFile != null) {
    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('profilePictures/$uuid$fileExtension');

    UploadTask task = firebaseStorageRef.putFile(localFile);

    TaskSnapshot taskSnapshot = await task.snapshot;

    String profilePicUrl = await taskSnapshot.ref.getDownloadURL();
    print('dw url of profile img $profilePicUrl');

    try {
      user.profilePic = profilePicUrl;
      print(user.profilePic);
      await userRef.doc(currentUser.uid).set({'profilePic': user.profilePic}, SetOptions(merge: true)).catchError((e) => print(e));
    } catch (e) {
      print(e);
    }
  } else {
    print('skipping profilepic upload');
  }
}


getFoods(FoodNotifier foodNotifier) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('foods').orderBy('createdAt', descending: true).get();

  List<Food> foodList = [];

  await snapshot.docs.forEach((doc) async {
    Food food = Food.fromMap(doc.data());

    await FirebaseFirestore.instance.collection('users').doc(doc.data()['userUuidOfPost']).get().catchError((e) => print(e)).then((value) {
      food.userName = value.data()['displayName'];
      food.profilePictureOfUser = value.data()['profilePic'];
    }).whenComplete(() => foodList.add(food));

    if (foodList.isNotEmpty) {
      foodNotifier.foodList = foodList;
      print("dine");
      print(foodList[0].userName);
    }
  });
}
