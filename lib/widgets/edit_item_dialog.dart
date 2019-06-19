import 'package:subject_system/bean/AttributeBean.dart';
import 'package:subject_system/bean/TableBean.dart';
import 'package:subject_system/bean/User.dart';
import 'package:flutter/material.dart';

abstract class EditItemDialogController {
  void onAddSuccess(TableBean tableBean);

  void onFailed(String failedDescrib);

  void onUpdateSuccess(TableBean tableBean);

  void onDelete(TableBean tablebean);

  void onSelectCourse(TableBean tableBean);

  void onCancleCourse(TableBean tableBean);

  void onUpdateGrade(TableBean tableBean);
}

enum EditType { ADD, UPDATE }

class EditItemDialog extends AlertDialog {
  List<TextEditingController> _controllers = [];

  EditItemDialogController editItemDialogController;
  List<AttributeBean> attributesBeans;
  EditType editType;
  TableBean tableBean;

  bool enable = true;

  EditItemDialog(this.editType, this.editItemDialogController,
      this.attributesBeans, this.tableBean) {
    if (editType == EditType.ADD) {
      attributesBeans.forEach((AttributeBean att) {
        _controllers.add(new TextEditingController());
      });
    } else if (editType == EditType.UPDATE) {
      for (int index = 0; index < attributesBeans.length; index++) {
        TextEditingController textEditingController = TextEditingController(
            text: tableBean.attributes[index] == "null"
                ? "未知"
                : tableBean.attributes[index]);

        _controllers.add(textEditingController);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> attrbutsWidgets = [];

    for (int index = 0; index < attributesBeans.length; index++) {
      Widget rightaWidget;
      if (attributesBeans[index].dropDownOptions != null) {
        List<DropdownMenuItem> items = new List();
        attributesBeans[index].dropDownOptions.forEach((String str) {
          DropdownMenuItem item1 =
              new DropdownMenuItem(value: str, child: new Text(str));
          items.add(item1);
        });

        if (_controllers[index].text == "") {
          _controllers[index].text = "下拉选择";
        }

        rightaWidget = Flexible(
          child: new Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1), //边框
                  borderRadius: BorderRadius.all(
                    //圆角
                    Radius.circular(10.0),
                  )),
              margin: const EdgeInsets.only(top: 30.0),
              width: MediaQuery.of(context).size.height * 0.92,
              child: Center(
                child: Container(
                  height: 40,
                  child: DropdownButton(
                    items: items,
                    hint: Container(
                      width: 140,
                      child: TextField(
                        controller: _controllers[index],
                        decoration: InputDecoration(border: InputBorder.none),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onChanged: (value) {
                      _controllers[index].text = value;
                    },
                  ),
                ),
              )),
        );
      } else {
        rightaWidget = Flexible(
          child: new Container(
              padding: const EdgeInsets.only(top: 20.0),
              width: MediaQuery.of(context).size.height * 0.92,
              child: new TextField(
                enabled: attributesBeans[index].enable,
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
            child: Text("${attributesBeans[index].name}："),
          ),
          rightaWidget
        ],
      ));
    }

    List<Widget> optionWidgets = [];
    if (editType == EditType.ADD) {
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
            _addItem(context);
          },
        )
      ];
    } else if (editType == EditType.UPDATE) {
      switch (tableBean.beanName) {
        case TableBeanName.STUDENT:
        case TableBeanName.COURSE:
          optionWidgets = [
            new FlatButton(
              hoverColor: Colors.white,
              child: new Container(
                child: new Center(
                    child: new Text(
                  "取 消",
                  textScaleFactor: 1.5,
                  style:
                      new TextStyle(color: Colors.black, fontFamily: "Roboto"),
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
                  "删 除",
                  textScaleFactor: 1.5,
                  style:
                      new TextStyle(color: Colors.black, fontFamily: "Roboto"),
                )),
              ),
              onPressed: () {
                editItemDialogController.onDelete(tableBean);
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              hoverColor: Colors.white,
              child: new Container(
                child: new Center(
                    child: new Text(
                  "保存修改",
                  textScaleFactor: 1.5,
                  style:
                      new TextStyle(color: Colors.black, fontFamily: "Roboto"),
                )),
              ),
              onPressed: () {
                for (int index = 0;
                    index < tableBean.getAttributesCount();
                    index++) {
                  tableBean.attributes[index] = _controllers[index].text;
                }

                editItemDialogController.onUpdateSuccess(tableBean);
                Navigator.of(context).pop();
              },
            )
          ];
          break;
        case TableBeanName.STCOURSE:
          optionWidgets = [
            new FlatButton(
              hoverColor: Colors.white,
              child: new Container(
                child: new Center(
                    child: new Text(
                  "取 消",
                  textScaleFactor: 1.5,
                  style:
                      new TextStyle(color: Colors.black, fontFamily: "Roboto"),
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
                  "选 课",
                  textScaleFactor: 1.5,
                  style:
                      new TextStyle(color: Colors.black, fontFamily: "Roboto"),
                )),
              ),
              onPressed: () {
                editItemDialogController.onSelectCourse(tableBean);
                Navigator.of(context).pop();
              },
            ),
          ];
          break;

        case TableBeanName.ADMINSC:
          optionWidgets = [
            new FlatButton(
              hoverColor: Colors.white,
              child: new Container(
                child: new Center(
                    child: new Text(
                  "取 消",
                  textScaleFactor: 1.5,
                  style:
                      new TextStyle(color: Colors.black, fontFamily: "Roboto"),
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
                  style:
                      new TextStyle(color: Colors.black, fontFamily: "Roboto"),
                )),
              ),
              onPressed: () {
                var maybeGrade = _controllers[6].text;
                if (maybeGrade == "") {
                  editItemDialogController.onFailed("更新成绩失败，成绩不可为空");
                  Navigator.of(context).pop();
                  return;
                }
                tableBean.attributes[6] = maybeGrade;
                editItemDialogController.onUpdateGrade(tableBean);
                Navigator.of(context).pop();
              },
            ),
          ];
          break;

        case TableBeanName.MYCOURSES:
          if (tableBean.attributes[4] != "null"&&tableBean.attributes[4] !="") {
            optionWidgets = [
              new FlatButton(
                hoverColor: Colors.white,
                child: new Container(
                  child: new Center(
                      child: new Text(
                    "确 定",
                    textScaleFactor: 1.5,
                    style: new TextStyle(
                        color: Colors.black, fontFamily: "Roboto"),
                  )),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ];
          } else {
            optionWidgets = [
              new FlatButton(
                hoverColor: Colors.white,
                child: new Container(
                  child: new Center(
                      child: new Text(
                    "取 消",
                    textScaleFactor: 1.5,
                    style: new TextStyle(
                        color: Colors.black, fontFamily: "Roboto"),
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
                    "退 选",
                    textScaleFactor: 1.5,
                    style: new TextStyle(
                        color: Colors.black, fontFamily: "Roboto"),
                  )),
                ),
                onPressed: () {
                  editItemDialogController.onCancleCourse(tableBean);
                  Navigator.of(context).pop();
                },
              ),
            ];
          }

          break;
      }
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
                        flex: 2,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: optionWidgets))
                  ])),
            ));
      },
    );
  }

  void _addItem(BuildContext context) {
    List<String> attributeValues = [];
    for (int index = 0; index < _controllers.length; index++) {
      String curValue = _controllers[index].text;
      if (curValue == "" || curValue == "下拉选择") {
        editItemDialogController.onFailed("添加失败，属性值不可为空！");
        return;
      } else {
        attributeValues.add(curValue);
      }
    }
    tableBean.attributes = attributeValues;

    editItemDialogController.onAddSuccess(tableBean);
  }
}
