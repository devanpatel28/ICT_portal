import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ict/helpers/size.dart';

import '../helpers/contents.dart';
import 'addExperiance.dart';

class MyExperiance extends StatefulWidget {
  const MyExperiance({Key? key}) : super(key: key);

  @override
  _MyExperianceState createState() => _MyExperianceState();
}

class _MyExperianceState extends State<MyExperiance> {
  final _firestore = FirebaseFirestore.instance;
  final transformationController = TransformationController();
  String _searchQuery = "";
  final User? user = FirebaseAuth.instance.currentUser;

  // Leave applications list
  final _leaveApplications = <MyInterview>[].obs;

  @override
  void initState() {
    super.initState();
    _fetchLeaveApplications();
  }

  void _fetchLeaveApplications() async {
    final leaveStream = _firestore.collection('interview').where('studentID', isEqualTo: user?.uid).snapshots();
    leaveStream.listen((snapshot) {
      _leaveApplications.clear();
      for (var doc in snapshot.docs) {
        final application = MyInterview.fromFirestore(doc);
        _leaveApplications.insert(0, application);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text("Interview Desk"),centerTitle: true,backgroundColor: muColor),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('interview').where('studentID', isEqualTo: user?.uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: _leaveApplications.length,
                itemBuilder: (context, index) {
                  final intView = _leaveApplications[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 3),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          title: Text(intView.studentName,style: TextStyle(color: Colors.black, fontFamily: "main")),
                          subtitle: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  intView.date,
                                  style: TextStyle(color: muColor, fontFamily: "main"),
                                ),
                              ),
                              SizedBox(height: 10,child: Divider(thickness: 1,color: Colors.grey,)),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: RichText(
                                    text: TextSpan(
                                        children: [
                                          TextSpan(text: "Company : ", style: TextStyle(fontFamily:"main",fontWeight:FontWeight.bold,color: Colors.black,fontSize: getSize(context, 2.2)),),
                                          TextSpan(text: intView.company, style: TextStyle(color: muColor,fontSize: getSize(context, 2.1)),),
                                        ]
                                    ),
                                  )
                              ),
                              SizedBox(height: 10),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: RichText(
                                    text: TextSpan(
                                        children: [
                                          TextSpan(text: "Experiance : ", style: TextStyle(fontFamily:"main",fontWeight:FontWeight.bold,color: Colors.black,fontSize: getSize(context, 2.2)),),
                                          TextSpan(text: intView.experiance, style: TextStyle(fontFamily:"main",color: Colors.blueGrey ,fontSize: getSize(context, 2.2)),),
                                        ]
                                    ),
                                  )
                              ),
                              SizedBox(height: 10),

                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },);}
        ),
      ),
    );
  }
}

class MyInterview {
  final String id;
  final String studentID;
  final String studentName;
  final String company;
  final String experiance;
  final String date;

  MyInterview.fromFirestore(DocumentSnapshot doc)
      : id = doc.id,
        studentID = doc['studentID'],
        studentName = doc['studentName'],
        company = doc['company'],
        experiance = doc['experiance'],
        date = doc['date'];

}

