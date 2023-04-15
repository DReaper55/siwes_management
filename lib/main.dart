import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siwes_management/pages/student-pages/student_home_page.dart';

import 'pages/lecturer-pages/lecturer-auth/lecturer_login.dart';
import 'pages/student-pages/student-auth/student_login.dart';
import 'pages/lecturer-pages/lecturer_home_page.dart';
import 'utils/preference_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIWES',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) {
      String? matric = value.getString(SharedPrefConstants.MATRIC_NUMBER);

      if(matric != null && matric != ''){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=> const StudentHomepage()));
        return;
      }

      String? staffId = value.getString(SharedPrefConstants.STAFF_NUMBER);

      if(staffId != null && staffId != ''){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=> const LecturerHomepage()));
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0,),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: (MediaQuery.of(context).size.width) * .8,
              child: const Text('SIWES Management System',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0,
                  fontWeight: FontWeight.w500,),)
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0))),
                            ),
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LecturerLogin())),
                        child: const Text(
                          'Lecturer',
                          style: TextStyle(
                              color: Colors.white, fontSize: 18.0),
                        )),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.teal),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0))),
                            ),
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const StudentLogin())),
                        child: const Text(
                          'Student',
                          style: TextStyle(
                              color: Colors.white, fontSize: 18.0),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
