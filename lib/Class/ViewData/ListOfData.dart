import 'package:MAST_app/Student/Model/DataRecord.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:MAST_app/Class/Model/Student.dart';
import 'package:MAST_app/loadinginit.dart';
import 'package:MAST_app/Class/ViewData/ViewData.dart';



class ListOfData extends StatefulWidget {
  String classID;
  String studentID;
  String studentName;
  ListOfData({Key key,@required this.classID, this.studentID,this.studentName}) : super(key: key);

  ListOfData.fromViewClass(this.classID) ;
  get getclassID => classID;
  get getstudentID => studentID;
  @override
  _ListOfDataState createState() => _ListOfDataState(classID,studentID,studentName);
}

/// This is the private State class that goes with ListOfStudents.
class _ListOfDataState extends State<ListOfData> {
  String classID;
  String studentID;
  String studentName;
  get getclassID => classID;
  get getstudentID => studentID;
  _ListOfDataState(this.classID,this.studentID,this.studentName);

  Iterable<DataRecord> data;
  bool hasLoaded = false;

  @override
  void initState() {
    retrieveData();
    super.initState();
  }

  Future<void> retrieveData() async {
    Iterable<DataRecord> listOfData = await DataRecord.fetchDataRecords(
        studentID, classID);
    setState(() {
      data = listOfData;
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
          title: Text(studentName),
        ),
        // infinite list
        body: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: this.data.length,
            itemBuilder: (BuildContext context, int index) {
              var dataObj = this.data.elementAt(index);
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.class_),
                      // title: Text('${classObj.name} - ${classObj.userId}'),
                      title: Text('${dataObj.recordId} '),
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ViewData( recordId: dataObj.recordId),
                              ),);
                            },
                            child: Text('View Data')
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
