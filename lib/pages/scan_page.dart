import 'dart:convert';

import 'package:esp32_ctr/pages/wifi_select_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:oktoast/oktoast.dart';
import 'package:scan/scan.dart';

class ScanPage extends StatelessWidget {
  ScanPage({Key? key}) : super(key: key);

  final ScanController _controller = ScanController();


  void getResult(String result, BuildContext context) async{
    _controller.pause(); //停止扫描
    Map<String, dynamic> res;
    print(result);
    try{
      res = json.decode(result);
      if(!(res.containsKey("ap_ssid") && res.containsKey("ap_password"))){
        print("违法的二维码");
        showToastWidget(toastTemplate("违法的二维码"),
            duration: Duration(milliseconds: 1000),
            position: ToastPosition(align: Alignment.topCenter, offset: 100)
        );
        return;
      }
      Map map = {
        "ap_ssid": res["ap_ssid"],
        "ap_password": res["ap_password"],
        "ap_bssid": res["ap_bssid"]
      };
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
        return WifiSelectPage(ap_map: map,);
      }));

    }on FormatException{
      showToastWidget(toastTemplate("错误格式的二维码"),
          duration: Duration(milliseconds: 1000),
          position: ToastPosition(align: Alignment.topCenter, offset: 100)
      );
      Future.delayed(Duration(milliseconds: 1000), (){
        _controller.resume();
      });
    } catch(e){
      showToast(e.toString());
      print("1111111"+e.toString());
      return ;
    }

  }

  Widget toastTemplate(String text){
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w400
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        child: Stack(
            children: [
              ScanView(
              controller: _controller,
              scanLineColor: const Color(0xFF4759DA),
              onCapture: (data) {
                getResult(data,context);
              },
            ),
              Positioned(
                top: 35,
                left: 0,
                child: Container(
                  // color: Colors.black,
                  width:  MediaQuery.of(context).size.width,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 100,
                  left: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("请将二维码置于扫描框内",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                        ),
                      )
                    ],
              ))
              // Positioned(
              //   left: WH.w(100),
              //   bottom: WH.w(100),
              //   child: StatefulBuilder(
              //     builder: (BuildContext context, StateSetter setState) {
              //       return MaterialButton(
              //           child: Icon(lightIcon,size: WH.w(80),color: Color(0xFF4759DA),),
              //           onPressed: (){
              //             _controller.toggleTorchMode();
              //             if (lightIcon == Icons.flash_on){
              //               lightIcon = Icons.flash_off;
              //             }else {
              //               lightIcon = Icons.flash_on;
              //             }
              //             setState((){});
              //           }
              //       );
              //     },
              //   ),
              // ),
              // Positioned(
              //   right: WH.w(100),
              //   bottom: WH.w(100),
              //   child: MaterialButton(
              //       child: Icon(Icons.image,size: WH.w(80),color: Color(0xFF4759DA),),
              //       onPressed: () async {
              //         List<Media>? res = await ImagesPicker.pick(
              //             count: 1,
              //             maxSize: 1024
              //         );
              //         if (res != null) {
              //           _controller.pause();
              //           Media image = res.first;
              //           String? result = await Scan.parse(image.path);
              //           if(result != null){
              //             getResult(result,context);
              //           }
              //         }
              //       }
              //   ),
              // ),
            ]
        ),
      ),
    );
  }
}
