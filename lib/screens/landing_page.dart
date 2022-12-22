import 'package:flutter/material.dart';
import 'package:flutter_food_rania/fireb/services.dart';
import 'package:flutter_food_rania/screens/auth/login_signup_page.dart';
import 'package:flutter_food_rania/notifier/auth_notifier.dart';
import 'package:flutter_food_rania/screens/admin/navigation_bar.dart';
import 'package:flutter_food_rania/screens/user/navigation_bar_user.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with TickerProviderStateMixin{
 AnimationController _controller; 
 
 
 
  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier, context);
     _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 138, 120, 1),
              Color.fromRGBO(255, 114, 117, 1),
              Color.fromRGBO(255, 63, 111, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(
            //   'food_rania',
            //   style: TextStyle(
            //     fontSize: 60,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //     fontFamily: 'MuseoModerno',
            //   ),
            // ),
          Lottie.asset('images/animacaodentro.json', controller: _controller, onLoaded: (composition) {
                                      // Configure the AnimationController with the duration of the
                                      // Lottie file and start the animation.
                                      _controller
                                        ..duration = composition.duration
                                        ..forward().whenComplete((() => 
                                         Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return (authNotifier.user == null) ? LoginPage() :authNotifier.userDetails?.role == "ADMIN"? NavigationBarPage(selectedIndex: 0) :NavigationBarUserPage(selectedIndex: 0) ;
                  },
                ))
                                        ));
                                    }, repeat: true,width:250,height:450),
            // SizedBox(
            //   height: 140,
            // ),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(context, MaterialPageRoute(
            //       builder: (BuildContext context) {
            //         return (authNotifier.user == null) ? LoginPage() :authNotifier.userDetails?.role == "ADMIN"? NavigationBarPage(selectedIndex: 0) :NavigationBarUserPage(selectedIndex: 0) ;
            //       },
            //     ));
            //   },
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //     // child: Text(
            //     //   "Explore",
            //     //   style: TextStyle(
            //     //     fontSize: 20,
            //     //     color: Color.fromRGBO(255, 63, 111, 1),
            //     //   ),
            //     // ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
