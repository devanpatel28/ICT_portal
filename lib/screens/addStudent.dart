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
  final _classController = TextEditingController();
  final _labController = TextEditingController();
  final _grController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _EnrollController = TextEditingController();
  final _semController = TextEditingController();

  Future<void> _submitUser() async {
    final String email = _emailController.text.trim();
    final String name = _nameController.text.trim();
    final String sname = _snameController.text.trim();
    final String clas = _classController.text.trim();
    final String lab = _labController.text.trim();
    final String gr = _grController.text.trim();
    final String mobile = _mobileController.text.trim();
    final String enroll = _EnrollController.text.trim();
    final int sem = int.parse(_semController.text);

    String _getPassword(String name) {
      return "$name@123";
    }
    String _getEmail(String name, String sname, String gr) {
      String mail = "$name.$sname$gr@marwadiuniversity.ac.in";
      return mail.toLowerCase();
    }

    if (_formKey.currentState!.validate()) {
      final uid = await addUser(
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
        "student"
      );
      Get.snackbar("Success",'Student added successfully!',backgroundColor: Colors.red,colorText: Colors.white);
      _formKey.currentState!.reset();
    }
    else
      {
        Get.snackbar("Error",'Please add all the details',backgroundColor: Colors.red,colorText: Colors.white);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add Student',style: TextStyle(fontSize: getSize(context, 2.5),fontFamily: "main",fontWeight: FontWeight.bold)),backgroundColor: muColor,centerTitle: true,),
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
                      TextFormField(
                        controller: _classController,
                        decoration: InputDecoration(labelText: 'Class'),
                      ),
                      TextFormField(
                        controller: _labController,
                        decoration: InputDecoration(labelText: 'Lab'),
                      ),
                      TextFormField(
                        controller: _grController,
                        decoration: InputDecoration(labelText: 'GR no.'),
                      ),
                      TextFormField(
                        controller: _mobileController,
                        decoration: InputDecoration(labelText: 'Mobile Number'),
                        keyboardType: TextInputType.phone,
                      ),
                      TextFormField(
                        controller: _EnrollController,
                        decoration: InputDecoration(labelText: 'Enroll'),
                      ),
                      ElevatedButton(
                        onPressed: _submitUser,
                        child: Text('Add Student'),
                      ),
                    ],
                  ),
                )
            )
        )
    );
  }
}
