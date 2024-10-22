import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test/constants/const.dart';
import 'package:http/http.dart' as http;
import 'package:test/utils/labels.dart';

class Results extends ChangeNotifier {
  List<Map<String, dynamic>> _results = [];
  var image1;
  var breast;
  var kidney;

  Results();

  List<Map<String, dynamic>> get result {
    return _results;
  }

  Future<void> diagnose(image, dis) async {
    String endpoint = dis == 'chest'
        ? 'xray'
        : dis == 'breast'
            ? 'breast'
            : 'kidney';

    final api = Uri.parse('$flaskApi/$endpoint');

    if (image == null) return;
    String base64Image = base64Encode(image!.readAsBytesSync());
    await http.post(
      api,
      body: {
        'file': base64Image,
      },
    ).then((res) {
      print(res.statusCode);
      print(res.body);
      final response = json.decode(res.body);
      _results = [];

      if (dis == 'chest') {
        for (int i = 0; i < labels.length; i++) {
          _results.add({
            labels[i]: {
              'percentage': response['percentages'][i],
              'heatmap': response['heatmaps'][i]
            }
          });
        }
        image1 = response['original'];
        print(_results.length);
      } else if (dis == 'breast') {
        breast = response['prediction'];
      } else {
        kidney = response['kidney'];
      }
      notifyListeners();
    });
  }
}
