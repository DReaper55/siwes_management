import 'dart:math';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:siwes_management/database/supervisor_db.dart';
import 'package:siwes_management/database/student_db.dart';
import 'package:siwes_management/models/supervisor.dart';

import '../../../models/student.dart';
import '../../../utils/student_allocation_bottom_sheet.dart';

class LecturerSupervisorPage extends StatefulWidget {
  const LecturerSupervisorPage({Key? key}) : super(key: key);

  @override
  State<LecturerSupervisorPage> createState() => _LecturerSupervisorPageState();
}

class _LecturerSupervisorPageState extends State<LecturerSupervisorPage> {
  List<Supervisor> listOfSupervisors = [];

  @override
  void initState() {
    _getSupervisors();
    super.initState();
  }

  _getSupervisors() async {
    listOfSupervisors = await SupervisorDB.instance.getAllSupervisors();

    for(int i = 0; i < listOfSupervisors.length; i++){
      List<Student> foundStudents = await StudentDB.instance.getAllStudentsWithSupervisor(listOfSupervisors[i].id!);

      listOfSupervisors[i].numberOfStudents = foundStudents.length;
    }

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supervisor Page')),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await showDialog(
                context: context,
                builder: (ctx) {
                  return _showCompanyModifierDialog(context);
                });

            if(result is String && result.isNotEmpty){
              Supervisor supervisor = Supervisor(
                supervisorName: result,
                id: Random().nextInt((pow(2, 31) - 1).toInt()).toString(),
              );

              await SupervisorDB.instance.insert(supervisor);

              supervisor.numberOfStudents = 0;

              listOfSupervisors.add(supervisor);

              setState(() {

              });
            }
          },
          child: const Icon(Icons.add)
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.separated(
            itemCount: listOfSupervisors.length,
            separatorBuilder: (ctx, i) => const Divider(indent: 30.0,),
            itemBuilder: (ctx, i){
              Supervisor company = listOfSupervisors[i];

              return ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: Text(company.supervisorName!),
                subtitle: Text("${company.numberOfStudents!} students allocated"),
                trailing: IconButton(
                  onPressed: () async {
                    final result = await showDialog(
                        context: context,
                        builder: (ctx) {
                          return _showCompanyModifierDialog(context, supervisorName: company.supervisorName!);
                        });

                    if(result is String && result.isNotEmpty){
                      Supervisor supervisor = Supervisor(
                        supervisorName: result,
                        id: Random().nextInt((pow(2, 31) - 1).toInt()).toString(),
                      );

                      supervisor.numberOfStudents = company.numberOfStudents!;

                      Supervisor supervisorDB = await SupervisorDB.instance.getOneSupervisor(company.id!);

                      if(supervisorDB.id != null){
                        await SupervisorDB.instance.updateSupervisor(supervisor, company.id!);

                        listOfSupervisors.removeAt(i);

                        listOfSupervisors.insert(i, supervisor);
                      } else {
                        await SupervisorDB.instance.insert(supervisor);

                        listOfSupervisors.add(supervisor);
                      }

                      setState(() {

                      });
                    }
                  },
                  icon: const Icon(Icons.edit),
                ),
                onTap: () async {
                  List<Student> students = await StudentDB.instance.getAllStudentsWithoutSupervisor();

                  final selectedStudents = await showCustomModalBottomSheet(
                      enableDrag: true,
                      expand: true,
                      bounce: true,
                      context: context,
                      builder: (builder) => const SizedBox(),
                      containerWidget: (context, animation, child) =>
                      studentAllocationBottomSheet(context, students));

                  if(selectedStudents is List<Student> && selectedStudents.isNotEmpty){
                    Supervisor supervisorDB = await SupervisorDB.instance.getOneSupervisor(company.id!);

                    supervisorDB.numberOfStudents = selectedStudents.length;

                    if(supervisorDB.id != null){
                      await SupervisorDB.instance.updateSupervisor(supervisorDB, company.id!);

                      listOfSupervisors.removeAt(i);

                      listOfSupervisors.insert(i, supervisorDB);
                    }

                    for(Student student in selectedStudents){
                      Student studentDB = await StudentDB.instance.getOneStudent(student.matricNumber!);

                      if(studentDB.matricNumber != null){
                        studentDB.supervisorId = supervisorDB.id!;

                        await StudentDB.instance.updateStudent(studentDB, studentDB.matricNumber!);
                      }
                    }
                  }

                  setState(() {

                  });
                },
              );
            }
        ),
      ),
    );
  }
}

_showCompanyModifierDialog(context, {String? supervisorName}) {
  final supervisorNameCtrl = TextEditingController();

  if(supervisorName != null){
    supervisorNameCtrl.text = supervisorName;
  }

  return Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)),
    child: StatefulBuilder(
      builder: (ctx, myState) => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height) / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 15.0, bottom: 30.0),
              width: MediaQuery.of(context).size.width,
              child: const Text(
                "Modify Details",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),

            Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                height: 100,
                child: TextField(
                  controller: supervisorNameCtrl,
                  style: const TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(10.0))),
                )),

            Container(
              width: 500.0,
              margin: const EdgeInsets.only(top: 70.0),
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0)))),
                      minimumSize: MaterialStateProperty.all(
                          const Size(500.0, 50.0))),
                  onPressed: () async {
                    Navigator.of(context).pop(supervisorNameCtrl.text);

                  },
                  child: const Text(
                    'Save',
                    style:
                    TextStyle(color: Colors.white, fontSize: 18.0),
                  )),
            )
          ],
        ),
      ),
    ),
  );
}
