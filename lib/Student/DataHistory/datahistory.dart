import 'package:MAST_app/loadinginit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Class/Model/ClassRoom.dart';
import '../Model/DataRecord.dart';
import '../Analysis/AnalysisArgs.dart';

class DataHistoryPage extends StatefulWidget {

  final ClassRoom currClass;

  DataHistoryPage(this.currClass);

  @override
  _DataHistoryPageState createState() => _DataHistoryPageState(currClass);
}

class _DataHistoryPageState extends State<DataHistoryPage> {

  Iterable<DataRecord> dataRecords;

  bool hasLoaded = false;

  ClassRoom currClass;

  _DataHistoryPageState(this.currClass);

  @override
  void initState() {
    retrieveDataRecords();
    super.initState();
  }

  Future<void> retrieveDataRecords() async {
    Iterable<DataRecord> records = await DataRecord.fetchDataRecords(FirebaseAuth.instance.currentUser.uid, currClass.classId);
    setState(() {
      dataRecords = records;
      hasLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!hasLoaded) return LoadingInit("Loading");

    return Scaffold(
      appBar: AppBar(
        title: Text('View Data History'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: this.dataRecords.length,
        itemBuilder: (context, index) {
          DataRecord record = this.dataRecords.elementAt(index);
          AnalysisArgs analysis = AnalysisArgs(currClass, record.scores, record.word);
          bool prediction = analysis.prediction();
          String subTitle = (prediction) ? "Correct - View Analysis" : "Incorrect - View Analysis";

          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.analytics),
                  title: Text('$index: ${record.word}'),
                  subtitle: Text(subTitle),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/viewanalysis', arguments: analysis), 
                      child: Text('View Analysis')
                    )
                  ],
                )
              ],
            )
          );
        }
      )
    );
  }
}