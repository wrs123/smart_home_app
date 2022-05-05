import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../model/Data.dart';
enum SocketState{
  START,
  CLOSE
}

class SocketConnect{

  static String host = '192.168.1.103';
  static String port = '8091';
  static int commandTime = 20;        // 向后台发送心跳的时间
  static late Timer timer;
  static bool socketStatus = false;  //socket状态
  static late IOWebSocketChannel channel;
  static var temp = 00.00, hum = 00;
  static SocketState state = SocketState.CLOSE;


  // static getData(){
  //   return data;
  // }


  static connects(BuildContext context) async{

    channel = IOWebSocketChannel.connect(Uri.parse('ws://'+host+':'+port+'/app'));
    socketStatus = true; //连接状态

    heartbeatSocket(); //定时发送心跳
    // channel.sink.add(json.encode(arguments));
    // channel.stream.listen((message) {
    //   print(message);
    //   // channel.sink.add('received!');
    //   // channel.sink.close(status.goingAway);
    // });

    //状态为START时开始接收数据
    channel.stream.listen((event) {
      if(state == SocketState.START){
        var obj = json.decode(event);
        temp = obj['data']['temp']+0.0;
        hum = obj['data']['hum'];
        print(temp);
        print(hum);

        // print(Provider.of<Data>(context, listen: false));
        Provider.of<Data>(context, listen: false).setTemperature(temp);
        Provider.of<Data>(context, listen: false).setHumidity(hum);
      }




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

  static start(){
    state = SocketState.START;
  }

  static close(){
    state = SocketState.CLOSE;
  }

}
