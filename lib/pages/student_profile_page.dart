import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siwes_management/models/student.dart';

import '../database/student_db.dart';
import '../utils/display_snackbar.dart';
import '../utils/preference_constants.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({Key? key}) : super(key: key);

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final matricNumberCtrl = TextEditingController();
  final facultyCtrl = TextEditingController();
  final departmentCtrl = TextEditingController();
  final fullNameCtrl = TextEditingController();

  SharedPreferences? _preferences;

  Student? student;

  @override
  void initState() {
    _getStudentData();
    super.initState();
  }

  _getStudentData() async {
    _preferences = await SharedPreferences.getInstance();

    String? matric = _preferences!.getString(SharedPrefConstants.MATRIC_NUMBER);

    if (matric != null) {
      matricNumberCtrl.text = matric;

      student = await StudentDB.instance.getOneStudent(matric);

      fullNameCtrl.text = student!.fullName ?? '';
      facultyCtrl.text = student!.faculty ?? '';
      departmentCtrl.text = student!.department ?? '';
    }

    setState(() {

    });
  }

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 60);

    if (pickedFile != null) {
      _image = File(pickedFile.path);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'),),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Student mStudent = Student(
            matricNumber: matricNumberCtrl.text,
            fullName: fullNameCtrl.text,
            department: departmentCtrl.text,
            faculty: facultyCtrl.text,
          );

          if(_image != null){
            mStudent.displayImagePath = _image!.path;
          }

          await StudentDB.instance.updateStudent(mStudent, matricNumberCtrl.text);

          if(mounted) {
            displaySnackBar(context, message: 'Saved details');
          }
        },
        child: const Icon(Icons.check),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Stack(
                  children: [
                    CircleAvatar(
                        radius: 70.0,
                        backgroundImage: student != null && student!.displayImagePath != null &&
                            _image == null
                            ? FileImage(File(student!.displayImagePath!))
                            : _image != null ? FileImage(
                            _image!) as ImageProvider : null,
                        child: student != null && student!.displayImagePath == null && student!.fullName != null && _image == null
                            ? Text(
                          student!.fullName![0].toUpperCase(),
                          style:
                          const TextStyle(color: Colors.white),
                        )
                            : null),
                    Positioned(
                      top: 90.0,
                      left: 90.0,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          onPressed: getImage,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // ...................................
              // Matric number
              // ...................................
              Container(
                width: MediaQuery.of(context).size.width * .9,
                margin: const EdgeInsets.fromLTRB(20, 30.0, 20.0, 0.0),
                child: TextFormField(
                  controller: matricNumberCtrl,
                  style: const TextStyle(fontSize: 18.0),
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Matric/Reg number",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
              ),

              // ...................................
              // Full name
              // ...................................
              Container(
                width: MediaQuery.of(context).size.width * .9,
                margin: const EdgeInsets.fromLTRB(20, 20.0, 20.0, 0.0),
                child: TextFormField(
                  controller: fullNameCtrl,
                  onChanged: (value){
                    setState((){});
                  },
                  style: const TextStyle(fontSize: 18.0),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Full name",
                      errorText: fullNameCtrl.text.isEmpty
                          ? "Cannot be empty"
                          : null,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
              ),

              // ...................................
              // Faculty
              // ...................................
              Container(
                width: MediaQuery.of(context).size.width * .9,
                margin: const EdgeInsets.fromLTRB(20, 20.0, 20.0, 0.0),
                child: TextFormField(
                  controller: facultyCtrl,
                  style: const TextStyle(fontSize: 18.0),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Faculty",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
              ),

              // ...................................
              // Department
              // ...................................
              Container(
                width: MediaQuery.of(context).size.width * .9,
                margin: const EdgeInsets.fromLTRB(20, 20.0, 20.0, 0.0),
                child: TextFormField(
                  controller: departmentCtrl,
                  style: const TextStyle(fontSize: 18.0),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Department",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
