import 'package:flutter/material.dart';

class ViewClasses extends StatefulWidget {
  ViewClasses({Key key}) : super(key: key);

  @override
  _ViewClassesState createState() => _ViewClassesState();
}

/// This is the private State class that goes with ViewClasses.
class _ViewClassesState extends State<ViewClasses> {
  int _count = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classes'),
      ),
      body: Center(child: Text('You have pressed the button $_count times.')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _count++),
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
