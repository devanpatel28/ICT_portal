import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ict/helpers/contents.dart';
import 'package:ict/screens/leave_applicaion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../firebase/firebase_operation.dart';
import '../helpers/size.dart';
import '../login_page.dart';
class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  Stream<QuerySnapshot> collection = FirebaseOperations.fetchTransactions();
  @override
  late int sEnroll,sSem;
  late String sName,sClass;

  final User? user = FirebaseAuth.instance.currentUser;
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard",style: TextStyle(color: muColor,fontSize: getSize(context,2.3))),
        elevation:1,
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){},icon: Icon(Icons.person,color: muColor),)
        ],
      ),

      body: SafeArea(
        child: StreamBuilder(
          stream: collection,
          builder: (context, Snapshot)
          {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: getWidth(context, 0.9),
                      height: getHeight(context,0.1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Hello, Devan"),
                              Text("SEM 5 TK1"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: getHeight(context, 0.05),),
                    Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          getMainIcon(context, IconButton(onPressed: (){Get.to(LeaveApplication());},
                              icon: FaIcon(FontAwesomeIcons.notesMedical,size: getSize(context, 5),color: muColor,))," Apply Leave"),
                          getMainIcon(context, IconButton(onPressed: (){Get.to(LeaveApplication());},
                              icon: FaIcon(FontAwesomeIcons.idCard,size: getSize(context, 5),color: muColor,)),"Profile"),
                          getMainIcon(context, IconButton(onPressed: (){Get.to(LeaveApplication());},
                              icon: Icon(Icons.calendar_month_outlined,size: getSize(context, 6),color: muColor,)),"Timetable"),
                        ],
                      ),
                      SizedBox(height: getHeight(context, 0.03),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          getMainIcon(context, IconButton(onPressed: (){Get.to(LeaveApplication());},
                              icon: Icon(Icons.developer_board_outlined,size: getSize(context, 6),color: muColor,)),"Notice Board"),
                          getMainIcon(context, IconButton(onPressed: (){Get.to(LeaveApplication());},
                              icon: Icon(Icons.quiz_outlined,size: getSize(context, 6),color: muColor,)),"Quiz"),
                          getMainIcon(context, IconButton(onPressed: (){Get.to(LeaveApplication());},
                              icon: Icon(Icons.fact_check_outlined,size: getSize(context, 6),color: muColor,)),"Attendance"),
                        ],
                      ),
                    ],)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
