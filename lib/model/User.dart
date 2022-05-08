import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  String _id;
  String _name;
  bool _isLogin;
  String _picoKey;

  User(this._id, this._name, this._isLogin, this._picoKey );

  void setAll({String? id, String? name, bool? isLogin, String? picoKey}){
    this._id = id ?? "";
    this._name = name ?? "";
    this._isLogin = isLogin ?? false;
    this._picoKey = picoKey ?? "";
    notifyListeners();
  }

  void setId(String id){
    _id = id;
    notifyListeners();
  }
  get id => _id;

  void setName(String name){
    _name = name;
    notifyListeners();
  }
  get name => _name;

  void setIsLogin(bool isLogin){
    _isLogin = isLogin;
    notifyListeners();
  }
  get isLogin => _isLogin;

  void setPicoKey(String picoKey){
    _picoKey = picoKey;
    notifyListeners();
  }
  get picoKey => _picoKey;
}