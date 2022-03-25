import 'package:flutter/material.dart';

class Led extends ChangeNotifier {
  bool _power;
  Led(this._power);

  void setPower(bool power){
    _power = power;
    notifyListeners();
  }
  get power => _power;
}