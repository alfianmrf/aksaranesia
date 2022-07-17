import 'package:flutter/material.dart';

class UserData {
  String classCode, address, bio;
  int points, type;

  UserData({this.classCode, this.address, this.bio, this.points, this.type}); 
}

class UserNotifier extends ChangeNotifier {
  UserData user = UserData();

  void setUser(String classCode, String address, String bio, int points, int type) {
    user.classCode = classCode;
    user.bio = bio;
    user.address = address;
    user.points = points;
    user.type = type;
    notifyListeners();
  }
}