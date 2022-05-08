import 'package:esp32_ctr/pages/mine_page.dart';
import 'package:esp32_ctr/pages/scan_page.dart';
import 'package:esp32_ctr/utils/SocketConnect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'pages/config_page.dart';
import 'pages/home_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  var _currentIndex = 0;
  List<Widget> pages = <Widget>[];
   static Color appBarColor = Colors.black;
   List<Color> appBarBgColors = <Color>[Color.fromRGBO(47, 185, 202, 0.3), Color.fromRGBO(255,255,255,0.1)];
   List<Widget> appbarTitile = <Widget>[Row(
     crossAxisAlignment: CrossAxisAlignment.center,
     children: [
        const Center(
          child: Text("欢迎回来, ofg",
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1,
          color: Color(0xFF303E57),
          )),
        ),
       const SizedBox(width: 10,),
       Container(
       width: 25,
       height: 25,
       child: Transform.rotate(
           angle: 0,
           child: Icon(Icons.link_off_rounded,color: Colors.grey,size: 19,)),
     )],
   ), Text("")];

  @override
  void initState() {  // TODO: implement initState3
    super.initState();
    //开启socket
    SocketConnect.connects(context);
    pages
      ..add(HomePage())
      ..add(MinePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColors[_currentIndex],
        elevation: 0,
        title: appbarTitile[_currentIndex],
        actions: [_currentIndex == 0 ?
        GestureDetector(
            onTap: () =>{
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return ScanPage();
              }))
            },
            child: Align(
              child: Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                boxShadow: [BoxShadow(color: Color.fromRGBO(0,0,0,.2),blurRadius:3.0)],
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.45],
                  colors: [
                    Colors.redAccent,
                    Colors.red,
                  ],
                ),
              ),
              child: Icon(Icons.add,color: Colors.white,size: 22),
          ),
            )
        )
        : SizedBox()
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        margin: const EdgeInsets.all(12),
        // itemPadding: EdgeInsets.fromLTRB(8,5,8,5),
        curve: Curves.ease,
        decoration: new BoxDecoration(
          // boxShadow: [BoxShadow(color: Color.fromRGBO(240,240,240,1), blurRadius: 8.0)],
          color: Color(0xFFF8F9FC)
        ),
        duration: const Duration(milliseconds: 250),
        currentIndex: _currentIndex,
        // itemPadding: EdgeInsets.only(left: ),
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.house_alt_fill),
            title: const Text("主页"),
            selectedColor: Colors.teal,
          ),
          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.person_fill),
            title: const Text("我的"),
            selectedColor: Colors.purple,
          ),
        ],
      ),
      body: pages[_currentIndex],
    );
  }


}
