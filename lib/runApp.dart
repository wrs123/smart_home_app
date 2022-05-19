import 'dart:io';

import 'package:esp32_ctr/main.dart';
import 'package:esp32_ctr/model/Data.dart';
import 'package:esp32_ctr/model/Led.dart';
import 'package:esp32_ctr/model/User.dart';
import 'package:esp32_ctr/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

RunApp() async{
  WidgetsFlutterBinding.ensureInitialized();

  String picoKey = await Tools.getPicoKey();
  Map<String, dynamic> userInform = await Tools.getUserInfoFrom();
  bool isLogin = picoKey == "" ? false : true;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Data(00.00, 00, false)),
      ChangeNotifierProvider(create: (_) => User(userInform["id"], userInform["userName"], isLogin, picoKey)),
      ChangeNotifierProvider(create: (_) => Led(0, false)),
    ],
    child: const MyApp(),
  ));

  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前       MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark, systemNavigationBarColor: Colors.transparent, systemNavigationBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}