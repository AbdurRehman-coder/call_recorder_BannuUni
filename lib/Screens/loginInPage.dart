import 'package:call_recorder/Constants/colors.dart';
import 'package:call_recorder/Screens/forget_password/forget_password_Screen.dart';
import 'package:call_recorder/locator.dart';
import 'package:call_recorder/utils/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:call_recorder/Screens/homePage.dart';
import 'package:call_recorder/Screens/signUpPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Login'),
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
                      fillColor: Colors.black,
                      focusColor: Colors.black,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Username/Mobile No.',
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
                SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          //textColor: Colors.blue,
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),

                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgetScreen()),
                            );
                          },
                        ),
                      ],
                    )),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  // ignore: deprecated_member_use
                  child: ElevatedButton(
                    onPressed: ()async{


                      try{
                        EasyLoading.show();

                        final  userCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(email: nameController.text,password: passwordController.text) ;

                        final userName=userCredential.user?.email;
                        if(userName != null){
                          final localUserData= await userRepository.get(userName);
                          if (localUserData == null) {
                            EasyLoading.showError("No User Found");
                          }else{
                            NotificationService notify= NotificationService();
                            notify.showNotifications('Wellcome ${nameController.text} ','You Login Successfully in I-Droid App ');
                            await storage.setUser(localUserData);
                            EasyLoading.dismiss();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );
                            nameController.clear();
                            passwordController.clear();
                          }

                        }else {
                          EasyLoading.dismiss();
                          EasyLoading.showError('No user found for that email.');
                        }
                      } on FirebaseAuthException catch(e){
                        if (e.code == 'user-not-found') {
                          EasyLoading.showError('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          EasyLoading.showError('Wrong password provided for that user.');
                        }

                      }

                      // if(localUserData?.name == nameController.text && localUserData?.password == passwordController.text.trim() ){
                      //   await storage.setId(nameController.text);
                      //
                      //
                      //
                      // }else {
                      //   EasyLoading.showError("Incorrect Data Entered");
                      // }

                    },

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
                          "Sign in",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  // ignore: deprecated_member_use
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },

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
                          "Sign up",
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
      ),
    );
  }

}