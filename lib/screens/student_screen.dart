import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ict/helpers/contents.dart';
import 'package:ict/screens/interview_desk.dart';
import 'package:ict/screens/leave_applicaion.dart';
import 'package:ict/screens/notice_board.dart';
import 'package:ict/screens/question.dart';
import 'package:ict/screens/student_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../firebase/firebase_operation.dart';
import '../helpers/size.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
   String uID="",sName="",sClass="",sSem="",sEnroll="",profileImageUrl = "";
  final User? user = FirebaseAuth.instance.currentUser;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    setState(() {});
    initSharedPrefs();
  }
   String _getGreeting() {
     final now = DateTime.now();
     final hour = now.hour;

     if (hour < 12) {
       return "Good Morning !";
     } else if (hour < 17) {
       return "Good Afternoon !";
     } else if (hour < 21) {
       return "Good Evening !";
     } else {
       return "Good Night !";
     }
   }

   void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userID")||prefs.getString("userID")!.isEmpty) {
      uID = user!.uid;
      await prefs.setString("userID", uID);
    }
    else {
      uID = prefs.getString("userID")!;
    }
    getUserData();
  }

  void getUserData() async {
    final docRef = FirebaseFirestore.instance.collection('user').doc(uID);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      final Map<String, dynamic>? data = docSnapshot.data();
      setState(() {
        sName = data?['name'];
        sClass = data?['class'];
        sSem = data!['sem'].toString();
        sEnroll = data?['enroll'];
        profileImageUrl = data?['profileImageUrl'];
      });
    }
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
        final result = await Get.dialog(
            AlertDialog(
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15) ),
              title: Center(child: Row(
                children: [
                  Image(image: AssetImage("assets/icon/icon.png"),width: 35),
                  SizedBox(width: getWidth(context, 0.05),),
                  Text('Leave app',style: TextStyle(fontFamily: "Main",fontSize:getSize(context, 2.5),fontWeight: FontWeight.bold)),
                ],
              )),
              content: Text("Are you sure want to leave?",style: TextStyle(fontFamily: "Main"),),
              actions: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => Get.back(),
                          child: Text('NO',style: TextStyle(fontFamily: "Main",color: Colors.white,fontSize:getSize(context, 2),fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            backgroundColor: muColor,
                          ),
                        ),
                        SizedBox(width: getWidth(context, 0.05),),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            backgroundColor: muColor,
                          ),
                          onPressed: () =>Get.off(SystemNavigator.pop(),curve: Curves.elasticOut,duration: Duration(seconds: 2)),
                          child: Text('YES',style: TextStyle(fontFamily: "Main",color: Colors.white,fontSize:getSize(context, 2),fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),],
            )
        );
        // Return true if user confirms leaving, false otherwise
        return result;
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text("Dashboard", style: TextStyle(color: muColor, fontSize: getSize(context, 2.3))),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[300],
                ),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl)
                      : null,
                  child: profileImageUrl.isEmpty
                      ? Icon(
                    Icons.person,
                    size: 40,
                    color: muColor,
                  ) : null,
                ),
              ],
            )
          ),
        ],
        elevation: 1,
        backgroundColor: Colors.white,

      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseOperations.fetchTransactions(),
          builder: (context, Snapshot) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: getWidth(context, 0.9),
                      height: getHeight(context, 0.06),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "Hello, ", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black)),
                                  TextSpan(text: "$sName", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: muColor,fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Text(_getGreeting(),style: TextStyle(fontFamily: "main",color: muColor,fontStyle: FontStyle.italic),
                            ),
                          ],
                        )

                      ),
                    ),
                    SizedBox(height: getHeight(context, 0.05)),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            getMainIcon(
                              context,
                              IconButton(
                                onPressed: () {
                                  Get.to(LeaveApplication());
                                },
                                icon: FaIcon(FontAwesomeIcons.notesMedical,
                                    size: getSize(context, 5), color: muColor),
                              ),
                              "Apply Leave",
                            ),
                            getMainIcon(
                              context,
                              IconButton(
                                onPressed: () {
                                  Get.to(ProfilePage());
                                },
                                icon: FaIcon(FontAwesomeIcons.idCard,
                                    size: getSize(context, 5), color: muColor),
                              ),"Profile",
                            ),
                            getMainIcon(
                              context,
                              IconButton(
                                onPressed: () {
                                  Get.to(NoticeBoard());
                                },
                                icon: Icon(Icons.developer_board_outlined,
                                    size: getSize(context, 6), color: muColor),
                              ),
                              "Notice Board",
                            ),
                          ],
                        ),
                        SizedBox(height: getHeight(context, 0.03)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            getMainIcon(
                                context,
                                IconButton(
                                  onPressed: () {
                                    Get.to(QuizPage());
                                  },
                                  icon: Icon(Icons.quiz_outlined,
                                      size: getSize(context, 6),
                                      color: muColor),
                                ),
                                "Questions\n     Bank"),
                            getMainIcon(
                              context,
                              IconButton(
                                onPressed: () {
                                  Get.to(InterviewDeskPage());
                                },
                                icon: Icon(Icons.fact_check_outlined,
                                    size: getSize(context, 6), color: muColor),
                              ),
                              "Interview\n    Desk",
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
    );
  }
}
