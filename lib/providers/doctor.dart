import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:test/constants/const.dart';
import '../models/http_exception.dart';

class Doctor with ChangeNotifier {
  String? userId;
  String? userName;
  String? time;
  String? fees;
  String? contact;
  String? gender;
  String? image;
  String? specialization;
  String? experience;
  String? description;

  List<Doctor> _doctors = [];

  Doctor.fromdoc();

  Doctor(
      {required this.userId,
      required this.userName,
      required this.time,
      required this.fees,
      required this.contact,
      required this.gender,
      required this.experience,
      required this.description,
      required this.image,
      required this.specialization});

  Doctor getDoctor(String id) {
    return _doctors.firstWhere((element) => element.userId == id);
  }

  List<Doctor> get doctors {
    return [..._doctors];
  }

  void setDoctor(
      uid,
      String name,
      String contact,
      String experience,
      String specialization,
      String description,
      String time,
      String fees,
      String image,
      String gender) {
    final d = _doctors.firstWhere((element) => element.userId == uid);

    d.userName = name;
    d.contact = contact;
    d.experience = experience;
    d.specialization = specialization;
    d.description = description;
    d.time = time;
    d.fees = fees;
    d.image = image;
    d.gender = gender;

    notifyListeners();
  }

  Future<void> fetchDoctors() async {
    final url = "$nodeApi/api/users/doctors";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      extractedData = extractedData['doctors'] as List;
      print(extractedData);

      final List<Doctor> loadedDoctors = [];
      for (int i = 0; i < extractedData.length; i++) {
        var doc = extractedData[i];
        loadedDoctors.add(Doctor(
            contact: doc['contact'],
            userName: doc['userName'],
            description: doc['description'],
            experience: doc['experience'],
            gender: doc['gender'],
            image: doc['image'],
            specialization: doc['specialization'],
            userId: doc['userId'],
            fees: doc['fees'],
            time: doc['time']));
      }

      _doctors = loadedDoctors;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
    notifyListeners();
  }

  Future<void> addDoctor(Doctor doctor) async {
    final url = "$nodeApi/api/users/addDoctor";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            "userId": doctor.userId,
            "userName": doctor.userName,
            "fees": doctor.fees,
            "time": doctor.time,
            "contact": doctor.contact,
            "gender": doctor.gender,
            "experience": doctor.experience,
            "image": doctor.image,
            "specialization": doctor.specialization,
            "description": doctor.description
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
