import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../database/lecturer_db.dart';
import '../../../utils/display_snackbar.dart';
import '../../../utils/preference_constants.dart';
import '../lecturer_home_page.dart';
import 'lecturer_sign_up.dart';

class LecturerLogin extends StatelessWidget {
  const LecturerLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final staffNumber = TextEditingController();
    final password = TextEditingController();

    bool isTextObscure = true;

    bool isLoginIn = false;

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0,),
      body: StatefulBuilder(
        builder: (ctx, myState) => SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                flex: 3,
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
                flex: 7,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .9,
                        margin: const EdgeInsets.fromLTRB(20, 0.0, 20.0, 0.0),
                        child: TextFormField(
                          controller: staffNumber,
                          style: const TextStyle(fontSize: 18.0),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: "Enter staff number",
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .9,
                        margin: const EdgeInsets.fromLTRB(20, 20.0, 20.0, 0.0),
                        child: TextFormField(
                            controller: password,
                            style: const TextStyle(fontSize: 18.0),
                            obscureText: isTextObscure,
                            decoration: InputDecoration(
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

                            if(staffNumber.text.isEmpty
                                || password.text.isEmpty){
                              return;
                            }

                            myState((){
                              isLoginIn = true;
                            });

                            LecturerDB.instance.authenticateUser(staffNumber.text, password.text)
                                .then((isExist) {
                              if(isExist){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const LecturerHomepage()));

                                SharedPreferences.getInstance().then((preferences) {
                                  preferences.setString(SharedPrefConstants.STAFF_NUMBER, staffNumber.text);
                                });

                              } else {
                                displaySnackBar(context, message: 'Wrong email or password');
                              }
                            });

                            myState((){
                              isLoginIn = false;
                            });
                          },
                          child: isLoginIn
                              ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                              : const Text(
                            "Login",
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => const LecturerSignUp()));

                                  isLoginIn = false;

                                  myState((){});
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
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
