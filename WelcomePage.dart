import 'package:flutter/material.dart';
import 'package:mast/CreateClassPage.dart';
import 'package:mast/ViewClasses.dart';
import 'package:mast/JoinClassPage.dart';



/*class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Open route'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateClassPage()),
            );
          },
        ),
      ),
    );
  }
}*/
class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: Text('View Class'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewClasses()),
                  );// push
                },// onPressed
              ),    //View Classes
              ElevatedButton(
              child: Text('Create Class'),
              onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateClassPage()),
                );// push
               },// onPressed
              ),    //Create class
              ElevatedButton(
                child: Text('Join Class'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JoinClassPage()),
                  );// push
                },// onPressed
              ),    //Join class
            ]
        )
      ),
    );
  }
}
