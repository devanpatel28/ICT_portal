import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ict/helpers/size.dart';

Color muColor = Color(0xFF0098B5);
getMainIcon(context,IconButton ib,String str)
{
  return Column(
    children: [
      Container(
        height: getHeight(context, 0.12),
        width: getWidth(context, 0.24),
        decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(getSize(context, 2)),
      ),
        child: ib,
      ),
      SizedBox(height: 5,),
      Text(str,style: TextStyle(fontFamily: "Main",color: Colors.black),)
    ],
  );
}
Future<String> addUser(String email, String password, String name, String sname,
    String clas, String lab, String gr, String mobile, String roll, int sem,String rool) async {
  final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  final uid = userCredential.user!.uid;
  final userRef = FirebaseFirestore.instance.collection('user').doc(uid);
  await userRef.set({
    'name': name,
    'sname': sname,
    'class': clas,
    'lab': lab,
    'gr': gr,
    'mobile': mobile,
    'email': email,
    'enroll': roll,
    'sem': sem,
    'rool': rool,
  });

  return uid; // return the user UID for future use
}