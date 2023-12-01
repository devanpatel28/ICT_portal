import 'package:flutter/material.dart';

class LeaveApplication extends StatefulWidget {
  const LeaveApplication({super.key});

  @override
  State<LeaveApplication> createState() => _LeaveApplicationState();
}

class _LeaveApplicationState extends State<LeaveApplication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leave Application"),
      ),
    );
  }
}
