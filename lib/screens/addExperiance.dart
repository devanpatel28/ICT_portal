import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'leave_history.dart';

class AddExperiance extends StatefulWidget {
  const AddExperiance({Key? key}) : super(key: key);

  @override
  _AddExperianceState createState() => _AddExperianceState();

  static fromFirestore(DocumentSnapshot<Object?> documentSnapshot) {}
}

class _AddExperianceState extends State<AddExperiance> {
  // Form fields
  final _companyController = TextEditingController();
  final _bodyController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  String studentName = "";

  // Firestore reference
  final _firestore = FirebaseFirestore.instance;

  Future<void> submitApplication() async {
    if (user != null) {
      final docRef =
          FirebaseFirestore.instance.collection('user').doc(user?.uid);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final Map<String, dynamic>? data = docSnapshot.data();
        studentName = "${data?['name']} ${data?['sname']}";
      }
    }
    // Validate form fields
    if (_companyController.text.isEmpty || _bodyController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    // Create new leave application document in Firestore
    await _firestore.collection('interview').add({
      'studentID' : user?.uid,
      'studentName': studentName,
      'company': _companyController.text,
      'experiance': _bodyController.text,
      'date':
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
    });

    Get.snackbar("Success", "Your Experiance Added successfully!",
        backgroundColor: Colors.green, colorText: Colors.white);

    // Reset form fields
    _companyController.clear();
    _bodyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Experiance"),
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
                controller: _companyController,
                decoration: InputDecoration(
                  labelText: "Company Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _bodyController,
                minLines: 10,
                maxLines: 50,
                decoration: InputDecoration(
                  labelText: "Your Experiance",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitApplication,
                child: Text("Submit Experiance"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
