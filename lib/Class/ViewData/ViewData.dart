import 'package:MAST_app/Student/Model/DataRecord.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';

import 'package:MAST_app/Class/Model/Student.dart';
import '../../loadinginit.dart';


class ViewData extends StatefulWidget {
  String recordId;
  ViewData({Key key,@required this.recordId}) : super(key: key);


  @override
  _ViewDataState createState() => _ViewDataState(recordId);
}

/// This is the private State class that goes with ListOfStudents.
class _ViewDataState extends State<ViewData>  with SingleTickerProviderStateMixin{
  String recordId;
  String studentId;
  get getrecordId => recordId;

  _ViewDataState(this.recordId);

  Iterable<DataRecord> data;
  bool hasLoaded = false;

  //animation
  bool isLeftCollapsed = true;
  bool isRightCollapsed = true;
  bool isTopCollapsed = true;
  bool isBottomCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;

  @override
  void initState() {
    retrieveClasses();
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Future<void> retrieveClasses() async {
    Iterable<DataRecord> listOfData = await DataRecord.fetchData(recordId);
    setState(() {
      data = listOfData;
      hasLoaded = true;
    });
  }
  @override
   Widget build(BuildContext context) {
     if (!hasLoaded) return LoadingInit("Loading");
     Size size = MediaQuery.of(context).size;
     screenHeight = size.height;
     screenWidth = size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          bottomBar(screenWidth),
          AnimatedPositioned(
              left: isLeftCollapsed ? 0 : 0.5 * screenWidth,
              right: isRightCollapsed ? 0 : -0.2 * screenWidth,
              top: isTopCollapsed ? 0 : 0.12 * screenHeight,
              bottom: isBottomCollapsed ? 0 : 0.1 * screenHeight,
              duration: duration,
              child: dashboard(context)),
        ],
      ),
    );
  }

  Widget bottomBar(screenWidth) {
    return Positioned(
        bottom: 10,
        left: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                  FirebaseAuth.instance.currentUser.photoURL
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              FirebaseAuth.instance.currentUser.displayName,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 80,
            ),
            ElevatedButton(
                onPressed: () {},
                child: Text("Log Out")
            )
          ],
        )
    );
  }
  /// main content
  Widget dashboard(context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(recordId),
      ),
      body: Center(
        child: Text('Hello, world!'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          setState(() {
            isBottomCollapsed
                ? _controller.forward()
                : _controller.reverse();
            isBottomCollapsed = !isBottomCollapsed;
          });
        },
        child: isBottomCollapsed
            ? Icon(
          Icons.keyboard_arrow_up_outlined,
          size: 40,
        )
            : Icon(
          Icons.keyboard_arrow_down_outlined,
          size: 40,
        ),
      ),
    );
  }

}
