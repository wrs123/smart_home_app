import 'package:dio/dio.dart';
import 'package:esp32_ctr/utils/httpTools.dart';

import '../../model/Result.dart';

class Api{
  final HttpTools httpUtil = new HttpTools();

  /**
   * 设备配网
   */
  Future<String> sendToPico(data) async{
    try{
      var dio = Dio();
      Response response = await dio.post('http://192.168.4.1:8091/post', data: data);
      return response.data.toString();
    }catch(e){
      print(e.toString());
      return "9";
    }
  }


  /**
   * 登录
   */
  Future<Result> login(data) async{
      var rep = await httpUtil.post("/user/login", data: data);
      return Result.fromJson(rep);
  }

  /**
   * 登出
   */
  Future<Result> logout() async{
    var rep = await httpUtil.post("/user/logout", data: {"":""});
    return Result.fromJson(rep);
  }

  /**
   * 注册
   */
  Future<Result> register(data) async{
    var rep = await httpUtil.post("/user/register", data: data);
    return Result.fromJson(rep);
  }

  Future<bool> test(data) async{

    try{
      var rep = await httpUtil.get("/index/do", data: {"":""});
      return true;
    }catch(exception){
      return false;
    }

  }


}