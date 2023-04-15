import 'package:flutter/material.dart';
import 'package:siwes_management/database/weekly_log_db.dart';
import 'package:siwes_management/models/weekly_log.dart';

import '../../../database/daily_log_db.dart';
import '../../../models/daily_log.dart';
import 'daily_logs_page.dart';

class ITLogPage extends StatefulWidget {
  const ITLogPage({Key? key}) : super(key: key);

  @override
  State<ITLogPage> createState() => _ITLogPageState();
}

class _ITLogPageState extends State<ITLogPage> {
  List<WeeklyLog> weeklyLogList = [];

  @override
  void initState() {
    _getWeeklyLogs();
    super.initState();
  }

  _getWeeklyLogs() async {
    weeklyLogList.clear();

    for(int i = 1; i <= 24; i++){
      WeeklyLog weeklyLog = WeeklyLog(
        weeklyLogId: i
      );

      WeeklyLog weeklyLogDB = await WeeklyLogDB.instance.getOneWeeklyLog(i);
      if(weeklyLogDB.weeklyLogId != null){
        weeklyLog = weeklyLogDB;
      }

      List<DailyLog> logList = await DailyLogDB.instance.getSomeDailyLogs(i);
      weeklyLog.numberOfEntries = logList.length;

      weeklyLogList.add(weeklyLog);
    }

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logs'),),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: RefreshIndicator(
          onRefresh: () => _getWeeklyLogs(),
          child: ListView.separated(
              itemCount: weeklyLogList.length,
              separatorBuilder: (ctx, i) => const Divider(indent: 30.0,),
              itemBuilder: (ctx, i){
               WeeklyLog weeklyLog = weeklyLogList[i];

               return ListTile(
                 title: Text('Week #${weeklyLog.weeklyLogId}'),
                 subtitle: Text('Entries: ${weeklyLog.numberOfEntries}/6'),
                 trailing: (){
                   if(weeklyLog.fileAttachmentPath != null){
                     return IconButton(
                       onPressed: (){
                       //   todo: display attachment
                       },
                       icon: const Icon(Icons.attach_file),
                     );
                   }
                 }(),
                 onTap: (){
                   Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => DailyLogsPage(weekId: weeklyLog.weeklyLogId!)));
                 },
               );
              }
          ),
        ),
      ),
    );
  }
}
