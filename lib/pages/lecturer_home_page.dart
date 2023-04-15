import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siwes_management/main.dart';

import 'lecturer_profile_page.dart';
import '../utils/preference_constants.dart';

class LecturerHomepage extends StatelessWidget {
  const LecturerHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SIWES'),),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ....................................
              // Profile
              // ....................................
              Container(
                margin: const EdgeInsets.only(top: 50.0),
                width: (MediaQuery.of(context).size.width) * .9,
                height: 50.0,
                child: OutlinedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).primaryColor)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))
                  ),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LecturerProfilePage())),
                  child: const Text(
                    "Profile",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // color: Theme.of(context).primaryColor,
                ),
              ),

              // ....................................
              // Placement Allocations
              // ....................................
              Container(
                margin: const EdgeInsets.only(top: 50.0),
                width: (MediaQuery.of(context).size.width) * .9,
                height: 50.0,
                child: OutlinedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).primaryColor)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))
                  ),
                  onPressed: (){},
                  child: const Text(
                    "Placement Allocations",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // color: Theme.of(context).primaryColor,
                ),
              ),

              // ....................................
              // Supervisor Allocations
              // ....................................
              Container(
                margin: const EdgeInsets.only(top: 50.0),
                width: (MediaQuery.of(context).size.width) * .9,
                height: 50.0,
                child: OutlinedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).primaryColor)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))
                  ),
                  onPressed: (){},
                  child: const Text(
                    "Supervisor Allocations",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // color: Theme.of(context).primaryColor,
                ),
              ),

              // ....................................
              // Scores
              // ....................................
              Container(
                margin: const EdgeInsets.only(top: 50.0),
                width: (MediaQuery.of(context).size.width) * .9,
                height: 50.0,
                child: OutlinedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).primaryColor)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))
                  ),
                  onPressed: (){},
                  child: const Text(
                    "Grades",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // color: Theme.of(context).primaryColor,
                ),
              ),

              // ....................................
              // Sign out
              // ....................................
              Container(
                margin: const EdgeInsets.only(top: 150.0),
                width: (MediaQuery.of(context).size.width) * .9,
                height: 50.0,
                child: TextButton(
                  onPressed: (){
                    SharedPreferences.getInstance().then((preferences) {
                      preferences.setString(SharedPrefConstants.STAFF_NUMBER, '');

                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const Homepage()));
                    });
                  },
                  child: const Text(
                    "Sign out",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // color: Theme.of(context).primaryColor,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
