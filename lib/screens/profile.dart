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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String uID="",sName="",sClass="",sSem="",sEnroll="",sEmail="",sSname="",sLab="",sMob="",sGR="";
  final User? user = FirebaseAuth.instance.currentUser;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }
  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("userID")!;
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
        sSname = data?['sname'];
        sEmail = data?['email'];
        sLab = data?['lab'];
        sMob = data?['mobile'];
        sSem = data!['sem'].toString();
        sEnroll = data?['enroll'];
        sGR = data?['gr'];
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: muColor, fontSize: getSize(context, 2.3))),
        iconTheme: IconThemeData(color: muColor,),
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [IconButton(onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15) ),
                title: Center(child: Row(
                  children: [
                    Image(image: AssetImage("assets/icon/icon.png"),width: 30),
                    SizedBox(width: getWidth(context, 0.05),),
                    Text('ICT-MU',style: TextStyle(fontFamily: "Main",fontWeight: FontWeight.bold)),
                  ],
                )),
                content: Text("Are you sure want to logout?",style: TextStyle(fontFamily: "Main"),),
                actions: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => Get.back(),
                            child: Text('NO'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              backgroundColor: Color(0xFF0098B5),
                            ),
                          ),
                          SizedBox(width: getWidth(context, 0.05),),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              backgroundColor: Color(0xFF0098B5),
                            ),
                            onPressed: () async {
                              await prefs.setBool("isLoginStd", false);
                              await prefs.setString("userID","");
                              Get.off(LoginPage(),curve: Curves.bounceInOut,duration: Duration(seconds: 1));
                            },
                            child: Text('YES'),
                          ),
                        ],
                      ),
                    ),
                  ),],
              ));
        }, icon: Icon(Icons.logout_rounded,color: muColor,))],
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
                      height: getHeight(context, 0.8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "Name   :   ", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black)),
                                      TextSpan(text: "$sName $sSname", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black,fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: getSize(context, 5),child: Divider(color: Colors.grey,thickness: 1)),
                              Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "Semester   :   ", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black)),
                                      TextSpan(text: "$sSem", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black,fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: getSize(context, 5),child: Divider(color: Colors.grey,thickness: 1)),
                              Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "Class   :   ", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black)),
                                      TextSpan(text: "$sClass ", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black,fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: getSize(context, 5),child: Divider(color: Colors.grey,thickness: 1)),
                              Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "Lab Batch   :   ", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black)),
                                      TextSpan(text: "$sLab", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black,fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: getSize(context, 5),child: Divider(color: Colors.grey,thickness: 1)),
                              Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "Enrollment   :   ", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black)),
                                      TextSpan(text: "$sEnroll", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black,fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: getSize(context, 5),child: Divider(color: Colors.grey,thickness: 1)),
                              Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "GR no.   :   ", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black)),
                                      TextSpan(text: "$sGR", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black,fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: getSize(context, 5),child: Divider(color: Colors.grey,thickness: 1)),
                              Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "Email   :   ", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black)),
                                      TextSpan(text: "$sEmail", style: TextStyle(fontSize: getSize(context, 2),fontFamily: "main",color: Colors.black,fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: getSize(context, 5),child: Divider(color: Colors.grey,thickness: 1)),
                              Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "Contact   :   ", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black)),
                                      TextSpan(text: "$sMob", style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",color: Colors.black,fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: getSize(context, 5),child: Divider(color: Colors.grey,thickness: 1)),
                              ElevatedButton(
                                  onPressed: (){},
                                  child: Center(child: Text("Update Password")),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(200,20),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(getSize(context, 1.5))),
                                backgroundColor:muColor),),
                            ],
                          ),


                      ),
                    ),
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
