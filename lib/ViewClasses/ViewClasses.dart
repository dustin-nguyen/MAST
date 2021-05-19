import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Class/Model/ClassRoom.dart';
import '../loadinginit.dart';
import 'ListOfStudents.dart';

class ViewClasses extends StatefulWidget {
  ViewClasses({Key key}) : super(key: key);

  @override
  _ViewClassesState createState() => _ViewClassesState();
}

/// This is the private State class that goes with ViewClasses.
class _ViewClassesState extends State<ViewClasses> {

  Iterable<ClassRoom> classes;
  bool hasLoaded = false;

  @override
  void initState() {
    retrieveClasses();
    super.initState();
  }

  Future<void> retrieveClasses() async {
    Iterable<ClassRoom> allclasses = await ClassRoom.fetchClasses(FirebaseAuth.instance.currentUser.uid);
    setState(() {
      classes = allclasses;
      hasLoaded = true;
    });
  }

  Widget build(BuildContext context) {
    if (!hasLoaded) return LoadingInit("Loading");
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classes'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: this.classes.length,
        itemBuilder: (BuildContext context, int index) {
          var classObj = this.classes.elementAt(index);
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.class_),
                  title: Text('${classObj.name} - ${classObj.type}'),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        if (classObj.type == 'teacher') Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ListOfStudents( classID: classObj.classId,name:classObj.name),
                        ),);
                        else Navigator.pushNamed(context, '/student', arguments: classObj);
                      },
                      child: Text('View Class')
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