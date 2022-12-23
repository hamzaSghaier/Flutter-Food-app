import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_hamza/services/services.dart';
import 'package:flutter_food_hamza/notifier/auth_notifier.dart';
import 'package:flutter_food_hamza/notifier/food_notifier.dart';
import 'package:flutter_food_hamza/screens/user/detail_food_page.dart';
import 'package:flutter_food_hamza/screens/admin/navigation_bar.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:overlay_support/overlay_support.dart';

class FavoritePageUser extends StatefulWidget {
  @override
  _FavoritePageUserState createState() => _FavoritePageUserState();
}

class _FavoritePageUserState extends State<FavoritePageUser> {
  AuthNotifier authNotifier;
  FoodNotifier foodNotifier;
  @override
  void initState() {
    foodNotifier = Provider.of<FoodNotifier>(context, listen: false);
    authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    getFoods(foodNotifier);
    super.initState();
  }

  Future<List<dynamic>> getListFavorites(String id) async {
    CollectionReference userRef = FirebaseFirestore.instance.collection('users');

    var userData = await FirebaseFirestore.instance.collection('users').doc(id).get();

    print(userData.data()["favorites"]);
    final growableList = userData.data()["favorites"];
    return growableList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20,left: 20,bottom: 50),
            child: GradientText(
              "Favorites",
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 14, 14, 14),
                  Color.fromARGB(255, 14, 14, 14),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FutureBuilder<List<dynamic>>(
              future: getListFavorites(authNotifier.user.uid),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.data != null && snapshot.data.length > 0) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                child: ListTile(
                              leading: Image.network(
                                snapshot.data[index]['image'],
                                fit: BoxFit.cover,
                              ),
                              title: Text(snapshot.data[index]["food"]),
                              trailing: SizedBox(
                                width: 50,
                                height: 50,
                                child: LikeButton(
                                  onTap: (bool isLiked) async {
                                    final firestoreInstance = FirebaseFirestore.instance;

                                    await firestoreInstance.collection("users").doc(authNotifier.user.uid).set({
                                      "favorites": FieldValue.arrayRemove([
                                        {"food": foodNotifier.foodList[index].name, "image": foodNotifier.foodList[index].img}
                                      ]),
                                    }, SetOptions(merge: true));
                                    setState(() {});
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
                                      Icons.delete,
                                      color: !isLiked ? Colors.red : Colors.grey,
                                      size: 20,
                                    );
                                  },
                                  // likeCount: 665,
                                ),
                              ),
                            ));
                          });
                    }
                    // return Container(
                    //   child: Text(snapshot.data()),
                    // );
                    else
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Text('...'),
                        ],
                      );
                    break;
                  default:
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text('Favorites empty'),
                      ],
                    );
                }
              }),
        ],
      ),
      // body: Column(
      //   children: <Widget>[
      //     Padding(
      //       padding: EdgeInsets.only(top: 30, left: 10, right: 10),
      //       child: authNotifier.user != null
      //           ? Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: <Widget>[
      //                 GestureDetector(
      //                   onTap: () {
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (BuildContext context) {
      //                           return NavigationBarPage(selectedIndex: 0);
      //                         },
      //                       ),
      //                     );
      //                   },
      //                   child: GradientText(
      //                     "Favorites",
      //                     gradient: LinearGradient(
      //                       colors: [
      //                         Color.fromRGBO(255, 138, 120, 1),
      //                         Color.fromRGBO(255, 63, 111, 1),
      //                       ],
      //                       begin: Alignment.centerLeft,
      //                       end: Alignment.centerRight,
      //                     ),
      //                     style: TextStyle(
      //                       fontSize: 30,
      //                       fontFamily: 'MuseoModerno',
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             )
      //           : Text(
      //               'Welcome',
      //               style: TextStyle(
      //                 fontSize: 17,
      //               ),
      //             ),
      //     ),
      //     SizedBox(
      //       height: 20,
      //     ),
      //     foodNotifier.foodList.length != 0
      //         ? Expanded(
      //             child: ListView.builder(
      //               shrinkWrap: true,
      //               physics: BouncingScrollPhysics(),
      //               itemCount: foodNotifier.foodList.length,
      //               itemBuilder: (context, index) {
      //                 return Card(
      //                     child: ListTile(
      //                   leading: Image.network(
      //                     foodNotifier.foodList[index].img,
      //                     fit: BoxFit.cover,
      //                   ),
      //                   title: Text(foodNotifier.foodList[index].userName),
      //                   subtitle: Text(foodNotifier.foodList[index].name),

      //                 ));

      //               },
      //             ),
      //           )
      //         : Column(
      //             children: <Widget>[
      //               CircularProgressIndicator(
      //                 backgroundColor: Color.fromRGBO(255, 63, 111, 1),
      //                 valueColor: AlwaysStoppedAnimation<Color>(
      //                   Color.fromRGBO(255, 138, 120, 1),
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: 20,
      //               ),
      //               Text('Loading'),
      //             ],
      //           ),
      //   ],
      // ),
    );
  }
}
