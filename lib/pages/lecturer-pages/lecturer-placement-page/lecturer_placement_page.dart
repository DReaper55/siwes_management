import 'dart:math';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:siwes_management/database/placement_db.dart';
import 'package:siwes_management/database/student_db.dart';
import 'package:siwes_management/models/placement.dart';

import '../../../models/student.dart';
import '../../../utils/student_allocation_bottom_sheet.dart';

class LecturerPlacementPage extends StatefulWidget {
  const LecturerPlacementPage({Key? key}) : super(key: key);

  @override
  State<LecturerPlacementPage> createState() => _LecturerPlacementPageState();
}

class _LecturerPlacementPageState extends State<LecturerPlacementPage> {
  List<Placement> listOfPlacements = [];

  @override
  void initState() {
    _getPlacements();
    super.initState();
  }

  _getPlacements() async {
    listOfPlacements = await PlacementDB.instance.getAllPlacements();

    for(int i = 0; i < listOfPlacements.length; i++){
      List<Student> foundStudents = await StudentDB.instance.getAllStudentsWithPlacement(listOfPlacements[i].id!);

      listOfPlacements[i].numberOfStudents = foundStudents.length;
    }

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Placement Page')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
              context: context,
              builder: (ctx) {
                return _showCompanyModifierDialog(context);
              });

          if(result is String && result.isNotEmpty){
            Placement placement = Placement(
              companyName: result,
              id: Random().nextInt((pow(2, 31) - 1).toInt()).toString(),
            );

            await PlacementDB.instance.insert(placement);

            placement.numberOfStudents = 0;

            listOfPlacements.add(placement);

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
            itemCount: listOfPlacements.length,
            separatorBuilder: (ctx, i) => const Divider(indent: 30.0,),
            itemBuilder: (ctx, i){
              Placement company = listOfPlacements[i];

              return ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: Text(company.companyName!),
                subtitle: Text("${company.numberOfStudents!} students allocated"),
                trailing: IconButton(
                  onPressed: () async {
                    final result = await showDialog(
                        context: context,
                        builder: (ctx) {
                          return _showCompanyModifierDialog(context, companyName: company.companyName!);
                        });

                    if(result is String && result.isNotEmpty){
                      Placement placement = Placement(
                        companyName: result,
                        id: Random().nextInt((pow(2, 31) - 1).toInt()).toString(),
                      );

                      placement.numberOfStudents = company.numberOfStudents!;

                      Placement placementDB = await PlacementDB.instance.getOnePlacement(company.id!);

                      if(placementDB.id != null){
                        await PlacementDB.instance.updatePlacement(placement, company.id!);

                        listOfPlacements.removeAt(i);

                        listOfPlacements.insert(i, placement);
                      } else {
                        await PlacementDB.instance.insert(placement);

                        listOfPlacements.add(placement);
                      }

                      setState(() {

                      });
                    }
                  },
                  icon: const Icon(Icons.edit),
                ),
                onTap: () async {
                  List<Student> students = await StudentDB.instance.getAllStudentsWithoutPlacement();

                  final selectedStudents = await showCustomModalBottomSheet(
                      enableDrag: true,
                      expand: true,
                      bounce: true,
                      context: context,
                      builder: (builder) => const SizedBox(),
                      containerWidget: (context, animation, child) =>
                          studentAllocationBottomSheet(context, students));

                  if(selectedStudents is List<Student> && selectedStudents.isNotEmpty){
                    Placement supervisorDB = await PlacementDB.instance.getOnePlacement(company.id!);

                    supervisorDB.numberOfStudents = selectedStudents.length;

                    if(supervisorDB.id != null){
                      await PlacementDB.instance.updatePlacement(supervisorDB, company.id!);

                      listOfPlacements.removeAt(i);

                      listOfPlacements.insert(i, supervisorDB);
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

_showCompanyModifierDialog(context, {String? companyName}) {
  final companyNameCtrl = TextEditingController();

  if(companyName != null){
    companyNameCtrl.text = companyName;
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
                "Modify Company",
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
                  controller: companyNameCtrl,
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
                    Navigator.of(context).pop(companyNameCtrl.text);

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
