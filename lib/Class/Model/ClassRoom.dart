import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClassRoom {

  String name;
  DateTime startDate;
  DateTime endDate;
  String userId;
  String classId;
  String type;
  String userName;

  ClassRoom(this.name, this.startDate, this.endDate, this.userId, this.classId, this.type, this.userName);

  Future<void> addClassTeacher() {
    // Create a reference to the new document you will add to the collection of classes
    DocumentReference docRef = FirebaseFirestore.instance.collection("classes").doc();
    classId = docRef.id;
    userId = FirebaseAuth.instance.currentUser.uid;
    userName =FirebaseAuth.instance.currentUser.displayName;

    return docRef.set(this.toJSON())
      .then((value) => print("Class Added"))
      .catchError((error) => print("Failed to add user: $error"));
  }

  Future<bool> addClassStudent() async {
    // Create a reference to the new document you will add to the collection of classes
    DocumentReference docRef = FirebaseFirestore.instance.collection("classes").doc();
    userId = FirebaseAuth.instance.currentUser.uid;
    userName =FirebaseAuth.instance.currentUser.displayName;
    // Retrieve the class the student would like to join
    var query = FirebaseFirestore.instance.collection("classes")
      .where("classId", isEqualTo: classId)
      .where("type", isEqualTo: "teacher");
    var result = await query.get();
    var data = result.docs;

    // Add a new document for so that we know that the current user in the class given by classId
    if (data.isNotEmpty) {
      var val = data.elementAt(0).data();
      name = val['name'];
      startDate = (val['startDate'] as Timestamp).toDate();
      endDate = (val['endDate'] as Timestamp).toDate();

      docRef.set(this.toJSON())
        .then((value) => print("Class Added"))
        .catchError((error) => print("Failed to add user: $error"));
      return true;
    }

    return false;
  }  

  toJSON() {
    return {
      'name': this.name,
      'startDate': this.startDate,
      'endDate': this.endDate,
      'userId': this.userId,
      'classId': this.classId,
      'type': this.type,
      'userName': this.userName
    };
  }

  static Future<Iterable<ClassRoom>> fetchClasses(String userId) async {
    var query = FirebaseFirestore.instance.collection("classes").where("userId", isEqualTo: userId);
    var result = await query.get();
    return result.docs.map((snapshot) {
      var data = snapshot.data();
      return ClassRoom(data['name'],
        (data['startDate'] as Timestamp).toDate(),
        (data['endDate'] as Timestamp).toDate(), 
        data['userId'], 
        data['classId'], 
        data['type'],
        data['userName']
      );
    });
  }


}