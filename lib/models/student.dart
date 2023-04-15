class Student {
  String? matricNumber, password, fullName, displayImagePath;
  String? department, faculty;
  String? placementId, supervisorId;

  bool isSelected = false;


  Student({this.matricNumber, this.password, this.fullName, this.displayImagePath,
    this.department, this.supervisorId, this.placementId, this.faculty});

  Student.fromMap(Map<dynamic, dynamic> list) {
    matricNumber = list['matricNumber'];
    password = list['password'];
    fullName = list['fullName'];
    displayImagePath = list['displayImagePath'];
    department = list['department'];
    faculty = list['faculty'];
    placementId = list['placementId'];
    supervisorId = list['supervisorId'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'matricNumber': matricNumber,
      'password': password,
      'fullName': fullName,
      'displayImagePath': displayImagePath,
      'faculty': faculty,
      'supervisorId': supervisorId,
      'placementId': placementId,
      'department': department
    };
  }
}