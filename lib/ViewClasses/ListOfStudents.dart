import 'package:MAST_app/Class/ViewData/ListOfData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';

import 'package:MAST_app/Class/Model/Student.dart';
import '../loadinginit.dart';
import 'package:MAST_app/Class/ViewData/ListOfData.dart';
import 'package:MAST_app/Class/ViewData/ViewData.dart';


class ListOfStudents extends StatefulWidget {
  String classID;
  String name;
  ListOfStudents({Key key,@required this.classID, this.name}) : super(key: key);

  ListOfStudents.fromViewClass(this.classID) ;
  get getclassID => classID;
  get getname => name;
  @override
  _ListOfStudentsState createState() => _ListOfStudentsState(classID,name);
}

/// This is the private State class that goes with ListOfStudents.
class _ListOfStudentsState extends State<ListOfStudents> {
  String classID;
  String name;
  get getclassID => classID;
  get getname => name;
  _ListOfStudentsState(this.classID,this.name);

  Iterable<Student> students;
  bool hasLoaded = false;

  @override
  void initState() {
    retrieveStudents();
    super.initState();
  }

  Future<void> retrieveStudents() async {
    Iterable<Student> allStudents = await Student.fetchStudents(
        FirebaseAuth.instance.currentUser.uid, classID);
    setState(() {
      students = allStudents;
      hasLoaded = true;
    });
  }

 /* Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(classID),
      ));
  }*/

   Widget build(BuildContext context) {
    if (!hasLoaded) return LoadingInit("Loading");
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        // infinite list
        body: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: this.students.length,
            itemBuilder: (BuildContext context, int index) {
              var classObj = this.students.elementAt(index);
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.class_),
                     // title: Text('${classObj.name} - ${classObj.userId}'),
                      title: Text('${classObj.name} '),
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ListOfData( classID: classObj.classId,studentID:classObj.studentID,studentName: classObj.name,),
                              ),);
                              },
                            child: Text('View Student')
                        )
                      ],
                    )
                  ],
                ),
              );
            }
        )
    );
  }
}
