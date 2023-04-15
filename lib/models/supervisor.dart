class Supervisor{
  String? id, supervisorName;
  int? numberOfStudents;


  Supervisor({this.id, this.supervisorName});

  Supervisor.fromMap(Map<dynamic, dynamic> list) {
    id = list['id'];
    supervisorName = list['supervisorName'];
    numberOfStudents = list['numberOfStudents'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'numberOfStudents': numberOfStudents,
      'supervisorName': supervisorName
    };
  }
}