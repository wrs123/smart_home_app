import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../model/Data.dart';
class SocketConnect{

  static String host = "192.168.0.8";
  static int port = 8091;
  static int commandTime = 20;        // 向后台发送心跳的时间
  static late Timer timer;
  static bool socketStatus = false;  //socket状态
  static var channel;
  static var temp = 00.00, hum = 00;


  // static getData(){
  //   return data;
  // }


  static connects(BuildContext context) async{

    channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.0.9:8091/app'));
    socketStatus = true; //连接状态
    heartbeatSocket();
    // channel.sink.add(json.encode(arguments));
    // channel.stream.listen((message) {
    //   print(message);
    //   // channel.sink.add('received!');
    //   // channel.sink.close(status.goingAway);
    // });

    channel.stream.listen((event) {
      var obj = json.decode(event);
      temp = obj['data']['temp']+0.0;
      hum = obj['data']['hum'];
      Provider.of<Data>(context, listen: false).setTemperature(temp);
      Provider.of<Data>(context, listen: false).setHumidity(hum);
      print(temp);
      print(hum);
    }, //监听服务器消息
        onError: (error){print(error);socketStatus = false;}, //连接错误时调用
        onDone: (){}, //关闭时调用
        cancelOnError:true //设置错误时取消订阅
    );

  }

  static dataHandler(data) async {
    print('-------Socket发送来的消息-------');
    var cnData = await utf8.decode(data);       // 将信息转为正常文字
    var response = json.decode(cnData.toString());

    print(response.temp);

  }


  // 心跳机，每15秒给后台发送一次，用来保持连接
  static heartbeatSocket(){
    const duration =  Duration(seconds:1);

    callback(time) async {
      // 如果socket状态是断开的，就停止定时器
      if(!socketStatus){
        time.cancel();
      }
      if(commandTime < 1){
        print('-----------------发送心跳------------------');
        Map arguments = {
          "type":"heartbeat",
        };
        channel.sink.add(json.encode(arguments));
        commandTime = 15;
      }else{
        commandTime--;
      }
    }
    timer = Timer.periodic(duration, callback);
  }

  //led控制
  // static LEDControl(bool status){
  //   Map data = {
  //     "from": "/app",
  //     "to": "/pico",
  //     "type": "ctr",
  //     "data": {
  //       'led': status
  //     }
  //   };
  //   print("发送数据");
  //   channel.sink.add(json.encode(data));
  // }

  static send(value){

    Map data = {
      "from": "/app",
      "to": "/pico",
      "type": "ctr",
      "data": value
    };

    channel.sink.add(json.encode(data));
  }

}