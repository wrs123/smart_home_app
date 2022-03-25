import 'package:card_swiper/card_swiper.dart';
import 'package:esp32_ctr/model/Led.dart';
import 'package:esp32_ctr/pico_command/led_command.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../model/Data.dart';
import '../utils/SocketConnect.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    SocketConnect.connects(context);

    return Container(
      // padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
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
            height: mediaQuery.size.width-50,
            // constraints: BoxConstraints(maxHeight:mediaQuery.size.width-50,maxWidth: mediaQuery.size.width-50 ),
            // alignment: Alignment.center,
            margin: EdgeInsets.all(15),
            // padding: const EdgeInsets.all(50),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(200)),
                  ),
                  child: Neumorphic(
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              shadowLightColorEmboss: Color.fromRGBO(0,0,0,.2),
                              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(200)),
                              depth: -5,
                              lightSource: LightSource.topLeft,
                              color: Color.fromRGBO(46,183,201,1),
                          ),
                        child: Container(
                          height: mediaQuery.size.width-100,
                          width: mediaQuery.size.width-100,
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
                    shadowLightColorEmboss: Color.fromRGBO(0,0,0,.2),
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
                          height: mediaQuery.size.width-190,
                          width: mediaQuery.size.width-190,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("室内温度",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF303E57)
                                ),
                              ),
                              // Padding(padding: EdgeInsets.only(top: 10)),

                              Text(th.temperature.toStringAsFixed(1)+'℃',
                                  style: TextStyle(
                                      fontSize: 60,
                                      color: Color(0xFF303E57)
                                  )
                              ),
                              Text(th.humidity.toStringAsFixed(1)+'%',
                                  style: TextStyle(
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
                ))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Container(
                //   margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                //   child: Text("全部设备",
                //     style: TextStyle(
                //       fontSize: 16
                //     ),
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: mediaQuery.size.height-mediaQuery.size.width-30-50-117,
                  child: Swiper(
                    curve: Curves.easeOut,
                    itemBuilder: (BuildContext context, int index) {
                      return  Neumorphic(
                        margin: EdgeInsets.only(top: 25, bottom: 25, left: 10, right: 10),
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          shadowLightColor: const Color.fromRGBO(47, 185, 202, 0.3),
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                          depth: 10,
                          lightSource: LightSource.topLeft,
                          color: const Color(0xFFF8F9FC),
                        ),
                        child: ChangeNotifierProvider(
                          create: (BuildContext context) {  },
                          child: Consumer<Led>(
                            builder: (contexts, model, child){
                              Led led = Provider.of<Led>(context, listen: true);

                              return Stack(
                                children: [
                                  Positioned(
                                      bottom: 30,
                                      left: 30,
                                      child: NeumorphicText(
                                        "台灯",
                                        style: const NeumorphicStyle(
                                          depth: 2,  //customize depth here
                                          color: Color(0xFF303E57), //customize color here
                                        ),
                                        textStyle: NeumorphicTextStyle(
                                          fontSize: 25, //customize size here
                                          // AND others usual text style properties (fontFamily, fontWeight, ...)
                                        ),
                                      )),
                                  Positioned(
                                      top: 30,
                                      left: 10,
                                      child: Image.asset('assets/images/light.png'),width: 100
                                  ),
                                  Positioned(
                                      bottom: 30,
                                      right: 30,
                                      child: GestureDetector(
                                        onTap: () =>{
                                          LedCommand.ledPower(contexts)
                                        },
                                        child: Container(
                                          width: 70,
                                          height: 70,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(45)),
                                            color: led.power ? Colors.redAccent : Color.fromRGBO(47, 185, 202, 1),
                                          ),
                                          child: Icon(CupertinoIcons.power,
                                            size: 40,
                                            color: Colors.white,),
                                        ),
                                      ))
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    },
                    itemCount: 3,
                    viewportFraction: 0.75,
                    scale: 0.8,
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
