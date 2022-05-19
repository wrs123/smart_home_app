import 'package:flutter/material.dart';

class Data extends ChangeNotifier {
  double _temperature;
  int _humidity;
  bool _connectStatus;
  Data(this._temperature, this._humidity, this._connectStatus);

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

  void setConnectStatus(bool connectStatus){
    _connectStatus = connectStatus;
    notifyListeners();
  }
  get connectStatus => _connectStatus;
}