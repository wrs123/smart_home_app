import 'package:esp32_ctr/model/Led.dart';
import 'package:esp32_ctr/pico_command/led_command.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/tools.dart';

class LedCtrPage extends StatefulWidget {
  const LedCtrPage({Key? key}) : super(key: key);

  @override
  _LedCtrPageState createState() => _LedCtrPageState();
}

class _LedCtrPageState extends State<LedCtrPage> {
  static double _lightBarHeight = 400;
  static double _lightPercent = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("台灯",
          style: const TextStyle(
              color: Color(0xFF303E57)
          ),
        ),
        backgroundColor: const Color.fromRGBO(255,255,255,0),
        iconTheme: const IconThemeData(color: const Color(0xFF303E57)),
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
              bottom: 25,
              left: 20,
// width: double.infinity,
              child: Container(
                width: Tools.getScreenSize(context).width-40,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [const BoxShadow(color: Color.fromRGBO(0,0,0, 0.08), blurRadius: 5,)]
                ),
                child: ChangeNotifierProvider(
                  create: (BuildContext context) {  },
                  child: Consumer<Led>(
                    builder: (contexts, model, child){
                      Led led = Provider.of<Led>(context, listen: true);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(led.value != 0
                              ? "已开启"
                              : "未开启",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              LedCommand.ledPower(contexts, led.value == 0 ? 100 : 0, true);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 350),
                              curve: Curves.easeOut,
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(45)),
                                color: led.value != 0 ? const Color.fromRGBO(47, 185, 202, 1) : const Color(0xfff1f1f1),
                              ),
                              child: Center(
                                child: Icon(CupertinoIcons.power,
                                  size: 25,
                                  color: led.value != 0 ? Colors.white : const Color(0xff1b1b1b),),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              )
          ),
          Positioned(
            top: 50,
            left: 0,
            height: _lightBarHeight,
            child: Container(
              width: Tools.getScreenSize(context).width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    width: Tools.getScreenSize(context).width,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(const Radius.circular(30)),
                          child: Container(
                            height: _lightBarHeight,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.6),
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.6))]
                            ),
                            child: ChangeNotifierProvider(
                              create: (BuildContext context) {  },
                              child: Consumer<Led>(
                                builder: (contexts, model, child){
                                  Led led = Provider.of<Led>(context, listen: true);

                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: AnimatedContainer(
                                      decoration: const BoxDecoration(
                                          color: Colors.yellow,
                                          boxShadow: [BoxShadow(color: Colors.yellowAccent)]
                                      ),
                                      height: led.value / 100*_lightBarHeight,
                                      width: 100,
                                      duration: Duration(milliseconds: 150),
                                      curve: Curves.easeOut,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ChangeNotifierProvider(
                    create: (BuildContext context) {  },
                    child: Consumer<Led>(
                      builder: (contexts, model, child){
                        Led led = Provider.of<Led>(context, listen: true);

                        return Positioned(
                          bottom: 0,
                          width: Tools.getScreenSize(context).width,
                          child: Container(
                            child: GestureDetector(
                                onPanUpdate: (DragUpdateDetails details){
                                  var localPosition=details.localPosition.dy;
                                  double percent = 1 - (localPosition/_lightBarHeight);

                                  if((percent *100).truncate() >=19 && (percent *100).truncate() <=100){
                                    setState(() {
                                      _lightPercent = percent;
                                    });
                                    led.setValue((percent *100).truncate());
                                    if((percent *100).truncate()%20 == 0){
                                      LedCommand.ledPower(context, (percent *100).truncate(), false);
                                    }

                                    // print((percent *100).truncate());
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: _lightBarHeight,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0),
                                          borderRadius: const BorderRadius.all(Radius.circular(30))
                                      ),
                                      child: Column(
                                        children: [
                                          Container()
                                        ],
                                      ),
                                    ),

                                  ],
                                )
                            ),
                          ),
                        );
                      },
                    )  ,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}





