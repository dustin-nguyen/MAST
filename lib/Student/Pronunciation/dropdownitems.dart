import 'package:flutter/material.dart';

class DropDownSelection extends StatefulWidget {
  @override
  DropDownSelectionState createState() => DropDownSelectionState();
}

class DropDownSelectionState extends State<DropDownSelection> {

  static String dropdownValue = 'with';

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: dropdownValue,
      elevation: 16,
      style: const TextStyle(color: Colors.blue),
      underline: Container(
        height: 2,
        color: Colors.lightBlue,  
      ),
      onChanged: (value) {
        setState(() {
          dropdownValue = value;
        });
      },
      items: <String>['with', 'you', 'why', 'teach', 'yesterday']
        .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value)
          );
        }).toList(),
    );
  }
}