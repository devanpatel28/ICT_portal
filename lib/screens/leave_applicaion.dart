import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ict/helpers/contents.dart';
import 'package:ict/helpers/size.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'leave_history.dart';

class LeaveApplication extends StatefulWidget {
  const LeaveApplication({Key? key}) : super(key: key);

  @override
  _LeaveApplicationState createState() => _LeaveApplicationState();

  static fromFirestore(DocumentSnapshot<Object?> documentSnapshot) {}

}

class _LeaveApplicationState extends State<LeaveApplication> {
  // Form fields
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  String _attachmentID = "";
  bool _isLoadingImage = false;
  final user = FirebaseAuth.instance.currentUser;
  String studentName = "";
  String studentEmail = "";

  // Firebase Storage reference
  final _storage = FirebaseStorage.instance;
  // Firestore reference
  final _firestore = FirebaseFirestore.instance;


  Future<void> submitApplication() async {
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('user').doc(user?.uid);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final Map<String, dynamic>? data = docSnapshot.data();
        studentName = "${data?['name']} ${data?['sname']}";
        studentEmail = "${data?['studentEmail']}";
      }
    }
    // Validate form fields
    if (_subjectController.text.isEmpty || _bodyController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields!",backgroundColor: Colors.red,colorText: Colors.white);
      return;
    }
    // Create new leave application document in Firestore
    await _firestore.collection('leave').add({
      'studentID':user?.uid,
      'studentName': studentName,
      'studentEmail':studentEmail,
      'subject': _subjectController.text,
      'body': _bodyController.text,
      'attachmentID': _attachmentID,
      'status': 'pending',
      'timestamp': "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
    });

    Get.snackbar("Success", "Leave application submitted successfully!",backgroundColor: Colors.green,colorText: Colors.white);

    // Reset form fields
    _subjectController.clear();
    _bodyController.clear();
    setState(() {
      _attachmentID = "";
    });
  }

  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Upload the image to Firebase Storage
        final ref = _storage.ref().child('attachments/${user?.uid}_${DateTime.now().microsecond}');
        final uploadTask = ref.putFile(File(pickedFile.path));

        // Wait for the upload to complete
        await uploadTask.whenComplete(() async {
          // Get the download URL of the uploaded image
          final downloadURL = await ref.getDownloadURL();

          // Store the download URL in the _attachmentID field
          setState(() {
              _isLoadingImage = true;
            _attachmentID = downloadURL;
          });
        });
      }
    } catch (error) {
      Get.snackbar("Error", "Failed to pick image!");
    }finally {
      setState(() {
        _isLoadingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leave Application"),
        actions: [
          IconButton(
              onPressed: () => Get.to(LeaveHistoryPage()),
              icon: Icon(Icons.history)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: "Subject",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _bodyController,
                minLines: 5,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: "Reason for Leave",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              if (_attachmentID.isNotEmpty)
                Stack(
                  children: [
                    Image.network(_attachmentID),
                    _isLoadingImage? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(alignment: Alignment.center,
                          child: CircularProgressIndicator(color: muColor,strokeWidth: 5,)),
                    ):SizedBox(),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: FloatingActionButton(
                        heroTag: "deleteAttachmentButton",
                        onPressed: () {
                          setState(() {
                            _attachmentID = "";
                          });
                        },
                        child: Icon(Icons.delete),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: pickImageFromGallery,
                child: Text("Attach Document"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitApplication,
                child: Text("Submit Leave Application"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
