import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_food_hamza/screens/admin/addfood.dart';
import 'package:flutter_food_hamza/screens/admin/home_page.dart';
import 'package:flutter_food_hamza/screens/admin/profile_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:gradient_text/gradient_text.dart';

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
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  final _advancedDrawerController = AdvancedDrawerController();
  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Color.fromARGB(255, 129, 134, 136),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      openScale: 1.5,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2.0,
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: Scaffold(
        appBar: AppBar(
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
                SizedBox(
                  height: 150,
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
                  leading: Icon(Icons.add_box_rounded),
                  title: Text('Add New food'),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      widget.selectedIndex = 2;
                    });
                    _advancedDrawerController.hideDrawer();
                  },
                  leading: Icon(Icons.account_circle_rounded),
                  title: Text('Profil'),
                ),
                Spacer(),
        
              ],
            ),
          ),
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
