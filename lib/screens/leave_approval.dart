
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ict/helpers/size.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import '../helpers/contents.dart';

class LeaveApprovalPage extends StatefulWidget {
  const LeaveApprovalPage({Key? key}) : super(key: key);

  @override
  _LeaveApprovalPageState createState() => _LeaveApprovalPageState();
}

class _LeaveApprovalPageState extends State<LeaveApprovalPage> {
  final _firestore = FirebaseFirestore.instance;
  final transformationController = TransformationController();
  String _searchQuery = "";

  // Leave applications list
  final _leaveApplications = <LeaveApplication>[].obs;

  @override
  void initState() {
    super.initState();
    _fetchLeaveApplications();
  }
  Future<void> sendEmail(String studentName,String body,String email,String Des) async {
    String username = 'devan.patel.ict@gmail.com'; // Your Gmail address
    String password = 'yoje lden hssm gybo'; // Your Gmail password
    String colorStyle = (Des == "APPROVED") ? "color: green;" : "color: red;";
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'ICT-MU') // Your name
      ..recipients.add(email) // Recipient's email address
      ..subject = 'Leave Approval'
      ..html = '''
      <h3><p>Hello, $studentName</p>
      <p>Your Leave:</p>
      <p><strong>$body</strong></p>
      <p style="$colorStyle">$Des</p></h3>
    ''';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } catch (error) {
      print('Error sending email: $error');
    }
  }
  void _fetchLeaveApplications() async {
    final leaveStream = _firestore.collection('leave').snapshots();

    leaveStream.listen((snapshot) {
      _leaveApplications.clear();
      for (var doc in snapshot.docs) {
        final application = LeaveApplication.fromFirestore(doc);
        if (application.status == "pending") {
          _leaveApplications.insert(_leaveApplications.length-1, application);
        } else if (application.status == "approve") {
          _leaveApplications.insert(_leaveApplications.length,application);
        } else {
          _leaveApplications.addAll([application]);
        }
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
  void _onApproveClick(LeaveApplication leave) async {
    await _firestore.collection('leave').doc(leave.id).update({'status': 'approve'});
    _fetchLeaveApplications();
    sendEmail(leave.studentName,leave.body,leave.studentEmail,"APPROVED");
  }

  void _onDeclineClick(LeaveApplication leave) async {
    await _firestore.collection('leave').doc(leave.id).update({'status': 'decline'});
    _fetchLeaveApplications();
    sendEmail(leave.studentName,leave.body,leave.studentEmail,"DECLINE");
  }
  void _showStudentNamePopup(LeaveApplication leave) {
    showDialog(
      context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15) ),
          title: Text("Leave Response",),
          content: RichText(
            text: TextSpan(
                children: [
                  TextSpan(text: "Student Name : ", style: TextStyle(fontFamily:"main",fontWeight:FontWeight.bold,color: Colors.black,fontSize: getSize(context, 2.2)),),
                  TextSpan(text: leave.studentName, style: TextStyle(fontFamily:"main",color: muColor ,fontSize: getSize(context, 2.2)),),
                ]
            ),
          ),
          actions: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (leave.status == "pending"||leave.status == "decline")
                          ElevatedButton(
                              onPressed: () {_onApproveClick(leave);Get.back();},
                              child: Text('Approve' ,style: TextStyle(fontFamily:"main",color: Colors.white ,fontSize: getSize(context, 1.8)),),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  backgroundColor: Colors.green)
                          ),
                        SizedBox(width: 5),
                        if (leave.status == "pending"||leave.status == "approve")
                          ElevatedButton(
                            onPressed: () { _onDeclineClick(leave);Get.back();},
                            child: Text('Decline' ,style: TextStyle(fontFamily:"main",color: Colors.white ,fontSize: getSize(context, 1.8)),),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                backgroundColor: Colors.redAccent),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),],
        ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text("Leave Approvals"),centerTitle: true,backgroundColor: muColor),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                decoration: InputDecoration(hintText: 'Search Student Name'),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('leave').snapshots(),
                builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                  itemCount: _leaveApplications.length,
                  itemBuilder: (context, index) {
                    final leave = _leaveApplications[index];
                    if (!leave.studentName.toLowerCase().contains(_searchQuery.toLowerCase())) {
                      return SizedBox.shrink(); // Hide student if not matching
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 3),
                      child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(
                            onTap: () => _showStudentNamePopup(leave),
                            title: Text(leave.studentName,style: TextStyle(color: Colors.black, fontFamily: "main")),
                            subtitle: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    leave.date,
                                    style: TextStyle(color: muColor, fontFamily: "main"),
                                  ),
                                ),
                                SizedBox(height: 10,child: Divider(thickness: 1,color: Colors.grey,)),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: RichText(
                                      text: TextSpan(
                                          children: [
                                            TextSpan(text: "Reason : ", style: TextStyle(fontFamily:"main",fontWeight:FontWeight.bold,color: Colors.black,fontSize: getSize(context, 2.2)),),
                                            TextSpan(text: leave.subject, style: TextStyle(color: Colors.blueGrey ,fontSize: getSize(context, 2.1)),),
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
                                            TextSpan(text: "Body : \n", style: TextStyle(fontFamily:"main",fontWeight:FontWeight.bold,color: Colors.black,fontSize: getSize(context, 2.2)),),
                                            TextSpan(text: leave.body, style: TextStyle(fontFamily:"main",color: Colors.blueGrey ,fontSize: getSize(context, 2.2)),),
                                          ]
                                      ),
                                    )
                                ),
                                SizedBox(height: 10),
                                leave.attachID.isNotEmpty?
                                Column(
                                  children: [
                                    Align(alignment:Alignment.topLeft,
                                        child: RichText(text: TextSpan(text: "Attachments : ", style: TextStyle(fontFamily:"main",fontWeight:FontWeight.bold,color: Colors.black,fontSize: getSize(context, 2.2)),),)),
                                    SizedBox(height: 5),
                                    GestureDetector(
                                        onTap: () => _zoomImage(leave.attachID), // Define _zoomImage function below
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0), // Adjust as desired
                                          child: Image(
                                            image: NetworkImage(leave.attachID),
                                          ),
                                        )
                                    ),
                                  ],
                                )
                                    :SizedBox()
                              ],
                            ),
                            trailing: RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(text: "   Status\n", style: TextStyle(fontFamily:"main",fontWeight:FontWeight.bold,color: Colors.black,fontSize: getSize(context, 2.2)),),
                                    TextSpan(text: leave.status.toUpperCase(), style: TextStyle(fontFamily:"main",color: leave.status == "approve" ? Colors.green : leave.status == "decline" ? Colors.red : Colors.orange,fontSize: getSize(context, 2.1)),),
                                  ]
                              ),
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

class LeaveApplication {
  final String id;
  final String studentName;
  final String studentID;
  final String studentEmail;
  final String subject;
  final String body;
  final String date;
  final String status;
  final String attachID;

  LeaveApplication.fromFirestore(DocumentSnapshot doc)
      : id = doc.id,
        studentName = doc['studentName'],
        subject = doc['subject'],
        studentID = doc['studentID'],
        studentEmail = doc['studentEmail'],
        body = doc['body'],
        date = doc['timestamp'],
        status = doc['status'],
        attachID = doc['attachmentID'];
}

