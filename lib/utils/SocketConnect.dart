import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:esp32_ctr/model/Led.dart';
import 'package:esp32_ctr/model/User.dart';
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

  static String host = '192.168.0.5';
  static String port = '8091';
  static int commandTime = 20;        // 向后台发送心跳的时间
  static late Timer timer;
  static bool socketStatus = false;  //socket状态
  static late IOWebSocketChannel channel;
  static var temp = 00.00, hum = 00;
  static SocketState state = SocketState.CLOSE;
  static int id = 1;
  static int command_id = 0;
  static bool re_connect = false;
  static Duration re_connect_duration = Duration(seconds: 1);


  // static getData(){
  //   return data;
  // }


  static connects(BuildContext context,{required bool reConnect, required Duration duration}) async{
    re_connect = reConnect;
    re_connect_duration = duration;
    String key = Provider.of<User>(context, listen: false).picoKey;
    Data data = Provider.of<Data>(context, listen: false);
    channel = IOWebSocketChannel.connect(Uri.parse('ws://'+host+':'+port+'/app?'+key));
    data.setConnectStatus(true);  socketStatus = true;//连接状态

    _heartbeatSocket(); //定时发送心跳
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
        int type = obj['type'];

        switch(type) {
          case 0: { //data
            temp = obj['data']['temp']+0.0;
            hum = obj['data']['hum'];
            // print(temp);
            // print(hum);

            // print(Provider.of<Data>(context, listen: false));
            data.setTemperature(temp); //存储温度
            data.setHumidity(hum); //存储湿度
          }
          break;

          case 1: { //command
            //statements;
          }
          break;
          case 3: { //command
            print(command_id);
            if(command_id == obj['id'] && obj['data']["code"] == 0){
              if(obj['data']["command"] == 0){
                Provider.of<Led>(context, listen: false).setValue(obj['data']["value"]);
                Provider.of<Led>(context, listen: false).setCommandState(false);
              }
            }
          }
          break;

          default: {
            //statements;
          }
          break;
        }
      }




    }, //监听服务器消息
        onError: (error){
          print(error);
          socketStatus = false;
          data.setConnectStatus(false);
          _reConnect(context);
        }, //连接错误时调用
        onDone: (){
          socketStatus = false;
          data.setConnectStatus(false);
          _reConnect(context);
        }, //关闭时调用
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
  static _heartbeatSocket(){
    const duration =  Duration(seconds:1);

    callback(time) async {
      // 如果socket状态是断开的，就停止定时器
      if(!socketStatus){
        time.cancel();
      }
      if(commandTime < 1){
        print('-----------------发送心跳------------------');
        Map arguments = {
          "type":2,
        };
        channel.sink.add(json.encode(arguments));
        commandTime = 15;
      }else{
        commandTime--;
      }
    }
    timer = Timer.periodic(duration, callback);
  }


  static send(value){

    Map data = {
      "id": id,
      "from": "/app",
      "to": "/pico",
      "type": 1,
      "data": value
    };

    channel.sink.add(json.encode(data));
    command_id = id;
    id+=1;
  }

  static start(){
    state = SocketState.START;
  }

  static close(){
    state = SocketState.CLOSE;
  }

  static _reConnect(BuildContext context){
    print("重连");
    Timer timer = Timer.periodic(re_connect_duration, (timer) {
      if (socketStatus) {
        timer.cancel();
      }else{
          connects(context, reConnect: true, duration: re_connect_duration);
          print("3秒后执行定时器======${DateTime.now()}${socketStatus}");
      }

    });
  }

}
