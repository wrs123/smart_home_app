import 'package:esp32_ctr/utils/SocketConnect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';

import '../model/Led.dart';

class LedCommand {

  static Map params = {
    "power": false,
    "light": 100,
  };


  static ledPower(BuildContext context){
    bool state = Provider.of<Led>(context, listen: false).commandState;
    if(!state) {
      Vibrate.feedback(FeedbackType.medium);
      Provider.of<Led>(context, listen: false).setCommandState(true);
      int led_value = Provider
          .of<Led>(context, listen: false)
          .value;

      params = {
        "command": 0,
        "value": led_value == 0 ? 100 : 0
      };

      SocketConnect.send(params);
    }
  }

}