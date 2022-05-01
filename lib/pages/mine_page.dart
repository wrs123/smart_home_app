import 'package:esp32_ctr/pages/config_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/tools.dart';
import 'login_page.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: double.infinity,
      child: unLogin(),
    );
  }

  Widget unLogin(){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return LoginPage();
            }));
          },
          child: Container(
              width: Tools.getScreenSize(context).width-150,
              padding: EdgeInsets.only(top: 12, bottom: 12),
              decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(.8),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(.3),		// 阴影的颜色
                  // offset: Offset(1, 2),						// 阴影与容器的距离
                  blurRadius: 1.0,							// 高斯的标准偏差与盒子的形状卷积。
                  ),]
              ),
              child:  Text("点击登录",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                ),
              )
          ),
        ),
        SizedBox(height: 15,),
        Text("登录注册解锁更多操作",
          style: TextStyle(
              color: Colors.black87,
              fontSize: 13
          ),
        )
      ],
    );
  }
}

