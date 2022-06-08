import 'package:esp32_ctr/model/User.dart';
import 'package:esp32_ctr/pages/register_page.dart';
import 'package:esp32_ctr/utils/httpTools.dart';
import 'package:esp32_ctr/utils/tools.dart';
import 'package:esp32_ctr/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../model/Result.dart';
import '../utils/api/api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static String username = "admin";
  static String password = "123";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SizedBox(),
        elevation: 0,
        backgroundColor: Color.fromRGBO(255,255,255,0),
        iconTheme: IconThemeData(color: Color(0xFF303E57),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Text('登录',
              style: TextStyle(
                  color: Color.fromRGBO(102,102,102,1),
                  fontSize: 30
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 40, 25, 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 5.0),
                    blurRadius: 50.0)]
            ),
            child: Column(
              children: <Widget>[
                Container(
                  child: TextField(
                    enabled: true,
                    decoration: InputDecoration(
                        prefixIcon: new Icon(Icons.supervised_user_circle, size: 20.0),
                        labelText: '请输入你的用户名或者邮箱',
                        contentPadding: EdgeInsets.all(12.0),
                        border: InputBorder.none
                    ),
                    onChanged: (change){
                      setState(() {
                        username = change;
                      });
                    },
                  ),
                ),
                Divider(height: 1, thickness: 1, color: Colors.black12),
                TextField(
                  enabled: true,
                  decoration: InputDecoration(
                      labelText: '请输入你的密码',
                      prefixIcon: new Icon(Icons.lock_outline, size: 20.0),
                      contentPadding: EdgeInsets.all(12.0),
                      border: InputBorder.none
                  ),
                  onChanged: (change){
                    setState(() {
                      password = change;
                    });
                  },
                )
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(25, 10, 25,10),
            child: RaisedButton(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              color: Colors.blue,
              onPressed: (){
                _login(context);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(
                  //   width: 17,
                  //   height: 17,
                  //   child: CircularProgressIndicator(
                  //     strokeWidth: 2.5,
                  //     backgroundColor: Colors.blue,
                  //     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  //   ),
                  // ),
                  Text('登录',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){_register(context);},
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text("没有账号？点击注册"),
            ),
          )
        ],
      )
    );
  }

  static _register(BuildContext context) async{
    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
      return RegisterPage();
    }));
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

  _login(BuildContext context) async{
    Result result = await Api().login({"name": username, "password": password});

    if(result.code == LOGIN_SUCCESS_CODE){
      Map userInfo = {
        "name": result.result["user_name"],
        "id": result.result["id"]
      };
      bool saveState = await Tools.savePicoKey(result.result["user_name"]);
      bool saveUserState = await Tools.saveUserInfoFrom(userInfo);
      if(!saveState && !saveUserState){

        return false;
      }
      Provider.of<User>(context, listen: false).setAll(id: userInfo["id"].toString(), name: userInfo["name"], isLogin: true, picoKey: result.result["user_name"]);
      Navigator.of(context).pop();
      return ;
    }
    showToastWidget(toastTemplate(result.message),
        duration: Duration(milliseconds: 800),
        position: ToastPosition(align: Alignment.topCenter, offset: 50)
    );
  }
}
