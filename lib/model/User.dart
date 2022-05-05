import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  int _id;
  String _name;
  bool _isLogin;
  String _picoKey;

  User(this._id, this._name, this._isLogin, this._picoKey );

  void setId(int id){
    _id = id;
    notifyListeners();
  }
  get id => _id;

  void setName(String name){
    _name = name;
    notifyListeners();
  }
  get name => _name;

  void setHumidity(bool humidity){
    _isLogin = humidity;
    notifyListeners();
  }
  get isLogin => _isLogin;

  void setPicoKey(String picoKey){
    _picoKey = picoKey;
    notifyListeners();
  }
  get picoKey => _picoKey;
}