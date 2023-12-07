import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ict/helpers/size.dart';
import 'package:ict/screens/my_experiance.dart';

import '../helpers/contents.dart';
import 'addExperiance.dart';

class InterviewDeskPage extends StatefulWidget {
  const InterviewDeskPage({Key? key}) : super(key: key);

  @override
  _InterviewDeskPageState createState() => _InterviewDeskPageState();
}

class _InterviewDeskPageState extends State<InterviewDeskPage> {
  final _firestore = FirebaseFirestore.instance;
  final transformationController = TransformationController();
  String _searchQuery = "";

  // Leave applications list
  final _leaveApplications = <Interview>[].obs;

  @override
  void initState() {
    super.initState();
    _fetchLeaveApplications();
  }

  void _fetchLeaveApplications() async {
    final leaveStream = _firestore.collection('interview').snapshots();
    leaveStream.listen((snapshot) {
      _leaveApplications.clear();
      for (var doc in snapshot.docs) {
        final application = Interview.fromFirestore(doc);
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: (){Get.to(AddExperiance());},
                  child: Text("Add Experiance",style: TextStyle(fontFamily: "Main",color: Colors.white,fontSize:getSize(context, 2),fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    backgroundColor: muColor,
                  ),
                ),
                ElevatedButton(
                  onPressed: (){Get.to(MyExperiance());},
                  child: Text("My Experiance",style: TextStyle(fontFamily: "Main",color: Colors.white,fontSize:getSize(context, 2),fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    backgroundColor: muColor,
                  ),
                ),
              ],),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                decoration: InputDecoration(hintText: 'Search by Student Name/Company Name'),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('interview').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      itemCount: _leaveApplications.length,
                      itemBuilder: (context, index) {
                        final intView = _leaveApplications[index];
                        if (!intView.studentName.toLowerCase().contains(_searchQuery.toLowerCase())&&
                            !intView.company.toLowerCase().contains(_searchQuery.toLowerCase())) {
                          return SizedBox.shrink();
                        }
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
          ],
        ),
      ),
    );
  }
}

class Interview {
  final String id;
  final String studentID;
  final String studentName;
  final String company;
  final String experiance;
  final String date;

  Interview.fromFirestore(DocumentSnapshot doc)
      : id = doc.id,
        studentID = doc['studentID'],
        studentName = doc['studentName'],
        company = doc['company'],
        experiance = doc['experiance'],
        date = doc['date'];

}

