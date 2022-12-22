import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_food_rania/model/food.dart';
import 'package:flutter_food_rania/notifier/auth_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_food_rania/model/user.dart';
import 'package:flutter_food_rania/notifier/food_notifier.dart';
import 'package:flutter_food_rania/screens/auth/login_signup_page.dart';
import 'package:flutter_food_rania/screens/admin/navigation_bar.dart';
import 'package:flutter_food_rania/screens/user/navigation_bar_user.dart';
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
