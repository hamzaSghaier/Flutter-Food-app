import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_food_rania/screens/admin/addfood.dart';
import 'package:flutter_food_rania/screens/user/favorite_page_user.dart';
import 'package:flutter_food_rania/screens/admin/home_page.dart';
import 'package:flutter_food_rania/screens/user/home_page_user.dart';
import 'package:flutter_food_rania/screens/admin/profile_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:gradient_text/gradient_text.dart';

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
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.blueGrey,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: GradientText(
            "Rania food",
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 251, 120, 255),
                Color.fromARGB(255, 227, 6, 172),
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
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            color: Colors.black,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: _children[widget.selectedIndex],
      ),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'images/rania.png',
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      widget.selectedIndex = 0;
                    });
                    _advancedDrawerController.hideDrawer();
                  },
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      widget.selectedIndex = 1;
                    });
                     _advancedDrawerController.hideDrawer();
                  },
                  leading: Icon(Icons.favorite),
                  title: Text('Favourites'),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      widget.selectedIndex = 2;
                    });
                     _advancedDrawerController.hideDrawer();
                  },
                  leading: Icon(Icons.account_circle_rounded),
                  title: Text('Profile'),
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Text('copyrigth @Rania 2023'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  // @override
  // Widget build(BuildContext context) {
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
  //           Icons.favorite,
  //           size: 26,
  //           color: Colors.black,
  //         ),
  //         Icon(
  //           Icons.account_circle_outlined,
  //           size: 26,
  //           color: Colors.black,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
