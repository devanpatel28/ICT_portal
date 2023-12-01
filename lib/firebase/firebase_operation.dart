import 'package:cloud_firestore/cloud_firestore.dart';

var db = FirebaseFirestore.instance;

class FirebaseOperations {

  static Stream<
      QuerySnapshot> fetchTransactions() // static method that we can use it without creating object it's the class method not object method so without creating objcet we can use it
  {
    CollectionReference transcation = db.collection("transactions");
    return transcation.snapshots();
  }
}