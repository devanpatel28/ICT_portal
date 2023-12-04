import 'package:cloud_firestore/cloud_firestore.dart';

var db = FirebaseFirestore.instance;

class FirebaseOperations {

  static Stream<
      QuerySnapshot> fetchTransactions()
  {
    CollectionReference user = db.collection("user");
    return user.snapshots();
  }
}