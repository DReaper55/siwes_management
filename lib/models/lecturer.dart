class Lecturer {
  String? staffId, password, fullName, displayImagePath;
  String? department, faculty;


  Lecturer({this.staffId, this.password, this.fullName, this.displayImagePath,
    this.department, this.faculty});

  Lecturer.fromMap(Map<dynamic, dynamic> list) {
    staffId = list['staffId'];
    password = list['password'];
    fullName = list['fullName'];
    displayImagePath = list['displayImagePath'];
    department = list['department'];
    faculty = list['faculty'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'staffId': staffId,
      'password': password,
      'fullName': fullName,
      'displayImagePath': displayImagePath,
      'faculty': faculty,
      'department': department
    };
  }
}