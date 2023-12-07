import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ict/helpers/size.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/contents.dart';

class AllStudentsPage extends StatefulWidget {
  @override
  State<AllStudentsPage> createState() => _AllStudentsPageState();
}

class _AllStudentsPageState extends State<AllStudentsPage> {
  final Stream<QuerySnapshot> _studentsStream =
  FirebaseFirestore.instance.collection('user').where('rool', isEqualTo: "student").snapshots();
  String _searchQuery = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('All Students',
            style: TextStyle(
                fontSize: getSize(context, 2.5),
                fontFamily: "main",
                color: Colors.white,
                fontWeight: FontWeight.bold)),backgroundColor: muColor,centerTitle: true,),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
                decoration: InputDecoration(hintText: 'Search by Name or Enrollment',hintStyle: TextStyle(fontFamily: "Main")),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _studentsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final students = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    final name = student['name'];
                    final sname = student['sname'];
                    final enroll = student['enroll'];
                    final fullname = "$name $sname";
                    final clas = student['class'];
                    final sem = student['sem'];
                    final mobile = student['mobile'];

                    if (!name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
                        !sname.toLowerCase().contains(_searchQuery.toLowerCase()) &&
                        !fullname.toLowerCase().contains(_searchQuery.toLowerCase()) &&
                        !enroll.contains(_searchQuery.toLowerCase())) {
                      return SizedBox.shrink(); // Hide student if not matching
                    }
                    return Card(
                      child: ListTile(
                        title: Text('$name $sname',style: TextStyle(fontFamily: 'main',fontSize: getSize(context, 2))),
                        subtitle: Text('$sem - $clas - $enroll',style: TextStyle(fontFamily: 'main',fontSize: getSize(context, 1.5))),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.call),
                              onPressed: () => launch('tel:$mobile'),
                            ),
                            IconButton(
                              icon: Icon(FontAwesomeIcons.whatsapp),
                              onPressed: () async {
                                final url = 'https://wa.me/+91$mobile';
                                  launch(url);
                              },
                            ),
                          ],
                        ),
                        onLongPress: () async {
                          await Get.dialog(
                            AlertDialog(
                              title: Text('Delete Student',style: TextStyle(fontFamily: "Main")),
                              content: Text('Are you sure you want to delete $name $sname ?',style: TextStyle(fontFamily: "Main")),
                              actions: [
                                ElevatedButton(
                                  child: Text('Cancel',style: TextStyle(fontFamily: "Main",color: Colors.white)),
                                  onPressed: Get.back,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                    backgroundColor: muColor,
                                  ),
                                ),
                                ElevatedButton(
                                  child: Text('Delete',style: TextStyle(fontFamily: "Main",color: Colors.white)),
                                  onPressed: () async {
                                    Get.back();
                                    await FirebaseFirestore.instance.collection('user').doc(student.id).delete();
                                    Get.snackbar("Success", "Student deleted successfully!",
                                        backgroundColor: Colors.green, colorText: Colors.white,);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                    backgroundColor: muColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
