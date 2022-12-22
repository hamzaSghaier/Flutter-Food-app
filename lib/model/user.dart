import 'dart:io';

class Users {
  String displayName;
  String email;
  String password;
  String role;
  String uuid;
  String bio;
  String profilePic;
  File profileFile;

  Users();

  Users.fromMap(Map<String, dynamic> data) {
    displayName = data['displayName'];
    email = data['email'];
    password = data['password'];
    role = data['role'];
    uuid = data['uuid'];
    bio = data['bio'];
    profilePic = data['profilePic'];
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'password': password,
      'role': role,
      'uuid': uuid,
      'bio': bio,
      'profilePic': profilePic,
    };
  }
}
