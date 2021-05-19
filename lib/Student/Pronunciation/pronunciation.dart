import 'dart:io';

import 'package:MAST_app/Student/Analysis/AnalysisArgs.dart';
import 'package:MAST_app/loadinginit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../Model/DataRecord.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Class/Model/ClassRoom.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file/local.dart';
import 'package:file/file.dart';
import './dropdownitems.dart';

class PronunciationPage extends StatefulWidget {

  final ClassRoom currClass;

  PronunciationPage(this.currClass);

  @override
  _PronunciationPageState createState() => _PronunciationPageState(currClass);
}

class _PronunciationPageState extends State<PronunciationPage> {

  FlutterAudioRecorder _recorder;
  Recording _recording = Recording();
  RecordingStatus _currStatus = RecordingStatus.Unset;
  bool _hasPermissions = false;
  bool _isLoading = false;
  String _currWord;
  DocumentReference _docRef;
  ClassRoom currClass;
  LocalFileSystem localFileSystem;
  List<dynamic> _scores;

  _PronunciationPageState(this.currClass);

  void initState() {
    localFileSystem = LocalFileSystem();
    requestPermissions();
    super.initState();
  }

  requestPermissions() async {
    var micStatus = await Permission.microphone.status;
    var storageStatus = await Permission.storage.status;
    var speechStatus = await Permission.speech.status;
    var phoneStatus = await Permission.phone.status;
    bool hasPermissions = false;

    if (micStatus.isUndetermined || storageStatus.isUndetermined || speechStatus.isUndetermined || phoneStatus.isUndetermined) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
        Permission.storage,
        Permission.speech,
        Permission.phone,
      ].request();
      print(" Microphone status: ${statuses[Permission.microphone]}, Storage status: ${statuses[Permission.storage]}");
      hasPermissions = true;
    } else if (micStatus.isGranted && storageStatus.isGranted && speechStatus.isGranted && phoneStatus.isGranted) {
      hasPermissions = true;
    }

    setState(() {
      _hasPermissions = hasPermissions;
    });
  }

  start() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        print("Audio Recorder has permissions");
        var appDocDirectory;
        String path;
        DocumentReference docRef = FirebaseFirestore.instance.collection("datarecord").doc();

        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }
        path = appDocDirectory.path + '/' + docRef.id;

        print("Initialize Audio Recorder, path: $path");
        _recorder = FlutterAudioRecorder(path, audioFormat: AudioFormat.WAV, sampleRate: 16000);
        await _recorder.initialized;
        
        print("Start Audio Recorder");
        await _recorder.start();
        var current = await _recorder.current(channel: 0);
        
        setState(() {
          _recording = current;
          _currStatus = current.status;
          _docRef = docRef;
          _currWord = DropDownSelectionState.dropdownValue;
        });
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("You must accept permissions!"),));
      }
    } catch (e) {
      print(e);
    }
  }

  stop() async {
    File file;

    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    file = localFileSystem.file(result.path);

    setState(() {
      _recording = result;
      _currStatus = result.status;
      _isLoading = true;
    });

    List<dynamic> resp = await DataRecord("", FirebaseAuth.instance.currentUser.uid, currClass.classId, file, _docRef, [], _currWord).addAllData(_currWord);

    setState(() {
      _scores = resp;
      _isLoading = false;
    });
  }

  tryAgain() {
    setState(() {
      _currStatus = RecordingStatus.Unset;
    });
  }

  submit() {
    Navigator.popAndPushNamed(context, '/viewanalysis', arguments: AnalysisArgs(this.currClass, this._scores, _currWord));
  }

  playRecording() {
    print('recording path: ${_recording.path}');
    AudioPlayer player = AudioPlayer();
    player.play(_recording.path);
  }

  @override
  Widget build(BuildContext context) {
    //return (!_hasPermissions || _hasSubmitted) ? LoadingInit() : Scaffold(
    if (!_hasPermissions || _isLoading) {
      String displayText = (!_hasPermissions) ? "Awaiting Permissions..." : "Analyzing...";
      return LoadingInit(displayText);
    } else if (_currStatus != RecordingStatus.Stopped) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Practice Pronunciaiton'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Text('Choose Word', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                    DropDownSelection()
                  ]
                ),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: (_currStatus != RecordingStatus.Recording) ? start : null,
                  child: Text("Start"),
                )
              ),
              Container(
                child: ElevatedButton(
                  onPressed: (_currStatus == RecordingStatus.Recording) ? stop : null, 
                  child: Text("Stop")
                )
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Practice Pronunciation'),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: playRecording,
                  child: Text("Play Recording"),
                ),
                ElevatedButton(
                  onPressed: tryAgain, 
                  child: Text("Try Again")
                ),
                ElevatedButton(
                  onPressed: submit,
                  child: Text("Submit")
                )
              ],
            ),
          ),
        ),
      );
    }
  }

}