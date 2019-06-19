import 'dart:async';

import 'package:subject_system/bean/User.dart';
import 'package:subject_system/configure/ui_configure.dart';
import 'package:subject_system/database/DataBaseUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subject_system/widgets/progress_dialog.dart';

import 'user_page.dart';

class LoginPage extends StatefulWidget {
  bool autoLogin = true;

  LoginPage(this.autoLogin);

  @override
  State<StatefulWidget> createState() => new _LoginState();
}

class _LoginState extends State<LoginPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();

  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  bool _correctPhone = true;
  bool _correctPassword = true;

  bool showProgress = false;

  void _checkInput() {
    if (_phoneController.text.isNotEmpty) {
      _correctPhone = true;
    } else {
      _correctPhone = false;
    }
    if (_passwordController.text.isNotEmpty) {
      _correctPassword = true;
    } else {
      _correctPassword = false;
    }
    setState(() {});
  }

  _handleSubmitted(int flag) async {
    /**
     * flag=0:管理员登录
     * flag=1：用户登录
     */
    _checkInput();
    if (!_correctPassword || !_correctPhone) {
      return;
    }

    setState(() {
      showProgress = true;
    });
    String username = _phoneController.text;
    String password = _passwordController.text;
    if (flag == 0) {
      if (username == 'admin' && password == 'admin') {
        setState(() {
          Navigator.pushAndRemoveUntil(context,
              new MaterialPageRoute(builder: (BuildContext context) {
            return UserPage(
                User(UserType.ADMIN, "admin", "admin", "", 0, "", ""));
          }), (route) => route == null);
        });
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('账号密码错误！'), duration: Duration(milliseconds: 2000)));
      }
    } else if (flag == 1) {
      User user = await DataBaseUtil.logInStudent(username, password);
      if (user != null) {
        Navigator.pushAndRemoveUntil(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return UserPage(user);
        }), (route) => route == null);
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('账号密码错误！'), duration: Duration(milliseconds: 2000)));
      }
    }
    setState(() {
      showProgress = false;
    });
  }

  _buildProgress() {
    return ProgressDialog(
      loading: showProgress,
      msg: '登录中...',
      child: Center(
        child: Text(""),
      ),
    );
  }

  @override
  void initState() {
    DataBaseUtil.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: new Stack(children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage('images/bg.jpeg'),
                    fit: BoxFit.cover)),
          ),
          new GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
          ),
          _buildLogInWidgets(),
          _buildProgress(),
        ]));
  }

  _buildLogInWidgets() {
    Color mainColor = Colors.white;
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, //垂直方向对其方式
      crossAxisAlignment: CrossAxisAlignment.start, //水平方向对其方式

      children: <Widget>[
        Center(
          child: new Container(
            child: Center(
              child: new CircleAvatar(
                  backgroundImage: AssetImage("images/iron_man_icon.png")),
            ),
          ),
        ),
        new Center(
          child: new Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  new Container(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: new TextField(
                      style: TextStyle(color: UiConfigure.black),
                      cursorColor: mainColor,
                      controller: _phoneController,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        hintText: '用户名',
                        hintStyle: TextStyle(color: mainColor),
                        errorText: _correctPhone ? null : '用户名不可为空！',
                        errorStyle: TextStyle(color: Colors.teal),
                        icon: new Icon(Icons.people, color: mainColor),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainColor)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainColor)),
                        errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainColor)),

                      ),
                      onSubmitted: (value) {
                        _checkInput();
                      },
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: new TextField(
                      style: TextStyle(color: UiConfigure.black),
                      cursorColor: mainColor,
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        hintText: '密码',
                        hintStyle: TextStyle(color: mainColor),
                        errorText: _correctPassword ? null : '密码不可为空！',
                        errorStyle: TextStyle(color: Colors.teal),
                        icon: new Icon(Icons.lock_outline, color: mainColor),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainColor)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainColor)),
                        errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainColor)),

                      ),
                      onSubmitted: (value) {
                        _checkInput();
                      },
                    ),
                  )
                ]),
          ),
        ),
        new Center(
            child: new Column(
          children: <Widget>[
            new Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: new Material(
                child: new FlatButton(
                  child: new Container(
                    child: new Center(
                        child: new Text(
                      "管理员登录",
                      textScaleFactor: 1.5,
                      style: new TextStyle(
                          color: Colors.white, fontFamily: "Roboto"),
                    )),
                  ),
                  onPressed: () {
                    _handleSubmitted(0);
                  },
                ),
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10.0),
                elevation: 5.0,
              ),
            ),
            new Container(
              padding: EdgeInsets.only(top: 20.0),
              width: MediaQuery.of(context).size.width * 0.2,
              child: new Material(
                child: new FlatButton(
                  child: new Container(
                    child: new Center(
                        child: new Text(
                      "学生登录",
                      textScaleFactor: 1.5,
                      style: new TextStyle(
                          color: Colors.white, fontFamily: "Roboto"),
                    )),
                  ),
                  onPressed: () {
                    _handleSubmitted(1);
                  },
                ),
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10.0),
                elevation: 5.0,
              ),
            ),
          ],
        )),
      ],
    );
  }
}
