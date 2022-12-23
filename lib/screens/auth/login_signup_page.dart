import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_hamza/services/login.dart';
import 'package:flutter_food_hamza/services/services.dart';
import 'package:flutter_food_hamza/notifier/auth_notifier.dart';
import 'package:flutter_food_hamza/screens/landing_page.dart';
import 'package:flutter_food_hamza/model/user.dart';
import 'package:flutter_food_hamza/services/signup.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

enum AuthMode { SignUp, Login }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  Users _user = Users();
  bool isSignedIn = false;
  int val = 0;

  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier, context);
    _user.role = "USER";
    super.initState();
  }

  void _submitForm() {
    if (!_formkey.currentState.validate()) {
      return;
    }

    _formkey.currentState.save();

    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    if (_authMode == AuthMode.Login) {
      login(_user, authNotifier, context);
    } else {
      signUp(_user, authNotifier, context);
    }
  }

  Widget _buildLoginForm() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 120,
        ),
        Lottie.asset('images/logo.json', width: 100, height: 100),
        SizedBox(
          height: 80,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: (String value) {
              if (value.isEmpty) {
//                return "Email is required";
                print('Email is required');
              }
              return null;
            },
            onSaved: (String value) {
              _user.email = value;
            },
            cursorColor: Colors.black,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Email',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ), //EMAIL TEXT FIELD
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            obscureText: true,
            validator: (String value) {
              if (value.isEmpty) {
//                return "Password is required";
                print("Password is required");
              }
              return null;
            },
            onSaved: (String value) {
              _user.password = value;
            },
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Password',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ), //PASSWORD TEXT FIELD
        SizedBox(
          height: 50,
        ),
        GestureDetector(
          onTap: () {
            _submitForm();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "Log In",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ), //LOGIN BUTTON
        SizedBox(
          height: 60,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Not a registered user?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _authMode = AuthMode.SignUp;
                });
              },
              child: Container(
                child: Text(
                  'Sign Up here',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignUPForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 60,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: (String value) {
              if (value.isEmpty) {
//                return "User name is required";
                print("User name is required");
              }
              return null;
            },
            onSaved: (String value) {
              _user.displayName = value;
            },
            cursorColor: Colors.black,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'User name',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            validator: (String value) {
              if (value.isEmpty) {
//                return "Email is required";
                print("Email is required");
              }
              return null;
            },
            onSaved: (String value) {
              _user.email = value;
            },
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Email',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ), //EMAIL TEXT FIELD
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            obscureText: true,
            controller: _passwordController,
            validator: (String value) {
              if (value.isEmpty) {
//                return "Password is required";
                print("Password is required");
              }
              return null;
            },
            onSaved: (String value) {
              _user.password = value;
            },
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Color.fromRGBO(255, 63, 111, 1),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Password',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ), //PASSWORD TEXT FIELD
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            validator: (String value) {
              if (value.isEmpty) {
//                return "Confirm password is required";
                print("Confirm password is required");
              }
              if (_passwordController.text != value) {
//                return "Write Correct Password";
                print("Write Correct Password");
              }
              return null;
            },
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Color.fromRGBO(255, 63, 111, 1),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Confirm Password',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ), // RE-PASSWORD TEXT FIELD
        Container(
          margin: EdgeInsets.symmetric(horizontal: 80),
          child: GestureDetector(
            onTap: () {
              setState(() {
                val = 0;
              });
            },
            child: ListTile(
              title: Text("User", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              leading: Radio(
                value: 0,
                groupValue: val,
                fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                onChanged: (value) {
                  setState(() {
                    val = value;
                    _user.role = "USER";
                  });
                },
                activeColor: Colors.black,
              ),
            ),
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 80),
          child: GestureDetector(
            onTap: () {
              setState(() {
                val = 1;
              });
            },
            child: ListTile(
              title: Text("Admin", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              leading: Radio(
                value: 1,
                groupValue: val,
                fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                onChanged: (value) {
                  setState(() {
                    val = value;
                    value == 0 ? _user.role = "USER" : _user.role = "ADMIN";
                  });
                },
                activeColor: Colors.black,
              ),
            ),
          ),
        ),

        SizedBox(
          height: 50,
        ),
        GestureDetector(
          onTap: () {
            _submitForm();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 60,
        ), //LOGIN BUTTON
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Connect ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _authMode = AuthMode.Login;
                });
              },
              child: Container(
                child: Text(
                  'Log In here',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 110, 105, 104),
              Color.fromARGB(255, 116, 105, 105),
              Color.fromARGB(255, 249, 222, 229),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_authMode == AuthMode.Login ? _buildLoginForm() : _buildSignUPForm()],
            ),
          ),
        ),
      ),
    );
  }
}
