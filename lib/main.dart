import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/landing_page.dart';
import 'notifier/auth_notifier.dart';
import 'notifier/food_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthNotifier(),
      ),
      ChangeNotifierProvider(
        create: (_) => FoodNotifier(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food hamza',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 0, 0, 0),
      ),
      home: Scaffold(
        body: LandingPage(),
      ),
    );
  }
}
