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
      print(foodList[0].userName);
    }
  });
}