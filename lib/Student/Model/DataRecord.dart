import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class DataRecord {
  
  String recordId;
  String userId;
  String classId;
  File file;
  DocumentReference audioDocRef;
  List<dynamic> scores;
  String word;

  DataRecord(this.recordId, this.userId, this.classId, this.file, this.audioDocRef, this.scores, this.word);

  Future<List<dynamic>> addAllData(String word) async {
    // Make a request with the data to our server to get acoustic scores
    //List<dynamic> response = await postAudioToServer(word);
    List<int> response = [-183, -158, -274, -107, -393];
    this.scores = response;

    // Add audio .wav file to Firebase storage
    addAudio();
    
    // Add DataRecord to Firestore
    addDataRecord();

    return response;
  }

  /**
   * Sends a request to the local server with the audio file and word.
   * Returns a list of acoustic scores for the phonemes of the word.
   */
  Future<List<dynamic>> postAudioToServer(String word) async {
    // URL of server is set HERE!!
    //String url = Platform.isAndroid ? "http://10.0.2.2:8000" : "http://127.0.0.1:8000";
    String url = "http://192.168.1.10:8000";
    var req = http.MultipartRequest('POST', Uri.parse(url));

    req.fields['word'] = word;
    req.files.add(
      await http.MultipartFile.fromPath(
        'audio',
        this.file.path
      )
    );

    var streamedResponse = await req.send();
    var response = await http.Response.fromStream(streamedResponse);
    var json = jsonDecode(response.body);
    List<dynamic> resp = json['scores'];

    print("RESPONSE CODE IS: ${streamedResponse.statusCode}");
    print("resp is $resp");
    return resp;
  }

  Future<void> addAudio() async {
    print('In addAudio, docRef.id is ${audioDocRef.id}');
    try {
      await FirebaseStorage.instance
        .ref(audioDocRef.id)
        .putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> addDataRecord() async {
    print('In addDataRecord, audioDocRef.id is ${audioDocRef.id}');
    recordId = audioDocRef.id;

    return audioDocRef.set(this.toJSON())
      .then((value) => print("Data Record Added"))
      .catchError((error) => print("Failed to add data record: $error")); 
  }

  toJSON() {
    return {
      'recordId': this.recordId,
      'userId': this.userId,
      'classId': this.classId,
      'filePath': this.file.path,
      'audioDocRef': this.audioDocRef.id,
      'scores': this.scores,
      'word': this.word
    };
  }

  static Future<Iterable<DataRecord>> fetchDataRecords(String userId, String classId) async {
    var query = FirebaseFirestore.instance.collection("datarecord").where("userId", isEqualTo: userId).where("classId", isEqualTo: classId);
    var result = await query.get();

    return result.docs.map((snapshot) {
      var data = snapshot.data();
      return DataRecord(
        data['recordId'],
        data['userId'],
        data['classId'],
        File(data['filePath']),
        null, // change here
        data['scores'],
        data['word']
      );
    });
  }
  static Future<Iterable<DataRecord>> fetchData(String recordID) async {
    var query = FirebaseFirestore.instance.collection("datarecord").where("recordID", isEqualTo: recordID);
    var result = await query.get();

    return result.docs.map((snapshot) {
      var data = snapshot.data();
      return DataRecord(
          data['recordId'],
          data['userId'],
          data['classId'],
          File(data['filePath']),
          null, // change here
          data['scores'],
          data['word']
      );
    });
  }
}