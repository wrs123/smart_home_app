import 'package:esp32_ctr/model/Result.dart';
import 'package:esp32_ctr/model/User.dart';
import 'package:esp32_ctr/pages/config_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../utils/api/api.dart';
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
      child: ChangeNotifierProvider(
          create: (BuildContext context) {  },
          child: Consumer<User>(
              builder: (context, model, child){
                User userInfo = Provider.of<User>(context, listen: true);
                if(userInfo.isLogin){
                  return LoggedinWidget(userInfo);
                }
                return unLoginWidget();
              }
          )
      ),
    );
  }

  /**
   * 已登录组件
   */
  Widget LoggedinWidget(User user){
    return Container(
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  child: Text("欢迎回来，"+user.name,
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),

                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {_logout();},
            child: Container(
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.7), blurRadius: 5)]
              ),
              child: Center(
                child: Text("退出登录",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget toastTemplate(String text){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.black87,
      ),
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      child: Text(text,
        style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w400
        ),
      ),
    );
  }

  _logout() async{
    Result rep = await Api().logout();
    bool saveState = await Tools.removePicoKey();
    if(rep.code == 200){
      showToastWidget(toastTemplate(rep.message),
          duration: Duration(milliseconds: 700),
          position: ToastPosition(align: Alignment.topCenter, offset: 50)
      );
      Future.delayed(Duration(milliseconds: 700), () {
        Provider.of<User>(context, listen: false).setIsLogin(false);
      });
    }
  }

  Widget unLoginWidget(){
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
                  color: Colors.black.withOpacity(.3),
                  // offset: Offset(1, 2),
                  blurRadius: 1.0,
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

