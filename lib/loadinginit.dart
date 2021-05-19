import 'package:flutter/material.dart';

class LoadingInit extends StatelessWidget {

  final String displayText;

  LoadingInit(this.displayText);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.displayText),),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Please Wait", style: TextStyle(color: Colors.black.withOpacity(0.6), fontStyle: FontStyle.italic)),
              CircularProgressIndicator(),
            ],
          ),
        ),
      )
    );
  }
}