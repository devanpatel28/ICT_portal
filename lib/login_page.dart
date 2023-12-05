import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ict/screens/faculty_screen.dart';
import 'package:ict/screens/hod_screen.dart';
import 'package:ict/screens/student_screen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();


  double brRad = 15;
  String email="",password="";
  bool isVisible = true;
      //Border radious
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: AnimatedTextKit(animatedTexts: [
                TypewriterAnimatedText(
                  "Welcome to ICT", speed: Duration(milliseconds:100),
                  textStyle: TextStyle(
                    fontFamily: "Main",
                    fontWeight:FontWeight.bold,
                    color: Color(0xFF0098B5),
                    fontSize: 30,
                  ),

                ),
              ],
                repeatForever:true,
              )

            ),
            SizedBox(height: 50,),
            Container(
              height: MediaQuery.sizeOf(context).height * 0.06,
              width: MediaQuery.sizeOf(context).width * 0.85,
              child: TextField(
                onChanged: (value){
                  email=value;
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0098B5), width: 2.0),
                    borderRadius: BorderRadius.circular(brRad),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0098B5), width: 2.0),
                    borderRadius: BorderRadius.circular(brRad),
                  ),
                  prefixIcon: Icon(
                    Icons.mail,color: Color(0xFF0098B5),
                  ),
              ),
                style: TextStyle(fontSize: 15,fontFamily: "Main",fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: MediaQuery.sizeOf(context).height * 0.06,
              width: MediaQuery.sizeOf(context).width * 0.85,
              child: TextField(
                onChanged: (value){
                  password=value;
                },
                obscureText: isVisible,
                decoration: InputDecoration(
                  hintText: 'Password',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0098B5), width: 2.0),
                    borderRadius: BorderRadius.circular(brRad),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0098B5), width: 2.0),
                    borderRadius: BorderRadius.circular(brRad),
                  ),
                  prefixIcon: Icon(
                    Icons.lock,color: Color(0xFF0098B5),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      isVisible = !isVisible;
                      setState((){});
                    },
                    child: Icon(isVisible? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: Color(0xFF0098B5),
                      size: 20,
                    ),
                  ),
                ),
                style: TextStyle(fontSize: 15,fontFamily: "Main",fontWeight: FontWeight.w500),
              ),
            ),

            SizedBox(height: 35,),

            Container(
              width: MediaQuery.sizeOf(context).width * 0.85,
                height: MediaQuery.sizeOf(context).height * 0.06,
                child: RoundedLoadingButton(
                controller: _btnController,
                  onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email.trim(),
                        password: password.trim()
                    );
                        User? user = FirebaseAuth.instance.currentUser;
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(user!.uid)
                            .get()
                            .then((DocumentSnapshot ds)
                            async {
                              if (ds.get('rool') == 'student')
                                {
                                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                  await prefs.setBool("isLoginStd", true);
                                  _btnController.success();
                                  Get.off(StudentScreen(),curve: Curves.bounceInOut,duration: Duration(seconds: 1));
                                  Timer(Duration(seconds: 2), () {
                                    _btnController.reset();
                                  });
                                }
                              else if (ds.get('rool') == 'hod')
                              {
                                final SharedPreferences prefs = await SharedPreferences.getInstance();
                                await prefs.setBool("isLoginHod", true);
                                _btnController.success();
                                Get.off(HodScreen(),curve: Curves.bounceInOut,duration: Duration(seconds: 1));
                                Timer(Duration(seconds: 2), () {
                                  _btnController.reset();
                                });
                              }
                              else if (ds.get('rool') == 'faculty')
                              {
                                final SharedPreferences prefs = await SharedPreferences.getInstance();
                                await prefs.setBool("isLoginFac", true);
                                _btnController.success();
                                Get.off(FacultyScreen(),curve: Curves.bounceInOut,duration: Duration(seconds: 1));
                                Timer(Duration(seconds: 2), () {
                                  _btnController.reset();
                                });
                              }
                            });
                  } on FirebaseAuthException catch (e) {

                    if (e.code == 'user-not-found') {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                            title: Icon(Icons.cancel,color: Colors.red,size: 40),
                            content: Text('User Not Found ',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 20)),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                      );
                      // print('No user found for that email.');
                    }
                    else if (e.code == 'wrong-password') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                          title: Icon(Icons.key_off_rounded,color: Colors.red,size: 40),
                          content: Text('Wrong Password',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 20)),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      // print('Wrong password provided for that user.');
                    }
                    _btnController.error();
                      Timer(Duration(seconds: 1), () {
                        _btnController.reset();
                      });
                    };
                },
                    child: Text("LOGIN",style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Main",
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                  color: Color(0xFF0098B5),
                  borderRadius: brRad,
                  successColor: Colors.green,
                ),
            ),
          ],
        ),
      ),
    );
  }
}
class PageTransition extends PageRouteBuilder {
  final Widget page;

  PageTransition(this.page) : super(
    pageBuilder: (context, animation, anotherAnimation) => page,
    transitionDuration: Duration(seconds: 3),
    reverseTransitionDuration: Duration(seconds: 2),
    transitionsBuilder: (context, animation, anotherAnimation, child) {
      animation = CurvedAnimation(
          curve: Curves.fastLinearToSlowEaseIn,
          parent: animation,
          reverseCurve: Curves.fastOutSlowIn);
      return Align(
        alignment: Alignment.center,
        child: SizeTransition(
          axis: Axis.horizontal,
          sizeFactor: animation,
          child: page,
          axisAlignment: 0,
        ),
      );
    },
  );
}