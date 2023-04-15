import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/lecturer_db.dart';
import '../models/lecturer.dart';
import '../utils/display_snackbar.dart';
import '../utils/preference_constants.dart';

class LecturerProfilePage extends StatefulWidget {
  const LecturerProfilePage({Key? key}) : super(key: key);

  @override
  State<LecturerProfilePage> createState() => _LecturerProfilePageState();
}

class _LecturerProfilePageState extends State<LecturerProfilePage> {
  final staffIdCtrl = TextEditingController();
  final facultyCtrl = TextEditingController();
  final departmentCtrl = TextEditingController();
  final fullNameCtrl = TextEditingController();

  SharedPreferences? _preferences;

  Lecturer? lecturer;

  @override
  void initState() {
    _getLecturerData();
    super.initState();
  }

  _getLecturerData() async {
    _preferences = await SharedPreferences.getInstance();

    String? staffId = _preferences!.getString(SharedPrefConstants.STAFF_NUMBER);

    if (staffId != null) {
      staffIdCtrl.text = staffId;

      lecturer = await LecturerDB.instance.getOneLecturer(staffId);

      fullNameCtrl.text = lecturer!.fullName ?? '';
      facultyCtrl.text = lecturer!.faculty ?? '';
      departmentCtrl.text = lecturer!.department ?? '';
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
          Lecturer mLecturer = Lecturer(
            staffId: staffIdCtrl.text,
            fullName: fullNameCtrl.text,
            department: departmentCtrl.text,
            faculty: facultyCtrl.text,
          );

          if(_image != null){
            mLecturer.displayImagePath = _image!.path;
          }

          await LecturerDB.instance.updateLecturer(mLecturer, staffIdCtrl.text);

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
                        backgroundImage: lecturer != null && lecturer!.displayImagePath != null &&
                            _image == null
                            ? FileImage(File(lecturer!.displayImagePath!))
                            : _image != null ? FileImage(
                            _image!) as ImageProvider : null,
                        child: lecturer != null && lecturer!.displayImagePath == null && lecturer!.fullName != null && _image == null
                            ? Text(
                          lecturer!.fullName![0].toUpperCase(),
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
              // Staff number
              // ...................................
              Container(
                width: MediaQuery.of(context).size.width * .9,
                margin: const EdgeInsets.fromLTRB(20, 30.0, 20.0, 0.0),
                child: TextFormField(
                  controller: staffIdCtrl,
                  style: const TextStyle(fontSize: 18.0),
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Staff number",
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
