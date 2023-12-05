import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ict/helpers/size.dart';
import '../helpers/contents.dart';

class AddFaculty extends StatefulWidget {
  @override
  _AddFacultyState createState() => _AddFacultyState();
}

class _AddFacultyState extends State<AddFaculty> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _snameController = TextEditingController();
  final _mobileController = TextEditingController();

  Future<void> _submitUser() async {
    final String name = _nameController.text.trim();
    final String sname = _snameController.text.trim();
    final String mobile = _mobileController.text.trim();

    String _getPassword(String name) {
      return "${name.toUpperCase()}@123";
    }

    String _getEmail(String name, String sname) {
      String mail = "$name.$sname@gmail.com";
      return mail.toLowerCase();
    }

    if (_formKey.currentState!.validate()) {
      await addFaculty(_getEmail(name, sname),_getPassword(name), name, sname, mobile,"faculty");
      Get.snackbar("Success", "Faculty added successfully!",
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
                  controller: _mobileController,
                  decoration: InputDecoration(labelText: 'Mobile Number'),
                  keyboardType: TextInputType.phone,
                ),
                ElevatedButton(
                  onPressed: _submitUser,
                  child: Text('Add Faculty'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
