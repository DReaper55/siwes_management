class Placement{
  String? id, companyName;
  int? numberOfStudents;


  Placement({this.id, this.companyName});

  Placement.fromMap(Map<dynamic, dynamic> list) {
    id = list['id'];
    companyName = list['companyName'];
    numberOfStudents = list['numberOfStudents'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'numberOfStudents': numberOfStudents,
      'companyName': companyName
    };
  }
}