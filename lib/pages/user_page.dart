import 'package:subject_system/bean/AttributeBean.dart';
import 'package:subject_system/bean/User.dart';
import 'package:subject_system/bean/TableBean.dart';
import 'package:subject_system/configure/ui_configure.dart';
import 'package:subject_system/database/DataBaseUtil.dart';
import 'package:subject_system/widgets/edit_item_dialog.dart';
import 'package:subject_system/widgets/from_setting_dialog.dart';
import 'package:subject_system/widgets/progress_dialog.dart';
import 'package:subject_system/widgets/table_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class UserPage extends StatefulWidget {
  User user;

  UserPage(this.user);

  @override
  State<StatefulWidget> createState() {
    return _AdminState();
  }
}

class _AdminState extends State<UserPage>
    with SingleTickerProviderStateMixin
    implements
        ListViewCallBack,
        EditItemDialogController,
        FromSettingDialogController {
  List<Tab> myTabs;

  String describ = "新增课程";

  int curTab = 0;
  UserType userType;

  TabController _tabController;

  List<TableBean> courses = [];
  List<TableBean> students = [];
  List<TableBean> adminScs = [];

  List<TableBean> stCourses = [];
  List<TableBean> myCourses = [];

  List<SortType> courseSort = [
    SortType.UP,
    SortType.DEFAULT,
    SortType.DEFAULT,
    SortType.DEFAULT
  ];

  List<SortType> studentSort = [
    SortType.UP,
    SortType.DEFAULT,
    SortType.DEFAULT,
    SortType.DEFAULT,
    SortType.DEFAULT,
    SortType.NONE
  ];

  List<SortType> adminScSort = [
    SortType.UP,
    SortType.DEFAULT,
    SortType.DEFAULT,
    SortType.DEFAULT,
    SortType.DEFAULT,
    SortType.DEFAULT,
    SortType.DEFAULT,
  ];

  List<SortType> stCourseSort = [
    SortType.UP,
    SortType.DEFAULT,
    SortType.DEFAULT,
    SortType.DEFAULT,
  ];

  List<SortType> myCourseSort = [
    SortType.UP,
    SortType.DEFAULT,
    SortType.DEFAULT,
    SortType.DEFAULT,
    SortType.DEFAULT
  ];

  bool showProgress = false;
  String progressText = "";

  _initCourse({String key = "Cno", String order = "asc", String text}) async {
    if (text != null && text != "") {
      List result = await DataBaseUtil.courseLikeSearch(text, key, order);
      if (result[0].length == 0) {
        setState(() {
          showProgress = false;
        });
        return [result[1], "没有查询到相关内容！"];
      } else {
        setState(() {
          showProgress = false;
          courses = result[0];
        });
        return [result[1], "查询到${courses.length}条数据！"];
      }
    }
    List tempcourses = await DataBaseUtil.initCourse(key, order);
    setState(() {
      courses = tempcourses[0];
      showProgress = false;
    });
    return [tempcourses[1], "执行成功!"];
  }

  _initStudent({String key = "Sno", String order = "asc", String text}) async {
    if (text != null && text != "") {
      List result = await DataBaseUtil.studentLikeSearch(text, key, order);
      if (result[0].length == 0) {
        setState(() {
          showProgress = false;
        });
        return [result[1], "没有查询到相关内容！"];
      } else {
        setState(() {
          showProgress = false;
          students = result[0];
        });
        return [result[1], "查询到${students.length}条数据！"];
      }
    }
    List mystudent = await DataBaseUtil.initStudent(key, order);
    setState(() {
      students = mystudent[0];
      showProgress = false;
    });
    return [mystudent[1], "执行成功!"];
  }

  _initAdminSc({String key = "Sno", String order = "asc", String text}) async {
    if (text != null && text != "") {
      List result = await DataBaseUtil.adminScLikeSearch(text, key, order);
      if (result[0].length == 0) {
        setState(() {
          showProgress = false;
        });
        return [result[1], "没有查询到相关内容！"];
      } else {
        setState(() {
          showProgress = false;
          adminScs = result[0];
        });
        return [result[1], "查询到${adminScs.length}条数据！"];
      }
    }
    List adminSc = await DataBaseUtil.initAdminSc(key, order);
    setState(() {
      adminScs = adminSc[0];
      showProgress = false;
    });
    return [adminSc[1], "执行成功!"];
  }

  _initStCourse({String key = "Cno", String order = "asc", String text}) async {
    if (text != null && text != "") {
      List result = await DataBaseUtil.stCourseLikeSearch(
          widget.user.userNo, text, key, order);
      if (result[0].length == 0) {
        setState(() {
          showProgress = false;
        });
        return [result[1], "没有查询到相关内容！"];
      } else {
        setState(() {
          showProgress = false;
          stCourses = result[0];
        });
        return [result[1], "查询到${stCourses.length}条数据！"];
      }
    }
    List tempcourses =
        await DataBaseUtil.initStCourse(widget.user.userNo, key, order);
    setState(() {
      stCourses = tempcourses[0];
      showProgress = false;
    });
    return [tempcourses[1], "执行成功!"];
  }

  _initMyCourse({String key = "Cno", String order = "asc", String text}) async {
    if (text != null && text != "") {
      List result = await DataBaseUtil.myCourseLikeSearch(
          widget.user.userNo, text, key, order);
      if (result[0].length == 0) {
        setState(() {
          showProgress = false;
        });
        return [result[1], "没有查询到相关内容！"];
      } else {
        setState(() {
          showProgress = false;
          myCourses = result[0];
        });
        return [result[1], "查询到${myCourses.length}条数据！"];
      }
    }
    List tempMycourses =
        await DataBaseUtil.initMyCourses(widget.user.userNo, key, order);

    setState(() {
      myCourses = tempMycourses[0];
      showProgress = false;
    });
    return [tempMycourses[1], "执行成功!"];
  }

  Future initDatabase() async {
    await DataBaseUtil.init();

    if (userType == UserType.ADMIN) {
      _initCourse();

      _initStudent();

      _initAdminSc();
    } else {
      _initStCourse();
      _initMyCourse();
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      progressText = "初始化数据...";
      showProgress = true;
    });
    userType = widget.user.userType;

    myTabs = userType == UserType.ADMIN
        ? <Tab>[
            new Tab(text: '课程管理'),
            new Tab(text: '学生管理'),
            new Tab(text: '选课管理'),
          ]
        : <Tab>[
            new Tab(text: '可选课程'),
            new Tab(text: '已选课程'),
          ];

    initDatabase();

    if (userType == UserType.STUDENT) {
      showAddButton = false;
    }

    _tabController = TabController(length: myTabs.length, vsync: this);
    _tabController.addListener(() {
      curTab = _tabController.index;
      _searchController.text = searchText[curTab];
      if (userType == UserType.ADMIN) {
        if (curTab == 2) {
          setState(() {
            showAddButton = false;
          });
        } else {
          setState(() {
            showAddButton = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // DataBaseUtil.dispose();
  }

  BuildContext myContext;

  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

  bool showAddButton = true;

  @override
  Widget build(BuildContext context) {
    myContext = context;
    return new DefaultTabController(
      length: myTabs.length,
      child: new Scaffold(
          drawer: _buildAdminDrawer(),
          body: Stack(
            children: <Widget>[
              new TabBarView(
                controller: _tabController,
                children: myTabs.map((Tab tab) {
                  return new Center(child: _buildTabBody(tab));
                }).toList(),
              ),
              _buildProgress(),
            ],
          ),
          floatingActionButton: Offstage(
            offstage: !showAddButton,
            child: FloatingActionButton(
              onPressed: _addItem,
              tooltip: describ,
              child: Icon(Icons.add),
            ),
          ),
          appBar: _buildAppBar()),
    );
  }

  _showDescrib(String msg) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                title: new Text(msg),
                onTap: () async {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  _buildProgress() {
    return ProgressDialog(
      loading: showProgress,
      msg: progressText,
      child: Center(
        child: Text(""),
      ),
    );
  }

  TextEditingController _searchController = TextEditingController();

  _buildAppBar() {
    return PreferredSize(
        child: Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(color: Colors.blue),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Expanded(
                    child: Builder(
                      builder: (context) => new IconButton(
                        icon: new Container(
                          child: new CircleAvatar(
                              backgroundImage:
                                  AssetImage("images/iron_man_icon.png")),
                          alignment: const Alignment(-0.9, 0),
                        ),
                        padding: EdgeInsets.all(0.0),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    flex: 1,
                  ),
                  new Expanded(
                    child: new Center(
                      child: new TabBar(
                        controller: _tabController,
                        tabs: myTabs,
                        isScrollable: true,
                        indicatorColor: UiConfigure.black,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: UiConfigure.black,
                        labelStyle: new TextStyle(fontSize: 16.0),
                        unselectedLabelColor: Colors.white,
                        unselectedLabelStyle: new TextStyle(fontSize: 12.0),
                      ),
                    ),
                    flex: 4,
                  ),
                  new Expanded(
                    child: Center(
                        child: new Container(
                      padding: EdgeInsets.only(right: 10),
                      child: new TextField(
                        controller: _searchController,
                        style: TextStyle(color: UiConfigure.black),
                        decoration: InputDecoration(
                          hintText: "输入关键字查询",
                          hintStyle: TextStyle(color: UiConfigure.black),
                          contentPadding: EdgeInsets.all(10.0),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: UiConfigure.black)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: UiConfigure.black)),
                        ),
                        cursorColor: UiConfigure.black,
                        onEditingComplete: () {
                          _handleSearch(_searchController.text);
                        },
                      ),
                    )),
                    flex: 1,
                  )
                ],
              ),
            ),
          ],
        ),
        preferredSize: Size.fromHeight(60.0));
  }

  _buildTabBody(tab) {
    if (userType == UserType.ADMIN) {
      switch (myTabs.indexOf(tab)) {
        case 0:
          return _buildCourse();
          break;
        case 1:
          return _buildStudent();
          break;
        case 2:
          return _buildSc();
      }
    } else {
      switch (myTabs.indexOf(tab)) {
        case 0:
          return _buildStCourse();
          break;
        case 1:
          return _buildMyCourse();
          break;
      }
    }
  }

  _buildAdminDrawer() {
    List<Widget> options = [];
    if (userType == UserType.STUDENT) {
      options = [
        new GestureDetector(
          child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10, left: 10),
                  height: 23.0,
                  width: 23.0,
                  child: Image.asset('images/self_info_icon.png'),
                ),
                new Text(
                  "个人信息",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ],
            ),
          ),
          onTap: () => _onSelfInfo(),
        ),
        new GestureDetector(
          child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10, left: 10),
                  height: 23.0,
                  width: 23.0,
                  child: Image.asset('images/change_pwd_icon.png'),
                ),
                new Text(
                  "修改密码",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ],
            ),
          ),
          onTap: () => _onChangePassword(),
        ),
      ];
    }
    options.insert(
        0,
        Center(
          child: new UserAccountsDrawerHeader(
            currentAccountPicture: new CircleAvatar(
                //圆形图标控件
                backgroundImage: new AssetImage("images/iron_man_icon.png")),
            accountName: new Text(userType == UserType.ADMIN
                ? "管理员ID：${widget.user.userName}"
                : "学生姓名: ${widget.user.userName}"),
            accountEmail: new Text(
                userType == UserType.ADMIN ? "" : "学号学号：${widget.user.userNo}"),
          ),
        ));
    options.add(new GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10, left: 13),
              height: 20.0,
              width: 20.0,
              child: Image.asset('images/logout_icon.png'),
            ),
            new Text(
              "退出登陆",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ],
        ),
      ),
      onTap: () => _onlogout(),
    ));

    return new Drawer(
      child: new Stack(
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: options,
          ),
        ],
      ),
    );
  }

  List<String> courseHeads = ["课程号", "课程名", "课程类型", "学分"];
  List<String> studentHeads = ["学号", "姓名", "性别", "年龄", "系别", "密码"];
  List<String> adminScHeads = ["学号", "姓名", "课程号", "课程名", "课程类型", "学分", "成绩"];
  List<String> myCourseHeads = ["课程号", "课程名", "课程类型", "学分", "成绩"];
  List<String> stCourseHeads = ["课程号", "课程名", "课程类型", "学分"];

  _buildCourse() {
    return TableListView(courses, this, courseHeads, courseSort);
  }

  _buildStudent() {
    return TableListView(students, this, studentHeads, studentSort);
  }

  _buildSc() {
    return TableListView(adminScs, this, adminScHeads, adminScSort);
  }

  _buildStCourse() {
    return TableListView(stCourses, this, stCourseHeads, stCourseSort);
  }

  _buildMyCourse() {
    return TableListView(myCourses, this, myCourseHeads, myCourseSort);
  }

  void _addItem() {
    if (userType == UserType.ADMIN) {
      if (curTab == 0) {
        List<AttributeBean> attributeBeans = [];
        courseHeads.forEach((name) {
          attributeBeans.add(AttributeBean(name, true));
        });
        attributeBeans[2].dropDownOptions = [
          "必修课",
          "选修课",
          "专业选修课",
          "文化素质课",
          "公共选修课",
          "外语课",
          "国防军事课",
          "新生研讨课",
          "学科拓展课",
          "cet"
        ];

        showCupertinoDialog(
            context: myContext,
            builder: (context) {
              return new EditItemDialog(EditType.ADD, this, attributeBeans,
                  TableBean.buildHolder(TableBeanName.COURSE));
            });
      } else if (curTab == 1) {
        List<AttributeBean> attributeBeans = [];
        studentHeads.forEach((name) {
          attributeBeans.add(AttributeBean(name, true));
        });
        attributeBeans[2].dropDownOptions = ["男", "女"];
        attributeBeans[4].dropDownOptions = [
          "计算机科学与技术",
          "信息安全",
          "软件工程",
          "物联网工程"
        ];

        showCupertinoDialog(
            context: myContext,
            builder: (context) {
              return new EditItemDialog(EditType.ADD, this, attributeBeans,
                  TableBean.buildHolder(TableBeanName.STUDENT));
            });
      }
    } else {}
  }

  _onlogout() {
    Navigator.pushAndRemoveUntil(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new LoginPage(
        false,
      );
    }), (route) => route == null);
  }

  @override
  onItemClick(TableBean item) {
    List<AttributeBean> attributeBeans = [];

    switch (item.beanName) {
      case TableBeanName.STCOURSE:
        courseHeads.forEach((name) {
          attributeBeans.add(AttributeBean(name, false));
        });

        break;

      case TableBeanName.COURSE:
        courseHeads.forEach((name) {
          attributeBeans.add(AttributeBean(name, true));
        });

        attributeBeans[2].dropDownOptions = [
          "必修课",
          "选修课",
          "专业选修课",
          "文化素质课",
          "公共选修课",
          "外语课",
          "国防军事课",
          "新生研讨课",
          "学科拓展课",
          "cet"
        ];
        break;
      case TableBeanName.STUDENT:
        studentHeads.forEach((name) {
          attributeBeans.add(AttributeBean(name, true));
        });
        attributeBeans[2].dropDownOptions = ["男", "女"];
        attributeBeans[4].dropDownOptions = [
          "计算机科学与技术",
          "信息安全",
          "软件工程",
          "物联网工程"
        ];

        break;
      case TableBeanName.ADMINSC:
        adminScHeads.forEach((name) {
          attributeBeans.add(AttributeBean(name, false));
        });
        attributeBeans[6].enable = true;

        break;
      case TableBeanName.MYCOURSES:
        myCourseHeads.forEach((name) {
          attributeBeans.add(AttributeBean(name, false));
        });
        break;
    }

    showCupertinoDialog(
        context: myContext,
        builder: (context) {
          return new EditItemDialog(
              EditType.UPDATE, this, attributeBeans, item);
        });
  }

  @override
  Future onUpdateSuccess(TableBean tableBean) async {
    List result = await DataBaseUtil.update(tableBean);
    _showDescrib("执行sql语句：${result[0]}\n执行结果：${result[1]}");
    if (result[1] != "成功") {
      return;
    }

    switch (tableBean.beanName) {
      case TableBeanName.COURSE:
        int index = 0;
        for (index = 0; index < courses.length; index++) {
          if (courses[index].getWithIndex(0) == tableBean.getWithIndex(0)) {
            setState(() {
              courses[index].updateAttributes(tableBean);
            });
            break;
          }
        }
        break;
      case TableBeanName.STUDENT:
        int index = 0;
        for (index = 0; index < students.length; index++) {
          if (students[index].getWithIndex(0) == tableBean.getWithIndex(0)) {
            setState(() {
              students[index].updateAttributes(tableBean);
            });
            break;
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  void onFailed(String failedDescrib) {
    _showDescrib(failedDescrib);
  }

  @override
  Future onAddSuccess(TableBean tableBean) async {
    List result = await DataBaseUtil.insert(tableBean);
    _showDescrib("执行sql语句：${result[0]}\n执行结果：${result[1]}");
    if (result[1] != "成功") {
      return;
    }

    switch (tableBean.beanName) {
      case TableBeanName.COURSE:
        setState(() {
          courses.add(tableBean);
        });
        break;
      case TableBeanName.STUDENT:
        setState(() {
          students.add(tableBean);
        });
        break;
      default:
        break;
    }
  }

  @override
  Future onDelete(TableBean tablebean) async {
    List result = await DataBaseUtil.delete(tablebean);
    _showDescrib("执行sql语句：${result[0]}\n执行结果：${result[1]}");
    if (result[1] != "成功") {
      return;
    }

    switch (tablebean.beanName) {
      case TableBeanName.STUDENT:
        setState(() {
          students.remove(tablebean);
        });
        break;

      case TableBeanName.COURSE:
        setState(() {
          courses.remove(tablebean);
        });
        break;
      default:
        break;
    }
  }

  @override
  Future onSelectCourse(TableBean course) async {
    progressText = "选课中..";
    setState(() {
      showProgress = true;
    });
    List result = await DataBaseUtil.selectCourse(
        widget.user.userNo, course.attributes[0]);

    TableBean c;
    int position = 0;
    for (int index = 0; index < stCourses.length; index++) {
      if (stCourses[index].attributes[0] == course.attributes[0]) {
        c = stCourses[index];
        position = index;
        break;
      }
    }

    setState(() {
      stCourses.removeAt(position);
      myCourses.add(TableBean(TableBeanName.MYCOURSES, [
        c.attributes[0],
        c.attributes[1],
        c.attributes[2],
        c.attributes[3],
        null
      ]));

      showProgress = false;
    });
    _showDescrib("执行sql语句：${result[0]}\n执行结果：${result[1]}");
  }

  @override
  Future onCancleCourse(TableBean tableBean) async {
    progressText = "退选中..";
    setState(() {
      showProgress = true;
    });

    List result = await DataBaseUtil.cancelCourse(
        widget.user.userNo, tableBean.attributes[0]);

    TableBean c;
    int position = 0;
    for (int index = 0; index < myCourses.length; index++) {
      if (myCourses[index].attributes[0] == tableBean.attributes[0]) {
        position = index;
        c = myCourses[index];
      }
    }

    setState(() {
      myCourses.removeAt(position);
      stCourses.add(TableBean(TableBeanName.STCOURSE, [
        c.attributes[0],
        c.attributes[1],
        c.attributes[2],
        c.attributes[3]
      ]));
      showProgress = false;
    });
    _showDescrib("执行sql语句：${result[0]}\n执行结果：${result[1]}");
  }

  var chinaToEnglishMap = <String, String>{
    '课程号': 'Cno',
    '课程名': 'Cname',
    '课程类型': 'Ctype',
    '学分': 'Ccredit',
    '学号': 'Sno',
    '姓名': 'Sname',
    '性别': 'Ssex',
    '年龄': 'Sage',
    '系别': 'Sdept',
    '成绩': 'Grade',
  };
  var orderMap = <SortType, String>{SortType.UP: 'asc', SortType.DOWN: 'desc'};

  @override
  onSortClick(int index) {
    setState(() {
      progressText = "排序中...";
      showProgress = true;
    });

    if (userType == UserType.ADMIN) {
      if (curTab == 0) {
        _handleSort(index, courseSort, courseHeads, _initCourse);
      } else if (curTab == 1) {
        _handleSort(index, studentSort, studentHeads, _initStudent);
      } else if (curTab == 2) {
        _handleSort(index, adminScSort, adminScHeads, _initAdminSc);
      }
    } else {
      if (curTab == 0) {
        _handleSort(index, stCourseSort, stCourseHeads, _initStCourse);
      } else if (curTab == 1) {
        _handleSort(index, myCourseSort, myCourseHeads, _initMyCourse);
      } else if (curTab == 2) {}
    }

    return null;
  }

  Future _handleSort(int index, List<SortType> sorts, List<String> heads,
      Function function) async {
    for (int i = 0; i < sorts.length; i++) {
      if (i != index && sorts[i] != SortType.NONE) {
        sorts[i] = SortType.DEFAULT;
      }
    }

    List result;

    switch (sorts[index]) {
      case SortType.UP:
        sorts[index] = SortType.DOWN;
        result = await function(
            key: chinaToEnglishMap[heads[index]],
            order: orderMap[SortType.DOWN],
            text: searchText[curTab]);
        break;
      case SortType.DOWN:
        sorts[index] = SortType.UP;
        result = await function(
            key: chinaToEnglishMap[heads[index]],
            order: orderMap[SortType.UP],
            text: searchText[curTab]);
        break;
      case SortType.DEFAULT:
        sorts[index] = SortType.UP;
        result = await function(
            key: chinaToEnglishMap[heads[index]],
            order: orderMap[SortType.UP],
            text: searchText[curTab]);
        break;
      case SortType.NONE:
        break;
    }
    _showDescrib("执行sql语句：${result[0]}\n执行结果：${result[1]}");
  }

  var searchText = ["", "", "", "", ""];

  Future _handleSearch(String text) async {
    setState(() {
      progressText = "查询中";
      showProgress = true;
    });

    searchText[curTab] = text;

    List result;

    switch (widget.user.userType) {
      case UserType.ADMIN:
        switch (curTab) {
          case 0:
            result = await _initCourse(text: text);
            break;
          case 1:
            result = await _initStudent(text: text);
            break;
          case 2:
            result = await _initAdminSc(text: text);
            break;
        }

        break;
      case UserType.STUDENT:
        switch (curTab) {
          case 0:
            result = await _initStCourse(text: text);
            break;
          case 1:
            result = await _initMyCourse(text: text);
            break;
        }
        break;
    }
    _showDescrib("执行sql语句：${result[0]}\n执行结果：${result[1]}");
  }

  _onChangePassword() {
    Navigator.pop(context);
    showCupertinoDialog(
        context: myContext,
        builder: (context) {
          return new FromSettingDialog([
            AttributeBean("原密码", true),
            AttributeBean("新密码", true),
            AttributeBean("再次输入新密码", true)
          ], [
            "",
            "",
            ""
          ], SettingType.CHANGEPWD, this);
        });
  }

  _onSelfInfo() {
    Navigator.pop(context);
    showCupertinoDialog(
        context: myContext,
        builder: (context) {
          return new FromSettingDialog([
            AttributeBean("学号", false),
            AttributeBean("姓名", false),
            AttributeBean("性别", false),
            AttributeBean("年龄", false),
            AttributeBean("系别", false),
          ], [
            widget.user.userNo,
            widget.user.userName,
            widget.user.sex,
            widget.user.age.toString(),
            widget.user.dept,
          ], SettingType.USERINFO, this);
        });
  }

  @override
  onChangePasswd(String oldPwd, String newPwd) async {
    if (oldPwd != widget.user.password) {
      _showDescrib("密码修改失败！\n失败原因：原密码不正确!");
      return;
    }
    if (oldPwd == newPwd) {
      _showDescrib("密码修改失败！\n失败原因：新密码不可与原密码一样!");
      return;
    }
    progressText = "修改密码中...";
    setState(() {
      showProgress = true;
    });
    List result = await DataBaseUtil.updatePwd(widget.user.userNo, newPwd);

    _showDescrib("执行sql语句：${result[0]}\n执行结果：${result[1]}");
    setState(() {
      showProgress = false;
    });
    return;
  }

  @override
  onFaild(String describ) {
    return null;
  }

  @override
  Future onUpdateGrade(TableBean tableBean) async {
    progressText = "更新成绩..";
    setState(() {
      showProgress = true;
    });

    List result = await DataBaseUtil.updateGrade(tableBean.attributes[0],
        tableBean.attributes[2], tableBean.attributes[6]);

    TableBean c;
    int position = 0;
    for (int index = 0; index < adminScs.length; index++) {
      if (adminScs[index].attributes[0] == tableBean.attributes[0] &&
          adminScs[index].attributes[2] == tableBean.attributes[2]) {
        position = index;
        c = adminScs[index];
      }
    }

    setState(() {
      adminScs[position].attributes[6] = tableBean.attributes[6];

      showProgress = false;
    });
    _showDescrib("执行sql语句：${result[0]}\n执行结果：${result[1]}");
  }
}
