class DailyLog{
  String? logId, dateTime, entry;
  int? weekId;

  DailyLog({this.logId, this.weekId, this.dateTime, this.entry});

  DailyLog.fromMap(Map<dynamic, dynamic> list) {
    logId = list['logId'];
    dateTime = list['dateTime'];
    weekId = list['weekId'];
    entry = list['entry'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'logId': logId,
      'entry': entry,
      'weekId': weekId,
      'dateTime': dateTime
    };
  }
}