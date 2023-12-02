import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ict/helpers/contents.dart';

class LeaveHistoryPage extends StatefulWidget {
  const LeaveHistoryPage({Key? key}) : super(key: key);

  @override
  _LeaveHistoryPageState createState() => _LeaveHistoryPageState();
}

class _LeaveHistoryPageState extends State<LeaveHistoryPage> {
  // Firestore reference
  final _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

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
                    child: ListTile(
                      title: Text(document['subject']),
                      subtitle: Column(
                        children: [
                          Align(
                              alignment:Alignment.topLeft,
                              child: Text("${document['timestamp'].toString()}",style: TextStyle(color: muColor,fontFamily: "main"),)),
                          SizedBox(height: 10,),
                          Align(
                              alignment:Alignment.topLeft,
                              child: Text("${document['body'].toString()}",)),
                          SizedBox(height: 10,),
                          document['attachmentID'].toString().isNotEmpty?
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                             borderRadius: BorderRadius.circular(10)
                            ),
                              child: Image(image: NetworkImage(document['attachmentID']))
                          )
                              :SizedBox()
                        ],
                      ),
                      trailing: Icon(
                          document['status']=="approve"?Icons.check_circle_rounded:
                          document['status']=="decline"?Icons.cancel_rounded:Icons.hourglass_bottom_outlined,
                        color:  document['status']=="approve"?Colors.green:
                        document['status']=="decline"?Colors.red:Colors.orange,
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
