import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ict/pages/faculty_screen.dart';
import 'package:ict/pages/hod_screen.dart';
import 'package:ict/pages/student_screen.dart';
import 'login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'login': (context) => LoginPage(),
        'student': (context) => StudentScreen(),
        'hod': (context) => HodScreen(),
        'faculty': (context) => FacultyScreen(),

      },
      initialRoute: 'login',
    );
  }
}
