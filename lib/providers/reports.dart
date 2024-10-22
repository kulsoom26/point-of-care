import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/report.dart';

class Reports with ChangeNotifier {
  List _reports = [];
  List get reports {
    return [..._reports];
  }

  Report findById(String id) {
    return _reports.firstWhere((report) => report.id == id);
  }

  Future<void> fetchReports() async {
    final response = await http.get(Uri.parse(
        'https://point-of-care-4ad46-default-rtdb.firebaseio.com/reports.json'));
    var extractedData = json.decode(response.body);
    if (extractedData == null) {
      return;
    }
    List loadedReports = [];
    extractedData as Map;
    extractedData.forEach((key, value) {
      loadedReports.add({
        "key": key,
        "name": value['name'],
        "time": value['time'],
        "results": value['results'],
        "id": value['id'],
        "image": value['image'],
        "Verification": value['Verification']
      });
    });
    print(loadedReports);
    _reports = loadedReports;
    notifyListeners();
  }
}
