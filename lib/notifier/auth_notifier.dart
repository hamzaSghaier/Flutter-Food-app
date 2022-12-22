import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_food_rania/model/user.dart';

class AuthNotifier extends ChangeNotifier {
  User _user;

  User get user {
    return _user;
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  //Test
  Users _userDetails;

  Users get userDetails => _userDetails;

  setUserDetails(Users user) {
    _userDetails = user;
    notifyListeners();
  }
}
