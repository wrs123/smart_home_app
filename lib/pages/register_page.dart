import 'package:esp32_ctr/model/Result.dart';
import 'package:esp32_ctr/utils/api/api.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:esp32_ctr/values.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static String username = "";
  static String password = "";
  static String rePassword = "";

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
              child: Text('注册',
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
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.black12),
                  TextField(
                    enabled: true,
                    decoration: InputDecoration(
                        labelText: '请再次输入你的密码',
                        prefixIcon: new Icon(Icons.lock_outline, size: 20.0),
                        contentPadding: EdgeInsets.all(12.0),
                        border: InputBorder.none
                    ),
                    onChanged: (change){
                      setState(() {
                        rePassword = change;
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
                  _register(context);
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
                    Text('注册',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
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
  _register(BuildContext context) async{
    if(password == rePassword){
      Result result = await Api().register({"name": username, "password": password});

      showToastWidget(toastTemplate(result.message),
          duration: Duration(milliseconds: 800),
          position: ToastPosition(align: Alignment.topCenter, offset: 50)
      );
      if(result.code == LOGIN_SUCCESS_CODE){
        Future.delayed(Duration(milliseconds: 800), () {
          Navigator.of(context).pop();
        });
        return ;
      }

      return ;
    }
    showToastWidget(toastTemplate("密码不一致"),
        duration: Duration(milliseconds: 800),
        position: ToastPosition(align: Alignment.topCenter, offset: 50)
    );
  }
}
