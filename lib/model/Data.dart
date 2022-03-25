import 'package:flutter/material.dart';

class Data extends ChangeNotifier {
  double _temperature;
  int _humidity;
  Data(this._temperature, this._humidity);

  void setTemperature(double temperature){
    _temperature = temperature;
    notifyListeners();
  }
  get temperature => _temperature;

  void setHumidity(int humidity){
    _humidity = humidity;
    notifyListeners();
  }
  get humidity => _humidity;
}