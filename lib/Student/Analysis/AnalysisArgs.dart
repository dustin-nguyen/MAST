import 'package:MAST_app/Class/Model/ClassRoom.dart';
import 'dart:math';

class AnalysisArgs {

  ClassRoom currClass;
  List<dynamic> scores;
  String word;

  AnalysisArgs(this.currClass, this.scores, this.word);

  static var withInfo = {
    'phonemes': ['sil', 'w', 'ih', 'dh', 'sil'],
    'params': [-0.01487943, 0.52000952, -0.21383414, 0.55343958, 0.0989222],
    'intercept': 133.84651256
  };

  static var youInfo = {
    'phonemes': ['sil', 'y', 'uw', 'sil'],
    'params': [0.00274827, 0.00034041],
    'intercept': 1.2984371365964948
  };

  static var whyInfo = {
    'phonemes': ['w', 'ay'],
    'params': [0.00015751, 0.00313753],
    'intercept': 1.5310474205597338
  };

  static var teachInfo = {
    'phonemes': ['t', 'iy', 'ch'],
    'params': [0.00158959, 0.00075367, 0.00096305],
    'intercept': 1.5744697805617103
  };

  static var yesterdayInfo = {
    'phonemes': ['y', 'eh', 's', 't', 'er', 'd', 'ey'],
    'params': []
  };

  getInfo() {
    switch (word) {
      case 'with':
        return withInfo;
      case 'you':
        return youInfo;
      case 'why':
        return whyInfo;
      case 'teach':
        return teachInfo;
      default:
        return {};
    }
  }

  bool prediction() {
    var info = getInfo();
    List<double> params = info['params'];
    double res = 0.0, pred = 0.0;
    
    for (var i = 0; i < params.length; i++) {
      res += (params[i] * scores[i]);
    }
    res += info['intercept'];

    pred = 1.0 / (1.0 + exp(-1*res));
    return (pred > 0.5);
  }

  List<dynamic> incorrectPhonemes() {
    var info = getInfo();
    var phonemes = info['phonemes'];
    var incorrect = [];

    for (var i = 0; i < scores.length; i++) {
      if (i == 0 && scores[i] < -500 && scores[i+1] >= -500) {
        scores[i+1] = scores[i];
      } else if (i == scores.length - 1 && scores[i] < -500 && scores[i-1] >= -500) {
        scores[i-1] = scores[i];
        incorrect.add(phonemes[i-1]);
      } else if (0 < i && i < scores.length - 1 && scores[i] < -500) {
        incorrect.add(phonemes[i]);
      }
    }

    return incorrect;
  }
  
}