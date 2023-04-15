class LecturerDBConstants {
  static const String staffId = "staffId";
  static const String password = "password";
  static const String fullName = "fullName";
  static const String displayImagePath = "displayImagePath";
  static const String department = "department";
  static const String faculty = "faculty";
}

class StudentDBConstants {
  static const String matricNumber = "matricNumber";
  static const String password = "password";
  static const String fullName = "fullName";
  static const String placementId = "placementId";
  static const String supervisorId = "supervisorId";
  static const String displayImagePath = "displayImagePath";
  static const String department = "department";
  static const String faculty = "faculty";
}

class PlacementDBConstants {
  static const String id = "id";
  static const String companyName = "companyName";
  static const String numberOfStudents = "numberOfStudents";
}

class SupervisorDBConstants {
  static const String id = "id";
  static const String supervisorName = "supervisorName";
  static const String numberOfStudents = "numberOfStudents";
}

class DailyLogDBConstants {
  static const String logId = "logId";
  static const String dateTime = "dateTime";
  static const String weekId = "weekId";
  static const String entry = "entry";
}

class WeeklyLogDBConstants {
  static const String dailyLogId = "dailyLogId";
  static const String numberOfEntries = "numberOfEntries";
  static const String weeklyLogId = "weeklyLogId";
  static const String fileAttachmentPath = "fileAttachmentPath";
}