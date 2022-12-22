import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_rania/fireb/services.dart';
import 'package:flutter_food_rania/notifier/auth_notifier.dart';
import 'package:flutter_food_rania/screens/admin/edit_profile_page.dart';
import 'package:flutter_food_rania/screens/user/detail_food_page.dart';
import 'package:flutter_food_rania/widget/custom_raised_button.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  signOutUser() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    if (authNotifier.user != null) {
      signOut(authNotifier, context);
    }
  }

  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    getUserDetails(authNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 30, right: 10),
                  child: GestureDetector(
                    onTap: () {
                      signOutUser();
                    },
                    child: Icon(
                      Icons.logout,
                    ),
                  ),
                ),
              ],
            ),
            authNotifier.userDetails.profilePic != null
                ? CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage(authNotifier.userDetails.profilePic),
                    backgroundColor: Colors.transparent,
                  )
                : Container(
                    decoration: new BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    width: 100,
                    child: Icon(
                      Icons.person,
                      size: 70,
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
            authNotifier.userDetails.displayName != null
                ? Text(
                    authNotifier.userDetails.displayName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'MuseoModerno',
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text("You don't have a user name"),
            authNotifier.userDetails.bio != null
                ? Text(
                    authNotifier.userDetails.bio,
                    style: TextStyle(fontSize: 15),
                  )
                : Text(""),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return EditProfile();
                  }),
                );
              },
              child: CustomRaisedButton(buttonText: 'Edit Profile'),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('foods').where('userUuidOfPost', isEqualTo: authNotifier.userDetails.uuid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.docs.length > 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Column(
                            children: [
                              GestureDetector(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    child: Image.network(
                                      snapshot.data.docs[index]['img'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return FoodDetailPage(
                                          imgUrl: snapshot.data.docs[index]['img'],
                                          imageName: snapshot.data.docs[index]['name'],
                                          imageCaption: snapshot.data.docs[index]['caption'],
                                          createdTimeOfPost: snapshot.data.docs[index]['createdAt'].toDate(),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: LikeButton(
                                  onTap: (bool isLiked) async {
                                    final firestoreInstance = FirebaseFirestore.instance;

                                    await firestoreInstance.collection("foods").doc(snapshot.data.docs[index].id).delete();
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
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
               
                    // child: Lottie.asset('images/confused-and-angry-chef.json', repeat: true, width: 200, height: 150),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
