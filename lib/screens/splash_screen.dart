import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ict/login_page.dart';
import 'package:ict/screens/faculty_screen.dart';
import 'package:ict/screens/student_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 1500),() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoginStd = await prefs.getBool('isLoginStd')??false;
      bool isLoginHod = await prefs.getBool('isLoginHod')??false;
      bool isLoginFac = await prefs.getBool('isLoginFac')??false;

      if(isLoginStd)
      {
        Get.off(StudentScreen(),duration: Duration(seconds: 2),curve: Curves.easeInOut);
      }
      else if(isLoginFac)
        {
          Get.off(FacultyScreen(),duration: Duration(seconds: 2),curve: Curves.easeInOut);
        }
      else
        {
          Get.off(LoginPage(),duration: Duration(seconds: 2),curve: Curves.easeInOut);
        }

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarGlow(
              glowColor: Color(0xFF0098B5),
              endRadius: 150,
              duration: Duration(milliseconds: 1500),
              repeat: true,
              curve: Curves.easeOutQuart,
              showTwoGlows: true,
              shape: BoxShape.circle,
              repeatPauseDuration: Duration(milliseconds: 10),
              child: Image.asset(
                'assets/icon/icon.png',
                height: 120
              ),
            ),

          ],
        ),
      ),
    );
  }
}