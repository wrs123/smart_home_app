import 'package:dio/dio.dart';
import 'package:esp32_ctr/assets/icons/remicicon.dart';
import 'package:esp32_ctr/index_page.dart';
import 'package:esp32_ctr/pages/home_page.dart';
import 'package:esp32_ctr/utils/httpTools.dart';
import 'package:esp32_ctr/utils/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wifi_connect/flutter_wifi_connect.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../model/wifiInfo.dart';


class WifiSelectPage extends StatefulWidget {
  const WifiSelectPage({Key? key, required this.ap_map}) : super(key: key);

  final Map ap_map;
  @override
  _WifiSelectPageState createState() => _WifiSelectPageState();
}

enum ApConnectStatus {
  connecting,
  connectFalse,
  connected
}

class _WifiSelectPageState extends State<WifiSelectPage> {

  ScrollController _scrollController = new ScrollController();
  List<WIfiInfo>? wifiList = [];
  late WIfiInfo selectWifi = new WIfiInfo("0", 0, false);
  ApConnectStatus ap_connect_status = ApConnectStatus.connecting;
  String password = "WR-';223sgjm4sd445n/....?=_-096.~6---";


  @override
  void initState() {
    // TODO: implement initState
    //连接到设备ap热点
    _connect_ap(widget.ap_map);
    super.initState();
  }


  void _connect_ap(Map map) async{
    bool? result;
    final info = NetworkInfo();
    var nowSsid = await info.getWifiName();

    if(nowSsid == map["ap_ssid"]){
      setState(() {
        ap_connect_status = ApConnectStatus.connected;
      });
      //获取wifi扫描列表
      _getScannedResults();
      return ;
    }

    try {
      result = await FlutterWifiConnect.connectToSecureNetwork(map["ap_ssid"], map["ap_password"]);
    } on PlatformException {
      print("connect error");
      // ssid = 'Failed to get ssid';
    }

    if(result??false){ 
      setState(() {
        ap_connect_status = ApConnectStatus.connected;
      });
      //获取wifi扫描列表
      _getScannedResults();
      return ;
    }

    setState(() {
      ap_connect_status = ApConnectStatus.connectFalse;
    });

  }

  Future<StartScanErrors?> _startScan() async {
    // start full scan async-ly
    final error = await WiFiScan.instance.startScan(askPermissions: true);
    if (error != null) {
     return error;
    }
  }


  void _add_wifi(){


  }

  void _pico_wifi_set() async{
    var formData = FormData.fromMap({
      "wifi_ssid": selectWifi.ssid,
      "wifi_password": password
    });
    // var data = {
    //   "wifi_ssid": selectWifi.ssid,
    //   "wifi_password": password
    // };
    var dio = Dio();
    Response response = await dio.post('http://192.168.4.1:8091/post', data: formData);
    // await HttpTools().post("/post", data: data);
    print(response.data.toString());
    String data = response.data.toString();
    if(data == "0"){
      // Navigator.of(context).pushAndRemoveUntil(
      //     new CupertinoPageRoute(builder: (context) => IndexPage()),
      //         (route) => route == null);

      // Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
      //   return IndexPage();
      // }));
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      return ;
    }

  }

  /**
   * 设置wifi密码
   */
  _setPassword(){
    if(selectWifi.ssid != "0"){
      showBottomSheet();
    }
  }

  void showBottomSheet() {
    //用于在底部打开弹框的效果
    showModalBottomSheet(
        isScrollControlled: true,
        builder: (BuildContext context) {
          //构建弹框中的内容
          return _password_input_widget(context);
        },
        backgroundColor: Colors.transparent,//重要
        context: context);
  }

  Widget _password_input_widget(BuildContext context){
    Widget widget = SingleChildScrollView(
      child: Container(
          height: 300,
          padding:  const EdgeInsets.only(top: 20, left: 10, right: 20),
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom ==0 ? 0: MediaQuery.of(context).viewInsets.bottom+50),
          decoration: const BoxDecoration(
              color:  Colors.white,
              borderRadius:BorderRadius.all(Radius.circular(20))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 50, top: 10),
                child: Text("配置密码: "+selectWifi.ssid,
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ),
              TextField(
                autofocus: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      ///设置边框的颜色
                      color: Colors.red,
                      ///设置边框的粗细
                      width: 1.0,
                    ),
                  ),
                  hintText: "请输入网络密码",
                  // enabledBorder: UnderlineInputBorder(
                  //   borderSide: BorderSide(width: 0),
                  // ),
                  // focusedBorder: UnderlineInputBorder(
                  //   borderSide: BorderSide(width: 0),
                  // ),
                ),
              ),
              GestureDetector(
                onTap: _pico_wifi_set,
                child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(top: 60, bottom: 20),
                    decoration: BoxDecoration(
                        color: !selectWifi.isChoose ? Colors.black12 : Color.fromRGBO(45,140,240,1),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Center(
                      child: Text("开始连接",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18 ,
                            color: Colors.white
                        ),
                      ),
                    )
                ),
              )
            ],
          )
      ),
    );
    return widget;
  }

  void _getScannedResults() async {
    // get scanned results

    await _startScan();
    final result = await WiFiScan.instance.getScannedResults(askPermissions: true);
    if (result.hasError){
      showToast(result.error.toString());
    } else {
      showToast("刷新完成", duration: Duration(milliseconds: 500));
      List<WiFiAccessPoint>? list = result.value;
      List<WIfiInfo>? res = [];
      bool samStatus = false;
      for(int i=0;i<list!.length;i++){
        // if(list[i].ssid == widget.ap_map["ap_ssid"]){
        //   samStatus = true;
        //   break;
        // }
        if(list[i].ssid.isNotEmpty && list[i].frequency < 3000 && list[i].ssid != widget.ap_map["ap_ssid"]){
          for(int j=0;j<res.length;j++){
            if(list[i].ssid == res[j].ssid){
              samStatus = true;
              break;
            }
          }
          if(!samStatus){
            res.add(WIfiInfo(list[i].ssid, list[i].level, false));
          }
          samStatus = false;
        }
      }
      setState(() {
        wifiList = res;
      });
    }
  }

  /**
   * wifi信息组件
   */
  Widget wifiUnit(WIfiInfo ap, int index){
    int level = ((3*(ap.level+100))/45).toInt();
    return GestureDetector(
      onTap: (){
        for(int i=0;i<wifiList!.length;i++){
          if(i == index){
            setState(() {
              wifiList![i].isChoose = true;
              selectWifi = wifiList![i];
            });
          }else{
            setState(() {
              wifiList![i].isChoose = false;
            });
          }
        }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
        decoration: BoxDecoration(
            boxShadow: [ap.isChoose ? BoxShadow(color: Color.fromRGBO(0,0,0,1),blurRadius:10.0,spreadRadius: -20.0 ) : BoxShadow(color: Color.fromRGBO(0,0,0,0))],
          color: ap.isChoose ? const Color.fromRGBO(45,140,240,1) : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(15))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(ap.ssid,
              style:  TextStyle(
                fontSize: 16,
                color: ap.isChoose ? Colors.white : Colors.black
                // color: Color.fromRGBO(r, g, b, opacity)
              ),
            ),
            Icon(level == 0 ? RemixIcon.signal_wifi_line
                  : level == 1 ? RemixIcon.signal_wifi_1_fill
                  : level == 2 ? RemixIcon.signal_wifi_2_fill
                  : level == 3 ? RemixIcon.signal_wifi_3_fill
                  : RemixIcon.signal_wifi_fill,
                color: ap.isChoose ? Colors.white : Colors.black
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("配置网络",
            style: TextStyle(
              color: Color(0xFF303E57)
            ),
          ),
          backgroundColor: Color.fromRGBO(255,255,255,0),
          elevation: 0,
          iconTheme: const IconThemeData(
             color: Color(0xFF303E57)
         ),
          actions: [
          IconButton(
              onPressed: _add_wifi,
              icon: const Icon(RemixIcon.add_circle_line,
                color: Colors.black,
              )
          ),
          IconButton(
              onPressed: _getScannedResults,
             icon: const Icon(RemixIcon.refresh_line,
                 color: Colors.black,
              )
            )
          ],
        ),
        body: ap_connect_status == ApConnectStatus.connected ? Container(
          child: Column(
            children: [
               Container(
                 width: 250,
                 height: 200,
                 margin: EdgeInsets.only(bottom: 20),
                 child: Image.asset('lib/assets/pic/wifi.png')
               ),
              SizedBox(
                height: Tools.getScreenSize(context).height-405,
                child:  wifiList!.isNotEmpty ? ListView.builder(
                  itemBuilder: (context, index){
                    return wifiUnit(wifiList![index], index);
                },
                physics: BouncingScrollPhysics(),
                itemCount: wifiList!.length,
                ) : const SizedBox(),
              ),
              GestureDetector(
                onTap: _setPassword,
                child: Container(
                  width: Tools.getScreenSize(context).width-100,
                  height: 50,
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: !selectWifi.isChoose ? Colors.black12 : Color.fromRGBO(45,140,240,1),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Center(
                    child: Text("下一步",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18 ,
                          color: !selectWifi.isChoose ? Colors.black : Colors.white
                      ),
                    ),
                  )
                ),
              )
            ],
          ),
        )
        : const Center(
          child: Text("连接设备中"),
        ),
      ),
    );
  }
}





