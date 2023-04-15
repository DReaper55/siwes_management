import 'package:flutter/material.dart';
import 'package:siwes_management/database/daily_log_db.dart';

import '../../../models/daily_log.dart';
import 'log_entry_page.dart';

class DailyLogsPage extends StatefulWidget {
  final int weekId;
  const DailyLogsPage({Key? key, required this.weekId}) : super(key: key);

  @override
  State<DailyLogsPage> createState() => _DailyLogsPageState();
}

class _DailyLogsPageState extends State<DailyLogsPage> {
  List<DailyLog> dailyLogsList = [];

  @override
  void initState() {
    _getDailyLogs();
    super.initState();
  }

  _getDailyLogs() async {
    dailyLogsList = await DailyLogDB.instance.getSomeDailyLogs(widget.weekId);

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Week #${widget.weekId}"),),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => LogEntryPage(weeklyLogId: widget.weekId,))),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => _getDailyLogs(),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (ctx, i){
              DailyLog dailyLog = dailyLogsList[i];

              return ListTile(
                title: Text(dailyLog.dateTime!),
                subtitle: Text(dailyLog.entry!),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => LogEntryPage(weeklyLogId: widget.weekId, dailyLogId: dailyLog.logId,)));
                },
              );
            },
            separatorBuilder: (ctx, i) => const Divider(indent: 30.0,),
            itemCount: dailyLogsList.length
        ),
      ),
    );
  }
}
