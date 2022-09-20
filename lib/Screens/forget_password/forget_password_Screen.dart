import 'package:call_recorder/Screens/loginInPage.dart';
import 'package:flutter/material.dart';

import 'package:call_recorder/Constants/colors.dart';
import 'package:call_recorder/locator.dart';
import 'package:call_recorder/utils/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:call_recorder/Screens/homePage.dart';
import 'package:call_recorder/Screens/signUpPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({Key? key}) : super(key: key);

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Forget Password'),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [goldenTextColor, appBarColor],
                  )),
            )),
        body: Padding(
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
                    fillColor: Colors.black,
                    focusColor: Colors.black,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelText: 'Email....',
                  ),
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                // ignore: deprecated_member_use
                child: RaisedButton(
                  onPressed: ()async{
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: nameController.text.trim());
                    } on FirebaseAuthException catch (e) {
                      EasyLoading.showError(e.toString());
                      return;
                    }

                    Navigator.pop(context);

                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Password Reset'),
                        content: Text('We have sent you password reset instructions on ${nameController.text}'),

                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Okay')
                          ),
                        ],
                      ),
                    );

                    try{
                      EasyLoading.show();
                      NotificationService notify= NotificationService();
                      notify.showNotifications('Password Reset','We have sent you password reset instructions on ${nameController.text}');
                      EasyLoading.dismiss();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                      nameController.clear();


                    } on FirebaseAuthException catch(e){
                      if (e.code == 'user-not-found') {
                        EasyLoading.showError('No user found for that email.');
                      }

                    }


                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [goldenTextColor, appBarColor],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Container(
                      constraints:
                      BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Forget Password",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
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




