
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
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;



uploadFoodAndImages(Food food, File localFile, BuildContext context) async {
  if (localFile != null) {
    print('uploading img file');

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('images/$uuid$fileExtension');

    TaskSnapshot task = await firebaseStorageRef.putFile(localFile);

    String url = await firebaseStorageRef.getDownloadURL();
    print('dw url $url');
    _uploadFood(food, context, imageUrl: url);
  } else {
    print('skipping img upload');
    _uploadFood(food, context);
  }
}


_uploadFood(Food food, BuildContext context, {String imageUrl}) async {
  User currentUser = await FirebaseAuth.instance.currentUser;
  CollectionReference foodRef = FirebaseFirestore.instance.collection('foods');
  bool complete = true;
  if (imageUrl != null) {
    print(imageUrl);
    try {
      food.img = imageUrl;
      print(food.img);
    } catch (e) {
      print(e);
    }

    food.createdAt = Timestamp.now();
    food.userUuidOfPost = currentUser.uid;
    await foodRef.add(food.toMap()).catchError((e) => print(e)).then((value) => complete = true);

    print('uploaded food successfully');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return NavigationBarPage(
            selectedIndex: 0,
          );
        },
      ),
    );
  }
  return complete;
}

uploadUserData(Users user, bool userdataUpload) async {
  bool userDataUploadVar = userdataUpload;
  User currentUser = await FirebaseAuth.instance.currentUser;

  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  user.uuid = currentUser.uid;
  if (userDataUploadVar != true) {
    await userRef.doc(currentUser.uid).set(user.toMap()).catchError((e) => print(e)).then((value) => userDataUploadVar = true);
  } else {
    print('already uploaded user data');
  }
  print('user data uploaded successfully');
}

getUserDetails(AuthNotifier authNotifier) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(authNotifier.user.uid)
      .get()
      .catchError((e) => print(e))
      .then((value) => authNotifier.setUserDetails(Users.fromMap(value.data())));
}