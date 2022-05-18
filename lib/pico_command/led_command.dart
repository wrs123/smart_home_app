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


  static ledPower(BuildContext context, int value, bool waite){
    bool state = Provider.of<Led>(context, listen: false).commandState;
    if(!state || !waite) {
      Vibrate.feedback(FeedbackType.medium); //震动反馈
      Provider.of<Led>(context, listen: false).setCommandState(true);

      params = {
        "command": 0,
        "value": value
      };

      SocketConnect.send(params);
    }
  }

}