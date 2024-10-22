import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:test/constants/const.dart';
import 'package:test/models/http_exception.dart';

class Radiologist with ChangeNotifier {
  String? userId;
  String? userName;
  String? age;
  String? contact;
  String? gender;
  String? image;

  List<Radiologist> _radiologists = [];

  Radiologist.fromrad();

  Radiologist(
      {required this.userId,
      required this.userName,
      required this.age,
      required this.contact,
      required this.gender,
      required this.image});

  Radiologist getRadiologist(String id) {
    return _radiologists.firstWhere((element) => element.userId == id);
  }

  void setRadiologist(uid, name, con, gen, ima, ag) {
    final p = _radiologists.firstWhere((element) => element.userId == uid);

    p.age = ag;
    p.userName = name;
    p.contact = con;
    p.gender = gen;
    p.image = ima;

    age = ag;
    userName = name;
    contact = con;
    gender = gen;
    image = ima;

    notifyListeners();
  }

  Future<void> fetchRadiologists() async {
    final url = "$nodeApi/api/users/radiologists";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      extractedData = extractedData['radiologists'] as List;
      print(extractedData);

      final List<Radiologist> loadedRadiologists = [];
      for (int i = 0; i < extractedData.length; i++) {
        var doc = extractedData[i];
        loadedRadiologists.add(Radiologist(
          age: doc['age'].toString(),
          userName: doc['userName'],
          contact: doc['contact'],
          gender: doc['gender'],
          image: doc['image'],
          userId: doc['userId'],
        ));
      }
      _radiologists = loadedRadiologists;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
    notifyListeners();
  }

  Future<void> addRadiologist(Radiologist radiologist) async {
    final url = "$nodeApi/api/users/addRadiologist";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            "userId": radiologist.userId,
            "userName": radiologist.userName,
            "age": radiologist.age,
            "contact": radiologist.contact,
            "gender": radiologist.gender,
            "image": radiologist.image,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['message']);
      }
      notifyListeners();
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
