import 'package:MAST_app/Class/Model/ClassRoom.dart';
import 'package:flutter/material.dart';

class StudentHome extends StatefulWidget {

  final ClassRoom currClass;

  StudentHome(this.currClass);

  @override
  _StudentHomeState createState() => _StudentHomeState(currClass);
}

class _StudentHomeState extends State<StudentHome> {

  ClassRoom currClass = null;

  _StudentHomeState(this.currClass);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/datahistory', arguments: currClass), 
              child: Text('View Data History')
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/pronunciation', arguments: currClass), 
              child: Text('Practice Pronunciation')
            )
          ],
        ),
      )
    );
  }
}