import 'package:flutter/material.dart';

class Led extends ChangeNotifier {
  int _value;
  bool _command_state;
  Led(this._value,this._command_state);

  void setValue(int value){
    _value = value;
    notifyListeners();
  }
  get value => _value;

  void setCommandState(bool commandState){
    _command_state = commandState;
    notifyListeners();
  }
  get commandState => _command_state;
}