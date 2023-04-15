import 'dart:math';

import 'package:flutter/material.dart';
import 'package:siwes_management/database/daily_log_db.dart';
import 'package:siwes_management/database/weekly_log_db.dart';
import 'package:siwes_management/models/daily_log.dart';
import 'package:siwes_management/models/weekly_log.dart';
import 'package:siwes_management/utils/display_snackbar.dart';

class LogEntryPage extends StatefulWidget {
  final String? dailyLogId;
  final int weeklyLogId;

  const LogEntryPage({Key? key, this.dailyLogId, required this.weeklyLogId}) : super(key: key);

  @override
  State<LogEntryPage> createState() => _LogEntryPageState();
}

class _LogEntryPageState extends State<LogEntryPage> {
  DateTime entryTime = DateTime.now();
  final entryCtrl = TextEditingController();

  @override
  void initState() {
    _getLogDetails();
    super.initState();
  }

  _getLogDetails() async {
    if(widget.dailyLogId == null) return;

    DailyLog dailyLog = await DailyLogDB.instance.getOneDailyLog(widget.dailyLogId!);

    if(dailyLog.logId != null){
      entryTime = DateTime.parse(dailyLog.dateTime!);
      entryCtrl.text = dailyLog.entry!;
    }

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entry'),),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (entryCtrl.text.isEmpty) return;

          DailyLog dailyLog = DailyLog(
            dateTime: entryTime.toString(),
            entry: entryCtrl.text,
            logId: Random().nextInt((pow(2, 31) - 1).toInt()).toString(),
            weekId: widget.weeklyLogId,
          );

          if (widget.dailyLogId != null) {
            DailyLog dailyLogDB = await DailyLogDB.instance.getOneDailyLog(
                widget.dailyLogId!);

            if (dailyLogDB.logId != null) {
              dailyLog.logId = dailyLogDB.logId!;

              await DailyLogDB.instance.updateDailyLog(
                  dailyLog, dailyLog.logId!);
            } else {
              await DailyLogDB.instance.insert(dailyLog);
            }
          } else {
            await DailyLogDB.instance.insert(dailyLog);
          }

          WeeklyLog weeklyLog = WeeklyLog(
            weeklyLogId: widget.weeklyLogId,
            dailyLogId: dailyLog.logId!
          );

          WeeklyLog weeklyLogDB = await WeeklyLogDB.instance.getOneWeeklyLog(widget.weeklyLogId);

          if(weeklyLogDB.weeklyLogId != null){
            if(weeklyLogDB.dailyLogId != null && weeklyLogDB.dailyLogId!.contains(dailyLog.logId!)){
              List<String> logIds = weeklyLogDB.dailyLogId!.split('-');

              logIds.removeWhere((element) => element == dailyLog.logId!);

              weeklyLog.dailyLogId = logIds.join('-');

            } else {
              await WeeklyLogDB.instance.insert(weeklyLog);
            }
          } else {
            await WeeklyLogDB.instance.insert(weeklyLog);
          }

          if (mounted) {
            displaySnackBar(context, message: 'Saved Entry');
          }
        },
        child: const Icon(Icons.check),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Date:'),
                  OutlinedButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).primaryColor)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)))
                      ),
                      onPressed: () async {
                        entryTime = (await showDatePicker(
                        context: context,
                        firstDate: entryTime,
                        initialDate: entryTime,
                            lastDate: DateTime.now()
                            .add(const Duration(days: 3650))))!;

                        setState(() {

                        });
                      },
                      child: Text(entryTime.toString()))
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 300.0,
                child: TextFormField(
                  controller: entryCtrl,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16.0),
                  maxLines: 10,
                  minLines: 1,
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                      hintText:
                      "Log entry",
                      border: OutlineInputBorder(
                          )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
