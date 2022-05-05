import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tools{

  Tools._();

  static Size getScreenSize(BuildContext context){
    return MediaQuery.of(context).size;
  }

  static const MethodChannel _channel = const MethodChannel('wifi_channel');

  static Future<bool> connectWifi({required String ssid, String? password, String? bssid, bool isWEP = false}) async {
    final result = await _channel.invokeMethod<bool>('connectToWifi', {
      'ssid': ssid,
      'password': password,
      'bssid': bssid,
      'isWEP': isWEP,
    });
    return result == true;
  }

  static Future<String> getOsPath() async{
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    return appDocPath;
  }

  static Future<bool> saveData(Map data) async{
    final prefs = await SharedPreferences.getInstance();
    bool result = true;
    data.forEach((key, value) async{
      bool state = await prefs.setString(key, value);
      result && state ? true: false;
    });

    return result;
  }

  static Future getData(String key) async{
    final prefs = await SharedPreferences.getInstance();

    String? result = await prefs.getString(key);
    if(result == null){
      result = "";
    }
    return result;
  }

  static Future<bool> savePicoKey(String picoKey) async{
    bool result = await saveData({"picoKey": picoKey});

    return result;
  }

  static Future<bool> saveUserInfoFrom(Map data) async{
    final prefs = await SharedPreferences.getInstance();
    bool result = true;
    data.forEach((key, value) async{
      bool state = await prefs.setString(key, value.toString());
      result && state ? true: false;
    });

    return result;
  }


  static Future<Map<String, dynamic>> getUserInfoFrom() async{
    Map<String, dynamic> result = new HashMap();

    String userName = await getData("name");
    String id = await getData("id");

    result = {
      "userName": userName,
      "id": id
    };
    return result;
  }

  static Future<String> getPicoKey() async{
    String result = await getData("picoKey");

    return result;
  }
}