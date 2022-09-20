// import 'package:bootstrap_academy/resources/constant/app_colors.dart';
// import 'package:bootstrap_academy/screens/auth_screens/forget_Screen.dart';
// import 'package:bootstrap_academy/widgets/buttons.dart';
// import 'package:bootstrap_academy/widgets/curved_container.dart';
// import 'package:bootstrap_academy/widgets/custom_appbar.dart';
// import 'package:bootstrap_academy/widgets/span_text.dart';
// import 'package:bootstrap_academy/widgets/textfields.dart';
// import 'package:bootstrap_academy/widgets/textfields_lable.dart';
import 'package:call_recorder/Screens/auth_screens/signup.dart';
import 'package:call_recorder/Screens/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Constants/colors.dart';
import '../../utils/flush_bar.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/curved_container.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/span_text.dart';
import '../../widgets/text_field_widget.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Log in'),
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppbar(
              text: 'Log in',
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Stack(
                children: [
                  CurvedContainer(
                    height: size.height * 0.6,
                    contaienerColor: AppColors.containerColorLight,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: CurvedContainer(
                      height: size.height * 0.6,
                      contaienerColor: AppColors.containerColorDark,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: CurvedContainer(
                      height: size.height * 0.7,
                      contaienerColor: AppColors.secondaryColor,
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 190, left: 30, right: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextfieldsLableText(label: "Enter your Email"),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFields.emailTextField(
                              context,
                              validaterMsg: "email required",
                              controller: emailController,
                              hintText: "Email"),
                          const SizedBox(
                            height: 20,
                          ),
                          TextfieldsLableText(label: "Enter your Password"),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFields.passwordTextField(context,
                              validaterMsg:
                              "password must be 6 characters or greater",
                              controller: passwordController,
                              hintText: "password"),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //         const ForgetScreen()),);
                                },
                                child: const Text(
                                  "Forget password?",
                                  style: TextStyle(
                                      fontFamily: "JetBrainsMono",
                                      color: AppColors.headingColor),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Buttons(
                                onTap: () async{
                                  // if (_formKey.currentState!.validate()) {
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     const SnackBar(
                                  //         content: Text('Successfull  login')),
                                  //   );
                                  // } else {
                                  //   return "somthing went wrong";
                                  // }
                                  /// Email
                                  try{
                                    /// Email
                                   if(emailController.text.trim().isEmpty){
                                      // Utils.flutterToastMessage('Email is required');
                                      Utils.flushBarErrorWidget(context, 'Email is required');
                                    }
                                    else if (passwordController.text.trim().isEmpty){
                                      Utils.flushBarErrorWidget(context, 'Password is required');
                                    }
                                    else if(passwordController.text.trim().length < 6){
                                      Utils.flushBarErrorWidget(context, 'password length must be greater then 6');
                                    }
                                    else{
                                      // loading = true;
                                      final  userCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(
                                          email: emailController.text,
                                          password: passwordController.text);
                                      print('user credentials: ${userCredential.user!.email}');

                                      Utils.snackBarWidget(context, 'Logged In Successfully');
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                                      /// clear all controller
                                      emailController.clear();
                                      passwordController.clear();

                                      // setState(() async {
                                      // });
                                      //   loading = false;

                                    }
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'user-not-found') {
                                      Utils.flushBarErrorWidget(context, 'No user found for that email.');

                                    } else if (e.code == 'wrong-password') {
                                      Utils.flushBarErrorWidget(context, 'Wrong password provided for that user.');
                                    }
                                  }
                                },
                                buttonText: "Login",
                                height: 40,
                                width: 150,
                                backgroundColor: AppColors.buttonColor),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                         Row(children:  [
                           Text("Don't have an account?",
                             style:  TextStyle(
                                 color: AppColors.headingColor,
                                 wordSpacing: 2,
                                 fontSize: 17,
                                 fontFamily: "JetBrainsMono"),),
                           SizedBox(width: 10,),
                           GestureDetector(
                             onTap: (){
                               Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                             },
                             child: const Text( "Create one",
                               style:  TextStyle(
                                   fontWeight: FontWeight.bold,
                                   fontFamily: "JetBrainsMono",
                                   color: AppColors.buttonColor,
                                   wordSpacing: 2,
                                   fontSize: 17),),
                           ),
                         ],),


                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}