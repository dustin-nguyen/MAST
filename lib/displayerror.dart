import 'package:flutter/material.dart';

class DisplayError extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error'),),
      body: Center(
        child: Text(
          "ERROR: Something has gone wrong",
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

}