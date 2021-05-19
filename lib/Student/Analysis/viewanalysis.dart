import 'package:MAST_app/Student/Analysis/AnalysisArgs.dart';
import 'package:MAST_app/loadinginit.dart';
import 'package:flutter/material.dart';
import './analysis.dart';

class ViewAnalysis extends StatefulWidget {

  final AnalysisArgs args;

  ViewAnalysis(this.args);

  @override
  _ViewAnalysisState createState() => _ViewAnalysisState(args);
}

class _ViewAnalysisState extends State<ViewAnalysis> {

  AnalysisArgs args;
  bool _pronunciation;
  List<dynamic> _incorrectPhonemes;
  bool _hasLoaded = false;

  _ViewAnalysisState(this.args);

  void computeResults() {
    bool pronunciation;
    List<dynamic> incorrectPhonemes;

    if (args != null) {
      pronunciation = args.prediction();
      incorrectPhonemes = args.incorrectPhonemes();
    }
    print('Mispronunciation: $pronunciation');
    print('Incorrect Phonemes List: $incorrectPhonemes');

    setState(() {
      _incorrectPhonemes = incorrectPhonemes;
      _pronunciation = pronunciation;
      _hasLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasLoaded) return LoadingInit("Loading...");

    this.computeResults();
    var wordInfo = args.getInfo();
    var phonemes = wordInfo['phonemes'];
    return WordAnalysis(
      _incorrectPhonemes, phonemes, args.word, args.scores, _pronunciation
    );
  }
}