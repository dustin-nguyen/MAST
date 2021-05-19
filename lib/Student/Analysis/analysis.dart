import 'package:flutter/material.dart';

class WordAnalysis extends StatelessWidget {

  final List<dynamic> incorrectPhonemes;
  
  final List<dynamic> phonemes;

  final List<dynamic> scores;

  final String word;

  final bool pronunciation;

  WordAnalysis(this.incorrectPhonemes, this.phonemes, this.word, this.scores, this.pronunciation);

  createRows() {
    List<dynamic> phonemesMap = [];
    phonemesMap.addAll(phonemes);

    List<Row> rows = phonemesMap.asMap().entries.map((entry) {
      int index = entry.key;
      String val = entry.value;
      bool isIncorrect = incorrectPhonemes.contains(val);

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(val + ':', style: TextStyle(color: (isIncorrect ? Colors.red : Colors.green))),
          Text('${scores[index + 1]}')
        ],
      );
    }).toList();

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analysis"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(pronunciation ? 'Correct!' : 'Incorrect!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: createRows()
              ),
            ),
            Container(
              child: Text('Word: $word'),
            )
          ],
        ),
      )
    );
  }
}