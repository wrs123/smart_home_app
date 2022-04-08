import 'package:flutter/material.dart';

class WIfiInfo extends ChangeNotifier {
  String ssid;
  int level;
  bool isChoose;
  WIfiInfo(this.ssid, this.level, this.isChoose);

  // get ssid => _ssid;
  //
  // get level => _level;
  //
  // get isChoose => _isChoose;
  //
  //
  // void setIsChoose(bool isChoose){
  //   _isChoose = isChoose;
  //   notifyListeners();
  // }
  //
  // void setSsid(String ssid){
  //   _ssid = ssid;
  //   notifyListeners();
  // }
}