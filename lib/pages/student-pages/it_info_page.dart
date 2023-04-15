import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siwes_management/database/placement_db.dart';
import 'package:siwes_management/database/supervisor_db.dart';
import 'package:siwes_management/models/placement.dart';
import 'package:siwes_management/models/student.dart';
import 'package:siwes_management/models/supervisor.dart';
import 'package:siwes_management/utils/preference_constants.dart';

import '../../database/student_db.dart';

class ITInfoPage extends StatefulWidget {
  const ITInfoPage({Key? key}) : super(key: key);

  @override
  State<ITInfoPage> createState() => _ITInfoPageState();
}

class _ITInfoPageState extends State<ITInfoPage> {
  Supervisor? supervisor;
  Placement? company;

  SharedPreferences? _preferences;

  Student? student;

  @override
  void initState() {
    _getITInfo();
    super.initState();
  }

  _getITInfo() async {
    _preferences = await SharedPreferences.getInstance();

    String? matric = _preferences!.getString(SharedPrefConstants.MATRIC_NUMBER);

    if (matric != null) {
      student = await StudentDB.instance.getOneStudent(matric);

      if (student!.supervisorId != null) {
        supervisor =
        await SupervisorDB.instance.getOneSupervisor(student!.supervisorId!);
      }

    if (student!.placementId != null) {
        company =
        await PlacementDB.instance.getOnePlacement(student!.placementId!);
      }
    }

    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IT Info'),),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // ...................................
            // Supervisor
            // ...................................
            if(supervisor != null && supervisor!.id != null)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              elevation: 3.0,
              child: ListTile(
                leading: const Text('Supervisor:'),
                title: Text(supervisor!.supervisorName!),
                subtitle: Text("${supervisor!.numberOfStudents!} assigned students"),
              ),
            ),

            // ...................................
            // Placement
            // ...................................
            if(company != null && company!.id != null)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              elevation: 3.0,
              child: ListTile(
                leading: const Text('Placement:'),
                title: Text(company!.companyName!),
                subtitle: Text("${company!.numberOfStudents!} assigned students"),
              ),
            ),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              elevation: 3.0,
              child: const ListTile(
                leading: Text('Grades:'),
                title: Text('Not assigned'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
