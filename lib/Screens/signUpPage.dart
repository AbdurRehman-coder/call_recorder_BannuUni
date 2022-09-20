import 'package:call_recorder/Constants/colors.dart';
import 'package:call_recorder/locator.dart';
import 'package:call_recorder/model/local_user.dart';
import 'package:call_recorder/utils/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:call_recorder/Screens/homePage.dart';
import 'package:call_recorder/Screens/mainPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Sign Up'),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [goldenTextColor, appBarColor],
              )),
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      fillColor: Colors.purple,
                      focusColor: Colors.purple,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                      labelText: 'Enter Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    controller: mobileNumberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mobile No.',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                     controller: confirmPasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                          );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [goldenTextColor, appBarColor],
                              ),
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: 100.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Back",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          if (passwordController.text ==
                              confirmPasswordController.text) {
                            try {
                              EasyLoading.show();
                              final auth = FirebaseAuth.instance;
                              await auth.createUserWithEmailAndPassword(
                                  email: nameController.text.trim(),
                                  password: passwordController.text.trim());
                              final User? user = auth.currentUser;
                              if (user != null) {
                                final localUserData = LocalUser(
                                    name: nameController.text,
                                    phoneNumber: mobileNumberController.text,
                                    email: nameController.text,
                                    password: 'Not Display');
                                await userRepository.add(localUserData);
                                await storage.setUser(localUserData);
                                EasyLoading.dismiss();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );
                                NotificationService notify= NotificationService();
                                notify.showNotifications('Welcome ${nameController.text} ','Sucssfully Create your Account'
                                    );
                              } else {
                                EasyLoading.dismiss();
                                EasyLoading.showError(
                                    'Could not login, please try again.');
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                EasyLoading.showError(
                                    'The password provided is too weak.');
                              } else if (e.code == 'email-already-in-use') {
                                EasyLoading.showError(
                                    'The account already exists for that email.');
                              }
                            }
                          }else{
                            EasyLoading.showError(
                                'Password not Match');
                          }

                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [goldenTextColor, appBarColor],
                              ),
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: 100.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "OK",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}