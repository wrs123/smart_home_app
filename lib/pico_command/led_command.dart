import 'package:esp32_ctr/utils/SocketConnect.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../model/Led.dart';

class LedCommand {

  static Map params = {
    "power": false,
    "light": 100,
  };

  static ledPower(BuildContext context){
    Led led = Provider.of<Led>(context, listen: false);
    led.power;
    params["power"] = !led.power;

    SocketConnect.send(params);
    Provider.of<Led>(context, listen: false).setPower(!led.power);
  }

}