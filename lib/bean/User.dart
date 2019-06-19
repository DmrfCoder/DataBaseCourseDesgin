enum UserType { ADMIN, STUDENT }

class User {
  UserType userType;

  String userNo;
  String userName;
  String sex;
  int age;
  String dept;
  String password;

  User(this.userType, this.userNo, this.userName, this.sex, this.age, this.dept,
      this.password);
}
