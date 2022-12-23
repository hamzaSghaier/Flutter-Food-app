import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_hamza/services/services.dart';
import 'package:flutter_food_hamza/notifier/auth_notifier.dart';
import 'package:flutter_food_hamza/notifier/food_notifier.dart';
import 'package:flutter_food_hamza/screens/user/detail_food_page.dart';
import 'package:flutter_food_hamza/screens/admin/navigation_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context, listen: false);
    getFoods(foodNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          foodNotifier.foodList.length != 0
              ? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: foodNotifier.foodList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Card(
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.arrow_drop_down_circle),
                                    title: Text(foodNotifier.foodList[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    subtitle: Text(
                                      foodNotifier.foodList[index].userName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(foodNotifier.foodList[index].caption,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ))),
                                  
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      // height: MediaQuery.of(context).size.height * 0.4,
                                      child: foodNotifier.foodList[index].img != null
                                          ? GestureDetector(
                                              child: Container(
                                                width: MediaQuery.of(context).size.width / 2,
                                                child: Image.network(
                                                  foodNotifier.foodList[index].img,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
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
                                            )
                                          : CircularProgressIndicator(
                                              backgroundColor: Color.fromRGBO(255, 63, 111, 1),
                                            ),
                                    ),
                                  ),ButtonBar(
                                    alignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
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
                                        child: const Text('Details'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Lottie.asset('images/resto.json', repeat: true, width: 150, height: 150),
                    SizedBox(
                      height: 20,
                    ),
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
