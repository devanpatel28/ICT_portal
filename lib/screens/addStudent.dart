import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ict/helpers/size.dart';

import '../helpers/contents.dart';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _snameController = TextEditingController();
  final _grController = TextEditingController();
  final _mobileController = TextEditingController();
  final _EnrollController = TextEditingController();
  final _semController = TextEditingController();

  String _selectedClass = "TK1";
  String _selectedLab = "A";

  Future<void> _submitUser() async {
    final String name = _nameController.text.trim();
    final String sname = _snameController.text.trim();
    final String clas = _selectedClass;
    final String lab = _selectedLab;
    final String gr = _grController.text.toString().trim();
    final String mobile = _mobileController.text.trim();
    final String enroll = _EnrollController.text.toString().trim();
    final int sem = int.parse(_semController.text);

    String _getPassword(String name) {
      return "${name.toUpperCase()}@123";
    }

    String _getEmail(String name, String sname, String gr) {
      String mail = "$name.$sname$gr@marwadiuniversity.ac.in";
      return mail.toLowerCase();
    }

    if (_formKey.currentState!.validate()) {
      await addUser(
          _getEmail(name, sname, gr),
          _getPassword(name),
          name,
          sname,
          clas.toUpperCase(),
          lab,
          gr,
          mobile,
          enroll,
          sem,
          "student");
      Get.snackbar("Success", "Student added successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);
      _formKey.currentState?.reset();
    } else {
      Get.snackbar("Error", "Please add all the details",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Add Student',
            style: TextStyle(
                fontSize: getSize(context, 2.5),
                fontFamily: "main",
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        backgroundColor: muColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                ),
                TextFormField(
                  controller: _snameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                ),
                TextFormField(
                  controller: _semController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Sem'),
                ),
                DropdownButtonFormField(
                  value: _selectedClass,
                  items: [
                    DropdownMenuItem(
                      value: "TK1",
                      child: Text("TK1"),
                    ),
                    DropdownMenuItem(
                      value: "TK2",
                      child: Text("TK2"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedClass = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Class'),
                ),
                DropdownButtonFormField(
                  value: _selectedLab,
                  items: [
                    DropdownMenuItem(
                      value: "A",
                      child: Text("A"),
                    ),
                    DropdownMenuItem(
                      value: "B",
                      child: Text("B"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedLab = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Class'),
                ),
                TextFormField(
                  controller: _grController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'GR no.'),
                ),
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(labelText: 'Mobile Number'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: _EnrollController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Enroll'),
                ),
                ElevatedButton(
                  onPressed: _submitUser,
                  child: Text('Add Student'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
