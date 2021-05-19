import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './home.dart';
import './login.dart';

class LoadingAuth extends StatefulWidget {
  
  _LoadingAuthState createState() => _LoadingAuthState();
  
}

class _LoadingAuthState extends State<LoadingAuth> {

  bool loggedIn = false;
  int stateLevel = 0;

  @override
  initState() {
    checkIfUserLoggedIn();
    super.initState();
  }

  void checkIfUserLoggedIn() {
    FirebaseAuth.instance
      .authStateChanges()
      .listen((User user) {
        if (user == null) {
          print('User null');
          setState(() {
            loggedIn = false;
            stateLevel = stateLevel + 1;
          });
        } else {
          print(user);
          setState(() {
            loggedIn = true;
            stateLevel = stateLevel + 1;
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    if (stateLevel == 0) {
      return Scaffold(
        appBar: AppBar(title: Text("Loading"),),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Please Wait", 
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6), 
                    fontStyle: FontStyle.italic,
                    fontSize: 18
                  ),
                ),
                Container(child: CircularProgressIndicator(), padding: EdgeInsets.all(20),),
              ],
            ),
          ),
        ),
      );
    }

    return loggedIn ? Home() : Login();
  }
}
