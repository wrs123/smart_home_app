import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_scan/wifi_scan.dart';

class WifiSelectPage extends StatefulWidget {
  const WifiSelectPage({Key? key}) : super(key: key);

  @override
  _WifiSelectPageState createState() => _WifiSelectPageState();
}


class _WifiSelectPageState extends State<WifiSelectPage> {

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (contexts, bool) {
          return [
            SliverAppBar(
                backgroundColor: Color.fromRGBO(255,255,255,0),
                iconTheme: IconThemeData(
                    color: Color(0xFF303E57)
                ),
                floating: false,
                titleSpacing: 0.0,
                brightness: Brightness.light,
                pinned: true,
                elevation: .5,
                primary: true,
                leading: null,
                title: Text("配置网络",
                  style: TextStyle(
                      color: Color(0xFF303E57)
                  ),
                )
            )
          ];
        }, body: SizedBox(),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _getScannedResults();
    super.initState();
  }


  void _getScannedResults() async {
    // get scanned results
    final result = await WiFiScan.instance.getScannedResults(askPermissions: true);
    if (result.hasError){

    } else {
      List<WiFiAccessPoint>? wifiList= result.value;
      for(int i=0;i<wifiList!.length;i++){
        print(wifiList[i].ssid);
      }
    }
  }
}




