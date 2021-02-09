import 'package:flutter/material.dart';

class CreateClassPage extends StatefulWidget {
  CreateClassPage({Key key}) : super(key: key);

  @override
  _CreateClassPageState createState() => _CreateClassPageState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _CreateClassPageState extends State<CreateClassPage> {
  final _formKey = GlobalKey<FormState>();

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
                      return null;
                    },
                  )),
                      SizedBox(width:300,child:TextFormField(
                        maxLength: 45,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Please enter start date',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Start date cannot be empty';
                          }
                          return null;
                        },
                      )),
                      SizedBox(width:300,child:TextFormField(
                        maxLength: 45,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Please enter end date',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'End date cannot be empty';
                          }
                          return null;
                        },
                      )),
                      ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, otherwise false.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.

                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
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
