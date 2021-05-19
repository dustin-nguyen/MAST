import 'package:cloud_firestore/cloud_firestore.dart';


class Student {
  String name;
  String classId;
  String studentID;

 Student(this.name, this.studentID, this.classId);
  //Student(this.studentID, this.classId);

  toJSON() {
    return {
      'name': this.name,
      'studentID': this.studentID,
      'classId': this.classId,
    };
  }

  static Future<Iterable<Student>> fetchStudents(String userId, String classId) async {
    var query = FirebaseFirestore.instance.collection("classes").where("type", isEqualTo: "student").where("classId",isEqualTo: classId);
    var result = await query.get();
    return result.docs.map((snapshot) {
      var data = snapshot.data();
      return Student(    data['userName'],
          data['userId'],
          data['classId'],
      );
    });
  }
}