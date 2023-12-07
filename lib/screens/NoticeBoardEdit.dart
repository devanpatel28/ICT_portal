import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ict/helpers/size.dart';
import 'package:ict/screens/notice_add.dart';

import '../helpers/contents.dart';

class NoticeBoardEdit extends StatefulWidget {
  const NoticeBoardEdit({Key? key}) : super(key: key);

  @override
  _NoticeBoardEditState createState() => _NoticeBoardEditState();
}

class _NoticeBoardEditState extends State<NoticeBoardEdit> {
  final _firestore = FirebaseFirestore.instance;
  final transformationController = TransformationController();
  String _searchQuery = "";

  // Leave applications list
  final _NoticeApplication = <UserModel>[].obs;

  @override
  void initState() {
    super.initState();
    _fetchLeaveApplications();
  }

  void _fetchLeaveApplications() async {
    final leaveStream = _firestore.collection('noticeboard').snapshots();

    leaveStream.listen((snapshot) {
      _NoticeApplication.clear();
      for (var doc in snapshot.docs) {
        final application = UserModel.fromFirestore(doc);
        _NoticeApplication.insert(0, application);

      }
    });
  }
  void _zoomImage(String attachmentID) async {
    // Show a dialog or overlay with a larger version of the image
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: InteractiveViewer(
            onInteractionEnd: (interaction) {
              transformationController.value = Matrix4.identity();
            },
            child:ClipRRect(
              borderRadius: BorderRadius.circular(15.0), // Adjust as desired
              child: Image(
                image: NetworkImage(attachmentID),
              ),
            )
        ),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text("Noticeboard"),centerTitle: true,backgroundColor: muColor),
      floatingActionButton: FloatingActionButton(onPressed: (){Get.to(AddNotice());},child: Icon(Icons.add)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('leave').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      itemCount: _NoticeApplication.length,
                      itemBuilder: (context, index) {
                        final leave = _NoticeApplication[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 3),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ListTile(
                                title: Text(leave.sname,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontFamily: "main")),
                                subtitle: Column(
                                  children: [
                                    leave.attachID.isNotEmpty?
                                    GestureDetector(
                                        onTap: () => _zoomImage(leave.attachID), // Define _zoomImage function below
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0), // Adjust as desired
                                          child: Image(
                                            image: NetworkImage(leave.attachID),
                                          ),
                                        )
                                    )
                                        :SizedBox(),

                                    SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(leave.body, style: TextStyle(color: Colors.blueGrey ,fontSize: getSize(context, 2.1)),),
                                    ),
                                    SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        leave.date,
                                        style: TextStyle(color: muColor, fontFamily: "main"),
                                      ),
                                    ),
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

class UserModel {
  final String id;
  final String sname;
  final String body;
  final String date;
  final String attachID;

  UserModel.fromFirestore(DocumentSnapshot doc)
      : id = doc.id,
        sname = doc['sname'],
        body = doc['body'],
        date = doc['datetime'],
        attachID = doc['attachmentID'];
}

