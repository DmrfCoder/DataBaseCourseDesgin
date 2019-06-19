import 'package:subject_system/bean/AttributeBean.dart';
import 'package:subject_system/bean/TableBean.dart';
import 'package:subject_system/bean/User.dart';
import 'package:flutter/material.dart';

abstract class FromSettingDialogController {
  onChangePasswd(String oldPwd,String newPwd);

  onFaild(String describ);
}

enum SettingType { USERINFO, CHANGEPWD }

class FromSettingDialog extends AlertDialog {
  List<TextEditingController> _controllers = [];

  FromSettingDialogController _fromSettingDialogController;

  List<AttributeBean> attributeNames;
  List<String> attributeValues;
  SettingType editType;

  bool enable = true;

  FromSettingDialog(this.attributeNames, this.attributeValues, this.editType,this._fromSettingDialogController) {
    attributeValues.forEach((value) {
      TextEditingController controller = TextEditingController(text: value);
      _controllers.add(controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> attrbutsWidgets = [];
    for (int index = 0; index < attributeNames.length; index++) {
      Widget rightaWidget;

      if (editType == SettingType.CHANGEPWD) {
        rightaWidget = Flexible(
          child: new Container(
              padding: const EdgeInsets.only(top: 20.0),
              width: MediaQuery.of(context).size.height * 0.92,
              child: new TextField(
                enabled: attributeNames[index].enable,
                controller: _controllers[index],
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
              )),
        );
      } else {
        rightaWidget = Flexible(
          child: new Container(
              padding: const EdgeInsets.only(top: 20.0),
              width: MediaQuery.of(context).size.height * 0.92,
              child: new TextField(
                enabled: attributeNames[index].enable,
                controller: _controllers[index],
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
              )),
        );
      }

      attrbutsWidgets.add(new Row(
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.only(top: 20.0),
            width: MediaQuery.of(context).size.height * 0.08,
            child: Text("${attributeNames[index].name}："),
          ),
          rightaWidget
        ],
      ));
    }

    List<Widget> optionWidgets = [];

    if (editType == SettingType.USERINFO) {
      optionWidgets = [
        new FlatButton(
          hoverColor: Colors.white,
          child: new Container(
            child: new Center(
                child: new Text(
              "确 定",
              textScaleFactor: 1.5,
              style: new TextStyle(color: Colors.black, fontFamily: "Roboto"),
            )),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ];
    } else if (editType == SettingType.CHANGEPWD) {
      optionWidgets = [
        new FlatButton(
          hoverColor: Colors.white,
          child: new Container(
            child: new Center(
                child: new Text(
              "取 消",
              textScaleFactor: 1.5,
              style: new TextStyle(color: Colors.black, fontFamily: "Roboto"),
            )),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          hoverColor: Colors.white,
          child: new Container(
            child: new Center(
                child: new Text(
              "确 定",
              textScaleFactor: 1.5,
              style: new TextStyle(color: Colors.black, fontFamily: "Roboto"),
            )),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            _handleChangePwd();

          },
        )
      ];
    }

    return StatefulBuilder(
      builder: (context, StateSetter statesetter) {
        return new Padding(
            padding: const EdgeInsets.only(
                top: 200.0, bottom: 200.0, left: 300.0, right: 300.0),
            child: new Material(
              type: MaterialType.transparency,
              child: new Container(
                  decoration: ShapeDecoration(
                      color: Color(0xFFFFFFFF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ))),
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: const EdgeInsets.all(12.0),
                  child: new Column(children: <Widget>[
                    new Center(
                      child: new Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: attrbutsWidgets,
                          )),
                    ),
                    new Expanded(flex: 1, child: Text("")),
                    new Expanded(
                        flex: 1,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: optionWidgets))
                  ])),
            ));
      },
    );
  }

  void _handleChangePwd() {
    List<String> texts = [];
    for (int index = 0; index < 3; index++) {
      String item = _controllers[index].text;
      if (item == "") {
        _fromSettingDialogController.onFaild("密码修改失败，请输入有效值后重试!");
        return;
      }else{
        texts.add(item);
      }
    }
    if (texts[1] != texts[2]) {
      _fromSettingDialogController.onFaild("密码修改失败，两次输入的密码不一致!");
      return;
    }

    _fromSettingDialogController.onChangePasswd(texts[0],texts[1]);
  }
}
