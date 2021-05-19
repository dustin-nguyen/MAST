import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './Model/ClassRoom.dart';

class CreateClassPage extends StatefulWidget {
  CreateClassPage({Key key}) : super(key: key);

  @override
  _CreateClassPageState createState() => _CreateClassPageState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _CreateClassPageState extends State<CreateClassPage> {
  final _formKey = GlobalKey<FormState>();

  String name;
  Future<DateTime> startDate;
  Future<DateTime> endDate;

  Future<void> createClass() async {
    DateTime astartDate = await this.startDate;
    DateTime aendDate = await this.endDate;
    if (astartDate.isBefore(aendDate)) {
      ClassRoom(name, astartDate, aendDate, FirebaseAuth.instance.currentUser.uid, '', 'teacher',FirebaseAuth.instance.currentUser.displayName).addClassTeacher();
      Navigator.popAndPushNamed(context, '/teacher');
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Class'),
        ),
        body: Center(
            child: Form(
                key: _formKey,
                child: Column(
                    children: <Widget>[
                      SizedBox(width:300,child:TextFormField(
                        maxLength: 45,
                        decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter class\'s name',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Class\'s name cannot be empty';
                        }
                        this.name = value;
                        return null;
                      },
                    )),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        child: Text('Enter Start Date'),
                        onPressed: () {
                          Future<DateTime> start = showDatePicker(
                            context: context, 
                            initialDate: DateTime.now(), 
                            firstDate: DateTime.now(), 
                            lastDate: DateTime.now().add(const Duration(days: 90))
                          );
                          this.startDate = start;
                        },
                      )
                    ),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        child: Text('Enter End Date'),
                        onPressed: () {
                          Future<DateTime> end = showDatePicker(
                            context: context, 
                            initialDate: DateTime.now(), 
                            firstDate: DateTime.now(), 
                            lastDate: DateTime.now().add(const Duration(days: 90))
                          );
                          this.endDate = end;
                        },
                      ) 
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          this.createClass();
                        }
                      },
                      child: Text('Create'),
                    ),
                  ]
                )
            )
        )
    );
  }
}