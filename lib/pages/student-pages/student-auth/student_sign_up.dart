import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../database/student_db.dart';
import '../../../models/student.dart';
import '../../../utils/display_snackbar.dart';
import '../../../utils/preference_constants.dart';
import '../student_home_page.dart';

class StudentSignUp extends StatelessWidget {
  const StudentSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final matricNumber = TextEditingController();
    final fullName = TextEditingController();
    final password = TextEditingController();
    final confirmPwd = TextEditingController();

    bool isTextObscure = true;

    bool isSigningUp = false;

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0,),
      body: StatefulBuilder(
        builder: (ctx, myState) => SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: SizedBox(
                      width: (MediaQuery.of(context).size.width) * .8,
                      child: const Text('SIWES Management System',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.0,
                          fontWeight: FontWeight.w500,),)
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        // ...................................
                        // Matric number
                        // ...................................
                        Container(
                          width: MediaQuery.of(context).size.width * .9,
                          margin: const EdgeInsets.fromLTRB(20, 30.0, 20.0, 0.0),
                          child: TextFormField(
                            controller: matricNumber,
                            onChanged: (value){
                              myState((){});
                            },
                            style: const TextStyle(fontSize: 18.0),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: "Enter Matric/Reg number",
                                errorText: matricNumber.text.isEmpty
                                    ? "Cannot be empty"
                                    : null,
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
                            controller: fullName,
                            onChanged: (value){
                              myState((){});
                            },
                            style: const TextStyle(fontSize: 18.0),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: "Enter full name",
                                errorText: fullName.text.isEmpty
                                    ? "Cannot be empty"
                                    : null,
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                        ),

                        // ...................................
                        // Password
                        // ...................................
                        Container(
                          width: MediaQuery.of(context).size.width * .9,
                          margin: const EdgeInsets.fromLTRB(20, 20.0, 20.0, 0.0),
                          child: TextFormField(
                            controller: password,
                            style: const TextStyle(fontSize: 18.0),
                            obscureText: isTextObscure,
                            onChanged: (value){
                              myState((){});
                            },
                            decoration: InputDecoration(
                              errorText: password.text.isNotEmpty && password.text.length < 6 ? 'Cannot be less than 6 letters' : null,
                                suffixIcon: IconButton(
                                  icon: !isTextObscure
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off,
                                      color: Colors.black54),
                                  onPressed: () {
                                    isTextObscure = !isTextObscure;

                                    myState((){});
                                  },
                                ),
                                labelText: "Enter password",
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                        ),

                        // ...................................
                        // Confirm password
                        // ...................................
                        Container(
                          width: MediaQuery.of(context).size.width * .9,
                          margin: const EdgeInsets.fromLTRB(20, 20.0, 20.0, 0.0),
                          child: TextFormField(
                            controller: confirmPwd,
                            style: const TextStyle(fontSize: 18.0),
                            obscureText: isTextObscure,
                            onChanged: (value){
                              myState((){});
                            },
                            decoration: InputDecoration(
                              errorText: confirmPwd.text != password.text && confirmPwd.text.isNotEmpty && password.text.isNotEmpty ? 'Does not match' : null,
                                suffixIcon: IconButton(
                                  icon: !isTextObscure
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off,
                                      color: Colors.black54),
                                  onPressed: () {
                                    isTextObscure = !isTextObscure;

                                    myState((){});
                                  },
                                ),
                                labelText: "Confirm password",
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 50.0),
                          width: (MediaQuery.of(context).size.width) * .9,
                          height: 50.0,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))
                            ),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();

                              if(matricNumber.text.isEmpty
                                  || password.text.isEmpty
                                  || (password.text.isNotEmpty
                                      && password.text.length < 6)
                              || password.text != confirmPwd.text
                              ){
                                return;
                              }

                              myState((){
                                isSigningUp = true;
                              });

                              StudentDB.instance.authenticateUser(matricNumber.text, password.text)
                                  .then((isExist) async {
                                if(isExist){
                                  displaySnackBar(context, message: 'User already exists');
                                } else {
                                  Student student = Student(
                                    matricNumber: matricNumber.text,
                                    password: password.text,
                                    fullName: fullName.text,
                                  );

                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const StudentHomepage()));

                                  await StudentDB.instance.insert(student);

                                  SharedPreferences.getInstance().then((preferences) {
                                    preferences.setString(SharedPrefConstants.MATRIC_NUMBER, matricNumber.text);
                                  });

                                  matricNumber.clear();
                                  password.clear();
                                  fullName.clear();
                                  confirmPwd.clear();
                                }
                              });

                              myState((){
                                isSigningUp = false;
                              });

                            },
                            child: isSigningUp
                                ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))
                                : const Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 80.0),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
