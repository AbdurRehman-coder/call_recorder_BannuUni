
import 'package:call_recorder/Screens/auth_screens/login.dart';
import 'package:call_recorder/Screens/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Constants/colors.dart';
import '../../utils/flush_bar.dart';
import '../../utils/notification.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/curved_container.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/span_text.dart';
import '../../widgets/text_field_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    print('loading value: $loading');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          //height: size.height * 1.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const  CustomAppbar(
                text: 'Sign up',
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CurvedContainer(
                          height: size.height * 1.07,
                          contaienerColor: AppColors.secondaryColor),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 100, left: 30, right: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: Main,
                          children: [
                            TextfieldsLableText(label: "Enter Fullname "),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFields.normalTextField(context,
                                validationmessage: "fullname can't be empty",
                                hintText: "FullName",
                            controller: nameController),
                            const SizedBox(
                              height: 20,
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            TextfieldsLableText(label: "Enter Email"),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFields.emailTextField(context,
                                validaterMsg: "please check your email",
                                controller: emailController,
                                hintText: "Email"),
                            const SizedBox(
                              height: 20,
                            ),
                            TextfieldsLableText(label: "Enter Password"),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFields.passwordTextField(context,
                                validaterMsg: "please check your password",
                                controller: passwordController,
                                hintText: "password"),
                            TextfieldsLableText(label: "Confirm Password"),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFields.passwordTextField(context,
                                validaterMsg: "please confirm your password",
                                controller: confirmPasswordController,
                                hintText: "confirm password"),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    value: true,
                                    activeColor: AppColors.buttonColor,
                                    onChanged: (value) {}),
                                Expanded(
                                  child: SpanText(
                                    firsttext: "I agree to the ",
                                    secondtext: "terms and conditions",
                                    onClicked: () {},
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Buttons(
                                  onTap: () async{
                                    // if (_formKey.currentState!.validate()) {
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(
                                    //     const SnackBar(
                                    //         content:
                                    //         Text('Successfuly  Signup')),
                                    //   );
                                    // } else {
                                    //   return "please validate the form ";
                                    // }
                                    try{
                                    /// Email
                                    if(nameController.text.trim().isEmpty){
                                      // Utils.flutterToastMessage('Email is required');
                                      Utils.flushBarErrorWidget(context, 'Name is required');
                                    } else if(emailController.text.trim().isEmpty){
                                      // Utils.flutterToastMessage('Email is required');
                                      Utils.flushBarErrorWidget(context, 'Email is required');
                                    }
                                    else if (passwordController.text.trim().isEmpty){
                                      Utils.flushBarErrorWidget(context, 'Password is required');
                                    } else if (confirmPasswordController.text.trim().isEmpty){
                                      Utils.flushBarErrorWidget(context, 'Confirm Password is required');
                                    }
                                    else if(passwordController.text.trim().length < 6 && confirmPasswordController.text.trim().length < 6){
                                      Utils.flushBarErrorWidget(context, 'password length must be greater then 6');
                                    } else if(passwordController.text.trim().length != confirmPasswordController.text.trim().length ){
                                      Utils.flushBarErrorWidget(context, 'Confirm password should be same to Above one');
                                    }
                                    else{
                                      setState(()  {
                                        loading = true;
                                      });

                                        final  userCredential= await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                            email: emailController.text,
                                            password: passwordController.text);
                                        print('user credentials: ${userCredential.user!.email}');
                                        ///For Notifications
                                      NotificationService notify= NotificationService();
                                      notify.showNotifications('Welcome to I-Droid','Signup Successfully');

                                        Utils.snackBarWidget(context, 'Registered Successfully, Please Log in');
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen()));
                                        /// clear all controller
                                        nameController.clear();
                                        emailController.clear();
                                        passwordController.clear();
                                        confirmPasswordController.clear();
                                      setState(() {
                                      });
                                        loading = false;
                                    }
                                    } on FirebaseAuthException catch (e){
                                      loading = false;
                                      if (e.code == 'weak-password') {
                                        Utils.flushBarErrorWidget(context, 'The password provided is too weak.');
                                      } else if (e.code == 'email-already-in-use') {
                                        Utils.flushBarErrorWidget(context, 'The account already exists for that email.');
                                      }
                                      setState(() {

                                      });
                                    }
                                  },
                                  buttonText: "Signup",
                                  height: 40,
                                  width: 150,
                                  loading: loading,
                                  backgroundColor: AppColors.buttonColor),
                            ),
                            SizedBox(height: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                              const Text("Already have an account?",
                                style:  TextStyle(
                                    color: AppColors.headingColor,
                                    wordSpacing: 2,
                                    fontSize: 17,
                                    fontFamily: "JetBrainsMono"),),
                              SizedBox(width: 10,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen()));
                                },
                                child: const Text( "Go to Login",
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
      ),
    );
  }
}