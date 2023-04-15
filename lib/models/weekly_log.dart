class WeeklyLog{
  String? dailyLogId, fileAttachmentPath;
  int? weeklyLogId, numberOfEntries;

  WeeklyLog({this.dailyLogId, this.weeklyLogId, this.fileAttachmentPath});

  WeeklyLog.fromMap(Map<dynamic, dynamic> list) {
    dailyLogId = list['dailyLogId'];
    weeklyLogId = list['weeklyLogId'];
    fileAttachmentPath = list['fileAttachmentPath'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dailyLogId': dailyLogId,
      'fileAttachmentPath': fileAttachmentPath,
      'weeklyLogId': weeklyLogId
    };
  }
}