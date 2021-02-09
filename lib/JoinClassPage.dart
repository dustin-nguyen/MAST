import 'package:flutter/material.dart';

class JoinClassPage extends StatefulWidget {
  JoinClassPage({Key key}) : super(key: key);

  @override
  _JoinClassPageState createState() => _JoinClassPageState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _JoinClassPageState extends State<JoinClassPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Join Class'),
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
                          hintText: 'Please enter Class ID',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return ' Class ID cannot be empty';
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
                        child: Text('Join'),
                      ),
                    ]
                )
            )
        )
    );
  }
}
