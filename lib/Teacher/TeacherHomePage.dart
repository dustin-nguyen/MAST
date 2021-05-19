import 'package:flutter/material.dart';

class TeacherHome extends StatefulWidget {
  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Home Page'),
      ),
      body: Center(
        child: Text('Welcome to the teacher home page!'),
      ),
    );
  }
}