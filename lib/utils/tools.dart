import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

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
}