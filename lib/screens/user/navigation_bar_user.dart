import 'package:flutter/material.dart';
import 'package:flutter_food_rania/screens/admin/addfood.dart';
import 'package:flutter_food_rania/screens/user/favorite_page_user.dart';
import 'package:flutter_food_rania/screens/admin/home_page.dart';
import 'package:flutter_food_rania/screens/user/home_page_user.dart';
import 'package:flutter_food_rania/screens/admin/profile_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavigationBarUserPage extends StatefulWidget {
  int selectedIndex;
  NavigationBarUserPage({@required this.selectedIndex});
  @override
  _NavigationBarUserPageState createState() => _NavigationBarUserPageState();
}

class _NavigationBarUserPageState extends State<NavigationBarUserPage> {
  final List<Widget> _children = [
    HomeUserPage(),
     FavoritePageUser(),
    // ImageCapture(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _children[widget.selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.white,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.white,
        height: 50,
        index: widget.selectedIndex,
        onTap: (index) {
          setState(() {
            widget.selectedIndex = index;
          });
        },
        items: <Widget>[
          Icon(
            Icons.home,
            size: 26,
            color: Colors.black,
          ),
          Icon(
            Icons.favorite,
            size: 26,
            color: Colors.black,
          ),
          Icon(
            Icons.account_circle_outlined,
            size: 26,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
