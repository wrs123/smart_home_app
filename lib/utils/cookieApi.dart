import 'dart:io';
import 'package:dio/dio.dart';
import 'package:esp32_ctr/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CookieApi {
   static getCookie(List<String>? cookies) {
    if(cookies != null){
      return cookies.map((cookie) => cookie.split(';')[0]).join('; ');
    }

   }

  saveCookies(Response response) async{
    if(response.headers['set-cookie'] != null){
      List<String>? setCookies = response.headers['set-cookie'];
      String cookies = getCookie(setCookies);
      print(cookies);

      String baseUrl = response.requestOptions.baseUrl;
      final prefs = await SharedPreferences.getInstance();
      bool result = await prefs.setString(baseUrl+";cookie", cookies);
      return result;
    }
    return false;
  }

  getCookies(String baseUrl) async{
    final prefs = await SharedPreferences.getInstance();
    final cookies = await prefs.getString(baseUrl+";cookie");

    return cookies ?? "";
  }

  delCookies(String baseUrl) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(baseUrl+";cookie");//删除
  }
}