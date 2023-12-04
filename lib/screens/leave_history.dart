import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ict/helpers/contents.dart';

import '../helpers/size.dart';

class LeaveHistoryPage extends StatefulWidget {
  const LeaveHistoryPage({Key? key}) : super(key: key);

  @override
  _LeaveHistoryPageState createState() => _LeaveHistoryPageState();
}

class _LeaveHistoryPageState extends State<LeaveHistoryPage> {
  // Firestore reference
  final transformationController = TransformationController();
  final _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Leave History"),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('leave').where('studentID', isEqualTo: user?.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Align(
                            alignment:Alignment.topLeft,
                            child: Text("${document['timestamp'].toString()}",style: TextStyle(color: muColor,fontFamily: "main"),)),
                        subtitle: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  text: TextSpan(
                                      children: [
                                        TextSpan(text: "Reason : ", style: TextStyle(fontFamily:"main",fontWeight:FontWeight.bold,color: Colors.black,fontSize: getSize(context, 2.2)),),
                                        TextSpan(text: document['subject'], style: TextStyle(color: Colors.blueGrey ,fontSize: getSize(context, 2.1)),),
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
                                        TextSpan(text: document['body'], style: TextStyle(fontFamily:"main",color: Colors.blueGrey ,fontSize: getSize(context, 2.2)),),
                                      ]
                                  ),
                                )
                            ),
                            SizedBox(height: 10,),
                            document['attachmentID'].toString().isNotEmpty?
                            Column(
                              children: [
                                Align(alignment:Alignment.topLeft,
                                    child: RichText(text: TextSpan(text: "Attachments : ", style: TextStyle(fontFamily:"main",fontWeight:FontWeight.bold,color: Colors.black,fontSize: getSize(context, 2.2)),),)),
                                SizedBox(height: 5),
                                GestureDetector(
                                      onLongPress: () => _zoomImage(document['attachmentID']), // Define _zoomImage function below
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15.0), // Adjust as desired
                                        child: Image(
                                          image: NetworkImage(document['attachmentID']),
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
                                TextSpan(text: document['status'].toUpperCase(), style: TextStyle(fontFamily:"main",color: document['status'] == "approve" ? Colors.green : document['status'] == "decline" ? Colors.red : Colors.orange,fontSize: getSize(context, 2.1)),),
                              ]
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
