import 'package:subject_system/bean/TableBean.dart';
import 'package:subject_system/bean/User.dart';
import 'package:subject_system/configure/db_configure.dart';
import 'package:sqljocky5/sqljocky.dart';

class DataBaseUtil {
  static MySqlConnection conn;

  static Future init() async {
    if (conn == null) {
      var s = ConnectionSettings(
        user: "root",
        password: "xie.159753.",
        host: "localhost",
        port: 3306,
        db: DataBaseConfigure.DatabaseName,
      );
      conn = await MySqlConnection.connect(s);
    }
    if (conn != null) {
      print('数据库连接成功');
      return true;
    } else {
      return false;
    }
  }

  static logInStudent(String username, String passwd) async {
    String sql =
        "select * from student where Sname='$username' and Spwd='$passwd';";
    StreamedResults results = await conn.execute(sql);
    print(sql);
    try {
      var student = await results.elementAt(0);
      User user = User(UserType.STUDENT, student[0], student[1], student[2],
          student[3], student[4], student[5]);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static initCourse(String sortKey, String order) async {
    String sql = "select * from course order by $sortKey $order;";
    StreamedResults results = await conn.execute(sql);
    List<TableBean> courses = [];

    results.forEach((Row row) {
      TableBean course = TableBean(
          TableBeanName.COURSE, [row[0], row[1], row[3], row[2].toString()]);
      courses.add(course);
    });
    return [courses, sql];
  }

  static initStCourse(String sno, String key, String order) async {
    String sql =
        "select * from course where Cno not in (select course.Cno from course,sc where sc.Cno=course.Cno and sc.Sno='$sno') order by $key $order;";
    List<TableBean> courses = [];
    StreamedResults results = await conn.execute(sql);

    await results.forEach((Row row) {
      TableBean course = TableBean(
          TableBeanName.STCOURSE, [row[0], row[1], row[3], row[2].toString()]);
      courses.add(course);
    });

    return [courses, sql];
  }

  static initStudent(String key, String order) async {
    String sql = "select * from Student order by $key $order;";
    StreamedResults results = await conn.execute(sql);
    List<TableBean> students = [];

    results.forEach((Row row) {
      TableBean student = TableBean(TableBeanName.STUDENT,
          [row[0], row[1], row[2], row[3].toString(), row[4], row[5]]);
      students.add(student);
    });
    return [students, sql];
  }

  static initAdminSc(String key, String order) async {
    String sql =
        "select * from ${DataBaseConfigure.stAndScView} order by $key $order;";

    StreamedResults results = await conn.execute(sql);
    List<TableBean> scViews = [];

    results.forEach((Row row) {
      TableBean scView = TableBean(TableBeanName.ADMINSC, [
        row[0],
        row[1],
        row[2],
        row[3],
        row[4],
        row[5].toString(),
        row[6].toString()
      ]);
      scViews.add(scView);
    });
    return [scViews, sql];
  }

  static initMyCourses(String sno, String key, String order) async {
    String sql =
        "select Cno,Cname,Ctype,Ccredit,Grade from ${DataBaseConfigure.stAndScView} where Sno='$sno' order by $key $order;";
    StreamedResults results = await conn.execute(sql);

    List<TableBean> myCourses = [];

    results.forEach((Row row) {
      TableBean scView = TableBean(TableBeanName.MYCOURSES,
          [row[0], row[1], row[2], row[3].toString(), row[4].toString()]);
      myCourses.add(scView);
    });
    return [myCourses, sql];
  }

  static insert(TableBean tableBean) {
    switch (tableBean.beanName) {
      case TableBeanName.COURSE:
        return _insertCourse(tableBean);
        break;
      case TableBeanName.STUDENT:
        return _insertStudent(tableBean);
        break;
      case TableBeanName.ADMINSC:
        break;
      case TableBeanName.MYCOURSES:
        // TODO: Handle this case.
        break;
      case TableBeanName.STCOURSE:
        // TODO: Handle this case.
        break;
    }
  }

  static _insertCourse(TableBean course) async {
    /**
     * 查询的流程是：
     * 1. 查询表中是否已存在该课程，若已存在，抛出异常
     * 2. 查询课程数量，设置当前课程id，插入课程
     * 3. 返回当前course对象
     */

    String sql =
        "insert into course values('${course[0]}','${course[1]}',${course[3]},'${course[2]}');";

    StreamedResults results;
    try {
      results = await conn.execute(sql);
    } catch (e) {
      return [sql, e.toString()];
    }

    if (results != null) {
      return [sql, "成功"];
    } else {
      return "error";
    }
  }

  static _insertStudent(TableBean student) async {
    /**
     * 查询的流程是：
     * 1. 查询表中是否已存在该课程，若已存在，抛出异常
     * 2. 查询课程数量，设置当前课程id，插入课程
     * 3. 返回当前course对象
     */

    String sql =
        "insert into student values('${student[0]}','${student[1]}','${student[2]}',${student[3]},'${student[4]}','${student[5]}');";

    StreamedResults results;
    try {
      results = await conn.execute(sql);
    } catch (e) {
      return [sql, e.toString()];
    }

    if (results != null) {
      return [sql, "成功"];
    } else {
      return "error";
    }
  }

  static Future selectCourse(String Sno, String Cno) async {
    String sql = "insert into sc values('$Sno','$Cno',NULL);";

    StreamedResults results;
    try {
      results = await conn.execute(sql);
    } catch (e) {
      return [sql, e.toString()];
    }

    if (results != null) {
      return [sql, "已中选"];
    } else {
      return [sql, "选课失败"];
    }
  }

  static Future cancelCourse(String userNo, String Cno) async {
    String sql = "delete from sc where Sno='$userNo' and Cno='$Cno';";

    StreamedResults results;
    try {
      results = await conn.execute(sql);
    } catch (e) {
      return [sql, e.toString()];
    }

    if (results != null) {
      return [sql, "已退选"];
    } else {
      return [sql, "退选失败"];
    }
  }

  static delete(TableBean tableBean) async {
    switch (tableBean.beanName) {
      case TableBeanName.COURSE:
        return await _deleteCourse(tableBean);
        break;
      case TableBeanName.STUDENT:
        return await _deleteStudent(tableBean);
        break;
      case TableBeanName.ADMINSC:
        break;
      case TableBeanName.MYCOURSES:
        // TODO: Handle this case.
        break;
      case TableBeanName.STCOURSE:
        // TODO: Handle this case.
        break;
    }
  }

  static _deleteCourse(TableBean course) async {
    String sql = "delete from course where Cno='${course[0]}';";

    StreamedResults results;
    try {
      results = await conn.execute(sql);
    } catch (e) {
      return [sql, e.toString()];
    }

    if (results != null) {
      return [sql, "成功"];
    } else {
      return "error";
    }
  }

  static _deleteStudent(TableBean student) async {
    String sql = "delete from student where Sno='${student[0]}';";

    StreamedResults results;
    try {
      results = await conn.execute(sql);
    } catch (e) {
      return [sql, e.toString()];
    }

    if (results != null) {
      return [sql, "成功"];
    } else {
      return "error";
    }
  }

  static void deleteAdminSc(TableBean tablebean) {}

  static update(TableBean tableBean) async {
    switch (tableBean.beanName) {
      case TableBeanName.COURSE:
        return await _updateCourse(tableBean);
        break;
      case TableBeanName.STUDENT:
        return await _updateStudent(tableBean);
        break;
      case TableBeanName.ADMINSC:
        break;
      case TableBeanName.MYCOURSES:
        // TODO: Handle this case.
        break;
      case TableBeanName.STCOURSE:
        // TODO: Handle this case.
        break;
    }
  }

  static _updateCourse(TableBean course) async {
    String sql =
        "update course set Cname='${course[1]}',Ccredit=${course[3]} ,Ctype='${course[2]}' where Cno='${course[0]}';";

    StreamedResults results;
    try {
      results = await conn.execute(sql);
    } catch (e) {
      return [sql, e.toString()];
    }

    if (results != null) {
      return [sql, "成功"];
    } else {
      return "error";
    }
  }

  static _updateStudent(TableBean student) async {
    String sql =
        "update student set Sname='${student[1]}',Ssex='${student[2]}',Sage=${student[3]},Sdept='${student[4]}',Spwd='${student[5]}' where Sno='${student[0]}';";

    StreamedResults results;
    try {
      results = await conn.execute(sql);
    } catch (e) {
      return [sql, e.toString()];
    }

    if (results != null) {
      return [sql, "成功"];
    } else {
      return "error";
    }
  }

  static courseLikeSearch(String text, String sortKey, String order) async {
    String sql =
        "select * from course where Cno like '%$text%' or Cname like '%$text%' or Ctype like '%$text%' order by $sortKey $order;";

    StreamedResults results = await conn.execute(sql);
    List<TableBean> courses = [];

    await results.forEach((Row row) {
      TableBean course = TableBean(
          TableBeanName.COURSE, [row[0], row[1], row[3], row[2].toString()]);
      courses.add(course);
    });

    return [courses, sql];
  }

  static void dispose() {
    if (conn != null) {
      conn.close();
      print("数据库关闭连接成功！");
    }
  }

  static studentLikeSearch(String text, String sortKey, String order) async {
    String sql =
        "select * from student where Sno like '%$text%' or Sname like '%$text%' or Ssex like '%$text%' or Sdept like '%$text%' or Spwd like '%$text%' order by $sortKey $order;";

    StreamedResults results = await conn.execute(sql);

    List<TableBean> students = [];

    await results.forEach((Row row) {
      TableBean student = TableBean(TableBeanName.STUDENT,
          [row[0], row[1], row[2], row[3].toString(), row[4], row[5]]);
      students.add(student);
    });

    return [students, sql];
  }

  static adminScLikeSearch(String text, String sortKey, String order) async {
    String sql =
        "select * from standscview where Sno like '%$text%' or Sname like '%$text%' or Cno like '%$text%' or Cname like '%$text%' order by $sortKey $order;";

    StreamedResults results = await conn.execute(sql);

    List<TableBean> scViews = [];

    await results.forEach((Row row) {

      TableBean scView = TableBean(TableBeanName.ADMINSC, [
        row[0],
        row[1],
        row[2],
        row[3],
        row[4].toString(),
        row[5].toString(),
        row[6].toString()
      ]);
      scViews.add(scView);
    });
    return [scViews, sql];
  }

  static stCourseLikeSearch(
      String sno, String text, String sortKey, String order) async {
    String sql =
        "select * from course where Cno not in (select course.Cno from course,sc where sc.Cno=course.Cno and sc.Sno='$sno') and (Cno like '%$text%' or Cname like '%$text%' or Ctype like '%$text%') order by $sortKey $order;";

    StreamedResults results = await conn.execute(sql);
    List<TableBean> stCourses = [];

    await results.forEach((Row row) {
      TableBean course = TableBean(
          TableBeanName.STCOURSE, [row[0], row[1], row[3], row[2].toString()]);
      stCourses.add(course);
    });

    return [stCourses, sql];
  }

  static myCourseLikeSearch(
      String sno, String text, String sortKey, String order) async {
    String sql =
        "select Cno,Cname,Ctype,Ccredit,Grade from ${DataBaseConfigure.stAndScView} where Sno='$sno' and (Cno like '%$text%' or Cname like '%$text%' or Ctype like '%$text%') order by $sortKey $order;";
    StreamedResults results = await conn.execute(sql);
    List<TableBean> myCourses = [];

    await results.forEach((Row row) {
      TableBean scView = TableBean(TableBeanName.MYCOURSES,
          [row[0], row[1], row[2], row[3].toString(), row[4].toString()]);
      myCourses.add(scView);
    });

    return [myCourses, sql];
  }

  static Future updatePwd(String userNo, String newPwd) async {
    String sql = "update student set Spwd='${newPwd}' where Sno='${userNo}';";

    StreamedResults results;
    try {
      results = await conn.execute(sql);
    } catch (e) {
      return [sql, e.toString()];
    }

    if (results != null) {
      return [sql, "密码修改成功！"];
    } else {
      return [sql, "密码修改失败!"];
    }
  }

  static Future updateGrade(String sno, String cno, String grade) async {
    String sql;
    try {
      sql =
          "update sc set Grade='${int.parse(grade)}' where Sno='${sno}' and Cno='${cno}';";
    } catch (e) {
      return [sql, "更新成绩失败，请确保填写了正确的成绩！"];
    }

    StreamedResults results;
    try {
      results = await conn.execute(sql);
    } catch (e) {
      return [sql, e.toString()];
    }

    if (results != null) {
      return [sql, "更新成绩成功！"];
    } else {
      return [sql, "更新成绩失败!"];
    }
  }
}
