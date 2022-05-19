import 'package:card_swiper/card_swiper.dart';
import 'package:esp32_ctr/model/Led.dart';
import 'package:esp32_ctr/pico_command/led_command.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';
// import 'package:vibration/vibration.dart';



import '../model/Data.dart';
import '../utils/SocketConnect.dart';
import '../utils/tools.dart';
import 'led_ctr_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> deviceList =  <Widget>[];


  @override
  Widget build(BuildContext context) {

    return Container(
      // padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.75],
              colors: [
                Color.fromRGBO(47, 185, 202, 0.3),
                Color(0xFFF8F9FC),
              ],
            ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child: Container(
                      height: Tools.getScreenSize(context).width-50,
                      // constraints: BoxConstraints(maxHeight:mediaQuery.size.width-50,maxWidth: mediaQuery.size.width-50 ),
                      // alignment: Alignment.center,
                      margin: const EdgeInsets.all(15),
                      // padding: const EdgeInsets.all(50),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: const BorderRadius.all(const Radius.circular(200)),
                            ),
                            child: Neumorphic(
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.concave,
                                  shadowLightColorEmboss: const Color.fromRGBO(0,0,0,.2),
                                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(200)),
                                  depth: -5,
                                  lightSource: LightSource.topLeft,
                                  color: const Color.fromRGBO(46,183,201,1),
                                ),
                                child: Container(
                                  height: Tools.getScreenSize(context).width-100,
                                  width: Tools.getScreenSize(context).width-100,
                                  // decoration: const BoxDecoration(
                                  //   borderRadius: BorderRadius.all(Radius.circular(200)),
                                  //   boxShadow: [BoxShadow(color: Color.fromRGBO(0,0,0,1),blurRadius:10.0,spreadRadius: -20.0 )],
                                  //   gradient: LinearGradient(
                                  //     begin: Alignment.topCenter,
                                  //     end: Alignment.bottomCenter,
                                  //     colors: [
                                  //       Color.fromRGBO(46,183,201,1),
                                  //       Color.fromRGBO(67,216,205,1),
                                  //     ],
                                  //   ),
                                  // ),
                                )
                            ),
                          )
                          ),
                          Positioned(child: Neumorphic(
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.convex,
                                shadowLightColorEmboss: const Color.fromRGBO(0,0,0,.2),
                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(200)),
                                depth: 25,
                                lightSource: LightSource.topLeft,
                                color: Colors.white,
                              ),
                              child: ChangeNotifierProvider(
                                create: (BuildContext context) {  },
                                child: Consumer<Data>(
                                  builder: (context, model, child){
                                    Data th = Provider.of<Data>(context, listen: true);

                                    return Container(
                                      height: Tools.getScreenSize(context).width-190,
                                      width: Tools.getScreenSize(context).width-190,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Text("室内温度",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFF303E57)
                                            ),
                                          ),
                                          // Padding(padding: EdgeInsets.only(top: 10)),

                                          Text(th.temperature.toStringAsFixed(1)+'℃',
                                              style: const TextStyle(
                                                  fontSize: 50,
                                                  color: Color(0xFF303E57)
                                              )
                                          ),
                                          Text(th.humidity.toStringAsFixed(1)+'%',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xFF303E57)
                                              )
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                          )),
                        ],
                      ),
                    ),
                  ),
                  // Positioned(
                  //   child: ,
                  //   left: 20,
                  //   top: 15,
                  // ),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: const Text("全部设备",
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                  ),
                  Container(
                    height: Tools.getScreenSize(context).height - Tools.getScreenSize(context).width-30-50-117,
                     child: GridView.count(
                       crossAxisCount: 2,
                       mainAxisSpacing: 12,
                       crossAxisSpacing: 10,
                       childAspectRatio: 1,
                       children: deviceList,
                     ),
                  )
                ],
              ),
            )
          ],
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _buildGrid();
    SocketConnect.start(); //开始接收数据
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SocketConnect.close();
    print("homepage销毁");
  }

  _buildGrid(){
    //deviceList
    Widget widget = Neumorphic(
      margin: const EdgeInsets.only(top: 25, bottom: 25, left: 10, right: 10),
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        // shadowLightColor: const Color.fromRGBO(47, 185, 202, 0.1),
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
        depth: 7,
        lightSource: LightSource.topLeft,
        color: Colors.transparent,
      ),
      child: ChangeNotifierProvider(
        create: (BuildContext context) {  },
        child: Consumer<Led>(
          builder: (contexts, model, child){
            Led led = Provider.of<Led>(context, listen: true);

            return ChangeNotifierProvider(
              create: (BuildContext context) {  },
              child: Consumer<Data>(
                builder: (contexts, model, child){
                  bool connectStatus = Provider.of<Data>(context, listen: true).connectStatus;

                  return GestureDetector(
                    onTap: () {
                      if(connectStatus){
                        // Vibration.vibrate(duration: 110, amplitude: 1),
                        LedCommand.ledPower(contexts, led.value == 0 ? 100 : 0, true);
                      }
                    },
                    onLongPress: (){
                      if(connectStatus){
                        Vibrate.feedback(FeedbackType.heavy);
                        Navigator.push(context, CupertinoPageRoute(builder: (context) {
                          return LedCtrPage();
                        }));
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      color: led.value != 0
                          ? const Color.fromRGBO(255,255,255,1)
                          : const Color.fromRGBO(232,232,232, .4),
                      child: Stack(
                        children: [
                          Positioned(
                              bottom: 20,
                              left: 20,
                              child: Text(
                                "台灯",
                                style: TextStyle(
                                  color: led.value != 0 ? const Color(0xFF303E57) : const Color.fromRGBO(100,100,100,1),
                                  fontSize: 20, //customize size here
                                  // AND others usual text style properties (fontFamily, fontWeight, ...)
                                ),
                              )),
                          Positioned(
                            top: 10,
                            left: 20,
                            child: Icon(
                              Icons.lightbulb,
                              size: 45,
                              color: led.value != 0 ? const Color(0xFFeba811) : const Color.fromRGBO(100,100,100,1),
                            ),
                            // child: Image.asset('assets/images/light.png'),width: 50
                          ),
                          Positioned(
                              top: 15,
                              right: 15,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  boxShadow: led.value != 0
                                      ? [BoxShadow(color: Color.fromRGBO(47, 185, 202, 1), blurRadius: 5)]
                                      : [],
                                  borderRadius: const BorderRadius.all(Radius.circular(45)),
                                  color: led.value != 0 ? const Color.fromRGBO(47, 185, 202, 1) : const Color.fromRGBO(135,135,135, 1),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );


          },
        ),
      ),
    );
    deviceList.add(widget);
  }
}


