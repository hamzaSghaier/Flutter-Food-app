import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_rania/fireb/services.dart';
import 'package:flutter_food_rania/notifier/auth_notifier.dart';
import 'package:flutter_food_rania/notifier/food_notifier.dart';
import 'package:flutter_food_rania/screens/user/detail_food_page.dart';
import 'package:flutter_food_rania/screens/admin/navigation_bar.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:overlay_support/overlay_support.dart';

class HomeUserPage extends StatefulWidget {
  @override
  _HomeUserPageState createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  AuthNotifier authNotifier;
  FoodNotifier foodNotifier;
  @override
  void initState() {
    foodNotifier = Provider.of<FoodNotifier>(context, listen: false);
    authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    getFoods(foodNotifier);
    super.initState();
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;
  }

  @override
  Widget build(BuildContext context) {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30, left: 10, right: 10),
            child: authNotifier.user != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return NavigationBarPage(selectedIndex: 0);
                              },
                            ),
                          );
                        },
                        child: GradientText(
                          "food_rania",
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 138, 120, 1),
                              Color.fromRGBO(255, 63, 111, 1),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'MuseoModerno',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
          ),
          SizedBox(
            height: 20,
          ),
          foodNotifier.foodList.length != 0
              ? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: foodNotifier.foodList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return FoodDetailPage(
                                  imgUrl: foodNotifier.foodList[index].img,
                                  imageName: foodNotifier.foodList[index].name,
                                  imageCaption: foodNotifier.foodList[index].caption,
                                  userName: foodNotifier.foodList[index].userName,
                                  createdTimeOfPost: foodNotifier.foodList[index].createdAt.toDate(),
                                );
                              },
                            ),
                          );
                        },
                        child: Card(
                            child: ListTile(
                          leading: Image.network(
                            foodNotifier.foodList[index].img,
                            fit: BoxFit.cover,
                          ),
                          title: Text(foodNotifier.foodList[index].userName),
                          subtitle: Text(foodNotifier.foodList[index].name),
                          trailing: SizedBox(
                              width: 50,
                              height: 50,
                              child: LikeButton(
                                  onTap: (bool isLiked) async {
                                    final firestoreInstance = FirebaseFirestore.instance;
                                    if (!isLiked) {
                                      await firestoreInstance.collection("users").doc(authNotifier.user.uid).set({
                                        "favorites": FieldValue.arrayUnion([
                                          {"food": foodNotifier.foodList[index].name, "image": foodNotifier.foodList[index].img}
                                        ]),
                                      }, SetOptions(merge: true));
                                    } else {
                                      await firestoreInstance.collection("users").doc(authNotifier.user.uid).set({
                                        "favorites": FieldValue.arrayRemove([
                                          {"food": foodNotifier.foodList[index].name, "image": foodNotifier.foodList[index].img}
                                        ]),
                                      }, SetOptions(merge: true));
                                    }
                                    return !isLiked;
                                  },
                                  size: 20,
                                  circleColor: CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                                  bubblesColor: BubblesColor(
                                    dotPrimaryColor: Color(0xff33b5e5),
                                    dotSecondaryColor: Color(0xff0099cc),
                                  ),
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      Icons.favorite,
                                      color: isLiked ? Colors.red : Colors.grey,
                                      size: 20,
                                    );
                                  },
                                  // likeCount: 665,
                                  countBuilder: (int count, bool isLiked, String text) {
                                    var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
                                    Widget result;
                                    if (count == 0) {
                                      result = Text(
                                        "love",
                                        style: TextStyle(color: color),
                                      );
                                    } else
                                      result = Text(
                                        text,
                                        style: TextStyle(color: color),
                                      );
                                    return result;
                                  })),
                        )),
                      );
                    },
                  ),
                )
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Lottie.asset('images/Loader.json', repeat: true, width: 100, height: 100),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Loading'),
                  ],
                ),
        ],
      ),
    );
  }
}
