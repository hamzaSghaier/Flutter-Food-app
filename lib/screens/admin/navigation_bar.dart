import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_rania/screens/admin/addfood.dart';
import 'package:flutter_food_rania/screens/admin/home_page.dart';
import 'package:flutter_food_rania/screens/admin/profile_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavigationBarPage extends StatefulWidget {
  int selectedIndex;
  NavigationBarPage({@required this.selectedIndex});
  @override
  _NavigationBarPageState createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  final List<Widget> _children = [
    HomePage(),
    AddFood(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _children[widget.selectedIndex],
      bottomNavigationBar:     CircleNavBar(
        activeIcons: const [
          Icon(Icons.home, color: Colors.deepPurple),
          Icon(Icons.add_box, color: Colors.deepPurple),
          Icon(Icons.account_circle, color: Colors.deepPurple),
        ],
        inactiveIcons: const [
          Text("Home",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          Text("Add",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          Text("Profil",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        ],
        color: Colors.white,
        circleColor: Colors.white,
        height: 60,
        circleWidth: 60,
        activeIndex: widget.selectedIndex,
        onTap: (index) {
          setState(() {
            widget.selectedIndex = index;
          });
        },
        // tabCurve: ,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: Colors.deepPurple,
        circleShadowColor: Colors.deepPurple,
        elevation: 10,
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [ Colors.blue, Colors.red ],
        ),
        circleGradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [ Colors.blue, Colors.red ],  
        ),
      ),
    );
  }
  //   Widget build(BuildContext context) {
  //   return Scaffold(
  //     extendBody: true,
  //     body: _children[widget.selectedIndex],
  //     bottomNavigationBar: CurvedNavigationBar(
  //       color: Colors.white,
  //       backgroundColor: Colors.transparent,
  //       buttonBackgroundColor: Colors.white,
  //       height: 50,
  //       index: widget.selectedIndex,
  //       onTap: (index) {
  //         setState(() {
  //           widget.selectedIndex = index;
  //         });
  //       },
  //       items: <Widget>[
  //         Icon(
  //           Icons.home,
  //           size: 26,
  //           color: Colors.black,
  //         ),
  //         Icon(
  //           Icons.add_box,
  //           size: 26,
  //           color: Colors.black,
  //         ),
  //         Icon(
  //           Icons.account_circle,
  //           size: 26,
  //           color: Colors.black,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
