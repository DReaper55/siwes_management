import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siwes_management/main.dart';

import 'it-log-page/it_log_page.dart';
import 'it_info_page.dart';
import 'student_profile_page.dart';
import '../../utils/preference_constants.dart';

class StudentHomepage extends StatelessWidget {
  const StudentHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SIWES'),),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const StudentProfilePage())),
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
            // Logs
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
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ITLogPage())),
                child: const Text(
                  "IT Logs",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // color: Theme.of(context).primaryColor,
              ),
            ),

            // ....................................
            // IT Info
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
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ITInfoPage())),
                child: const Text(
                  "IT Info",
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
                    preferences.setString(SharedPrefConstants.MATRIC_NUMBER, '');

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
    );
  }
}
