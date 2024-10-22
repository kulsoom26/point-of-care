// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test/constants/const.dart';
import 'package:test/models/appointment.dart';
import 'package:test/screens/Appointments/screens/rescheduleAppointment.dart';
import 'package:test/screens/Main/screens/tabScreen.dart';
import '../utils/snack_bar_util.dart';
import 'package:http/http.dart' as http;

class AppointmentServices extends ChangeNotifier {
  Appointment _appointment = Appointment(
    id: '',
    doctorId: '',
    userId: '',
    gender: '',
    contact: '',
    reason: '',
    name: '',
    time: '',
    date: '',
    status: '',
  );

  List<Appointment> _appointmentsList = [];
  List<Appointment> _doctorAppointmentList = [];
  List<Appointment> _singleAppointmentData = [];

  Appointment get appointment => _appointment;

  List<Appointment> get appointmentsList => [..._appointmentsList];
  List<Appointment> get appointmentDoctorList => _doctorAppointmentList;
  List<Appointment> get singleAppointmentData => _singleAppointmentData;

  void setAppointment(String appointment) {
    _appointment = Appointment.fromJson(appointment);
    notifyListeners();
  }

  void setAppointmentFromModel(Appointment appointment) {
    _appointment = appointment;
    notifyListeners();
  }

  void setAppointmentsList(appointment) {
    print(appointment);
    _appointmentsList.add(appointment);
    notifyListeners();
  }

  void setDoctorAppointmentList(List<Appointment> doctorAppointmentList) {
    _doctorAppointmentList = doctorAppointmentList;
    notifyListeners();
  }

  void setSingleAppointment(List<Appointment> singleAppointmentData) {
    _singleAppointmentData = singleAppointmentData;
    notifyListeners();
  }

  //book Appointment
  void addAppointment(
      {required BuildContext context,
      required String doctorId,
      required String userId,
      required String gender,
      required String contact,
      required String reason,
      required String name,
      required String time,
      required String date,
      required String status,
      required bool flag}) async {
    try {
      Appointment appointment = Appointment(
        id: '',
        doctorId: doctorId,
        userId: userId,
        gender: gender,
        contact: contact,
        reason: reason,
        name: name,
        time: time,
        date: date,
        status: status,
      );

      http.Response res = await http.post(
        Uri.parse('$nodeApi/api/user/addAppointment'),
        body: appointment.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          final Map<String, dynamic> responseData = jsonDecode(res.body);

          // ignore: unnecessary_null_comparison
          if (res.body != null) {
            final appointment = responseData['appointment'];
            setAppointmentsList(Appointment(
                id: appointment['id'],
                doctorId: appointment['doctorId'],
                userId: appointment['userId'],
                gender: appointment['gender'],
                contact: appointment['contact'],
                reason: appointment['reason'],
                status: appointment['status'],
                date: appointment['date'],
                time: appointment['time'],
                name: appointment['name']));
            showSnackBar(context, "Appointment scheduled successfully!");
            var count = 0;
            Navigator.of(context).popUntil(
              (_) => flag ? count++ >= 1 : count++ >= 2,
            );
          } else {
            showSnackBar(context, 'Response body is null');
          }
        },
      );
    } catch (error) {
      showSnackBar(context, "$error");
      Navigator.of(context).pop();
    }
  }

  Future<void> getAppointments({
    required BuildContext context,
  }) async {
    try {
      final http.Response res = await http.get(
        Uri.parse('$nodeApi/api/user/getAppointments'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          var responseData = json.decode(res.body);
          if (responseData == null) {
            return;
          }

          responseData = responseData['appointments'] as List;
          print(responseData);
          final List<Appointment> loadedAppointments = [];
          for (int i = 0; i < responseData.length; i++) {
            var doc = responseData[i];
            loadedAppointments.add(Appointment(
              id: doc['_id'],
              doctorId: doc['doctorId'],
              userId: doc['userId'],
              status: doc['status'],
              gender: doc['gender'],
              contact: doc['contact'],
              reason: doc['reason'],
              name: doc['name'],
              time: doc['time'],
              date: doc['date'],
            ));
          }

          _appointmentsList = loadedAppointments;
          notifyListeners();
        },
      );
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void getDoctorAppointments({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      final http.Response res = await http.get(
        Uri.parse('$nodeApi/api/user/getDoctorAppointments/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (res.statusCode == 200) {
        final List<dynamic> responseData = json.decode(res.body);
        final List<Appointment> appointmentsList =
            responseData.map((appointmentData) {
          return Appointment(
              id: appointmentData['_id'],
              status: appointmentData['status'],
              reason: appointmentData['reason'],
              name: appointmentData['name'],
              time: appointmentData['time'],
              date: appointmentData['date'],
              gender: appointmentData['gender'],
              contact: appointmentData['contact'],
              userId: appointmentData['userId'],
              doctorId: appointmentData['doctorId']);
        }).toList();

        setDoctorAppointmentList(appointmentsList);
        print(appointmentsList[0].id);
      } else {
        showSnackBar(context, 'Failed to fetch doctor appointments');
      }
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void updateAppointment({
    required BuildContext context,
    required String id,
    required String doctorId,
    required String userId,
    required String gender,
    required String contact,
    required String reason,
    required String name,
    required String time,
    required String date,
    required String status,
  }) async {
    try {
      Appointment appointment = Appointment(
        id: id,
        doctorId: doctorId,
        userId: userId,
        gender: gender,
        contact: contact,
        reason: reason,
        name: name,
        time: time,
        date: date,
        status: status,
      );
      final navigator = Navigator.of(context);

      http.Response res = await http.post(
        Uri.parse('$nodeApi/api/user/updateAppointment/$id'),
        body: appointment.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          // ignore: unnecessary_null_comparison
          if (res.body != null) {
            setAppointment(res.body);
          } else {
            showSnackBar(context, 'Response body is null');
          }
          showSnackBar(context, "Appointment rescheduled successfully!");
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => TabsScreen(),
            ),
            (route) => false,
          );
        },
      );
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void getAppointmentInformation(
      {required BuildContext context, required String id}) async {
    try {
      final http.Response res = await http.get(
        Uri.parse('$nodeApi/api/user/getSingleAppointment/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final Map<String, dynamic> responseMap = json.decode(res.body);

      final appointmentData = responseMap;

      final updateAppointmentList = [
        Appointment(
          id: appointmentData['_id'],
          userId: appointmentData['userId'],
          gender: appointmentData['gender'],
          contact: appointmentData['contact'],
          time: appointmentData['time'],
          date: appointmentData['date'],
          reason: appointmentData['reason'],
          name: appointmentData['name'],
          status: appointmentData['status'],
          doctorId: appointmentData['doctorId'],
        ),
      ];

      setSingleAppointment(updateAppointmentList);
      await Future.delayed(const Duration(seconds: 1));
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RescheduleAppointment()),
      );
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void cancelAppointment({
    required BuildContext context,
    required String id,
    required String status,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$nodeApi/api/user/cancelAppointment'),
        body: jsonEncode({'id': id, 'status': status}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          final Map<String, dynamic> responseData = jsonDecode(res.body);

          // ignore: unnecessary_null_comparison
          if (res.body != null) {
            final appointment = responseData['appointment'];
            print(appointment);
            print(appointmentsList);
            _appointmentsList
                .firstWhere((element) => element.id == appointment['id'])
                .status = appointment['status'];
            notifyListeners();
          }
        },
      );
    } catch (error) {
      // Show an alert-like dialog for errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(error.toString()),
          );
        },
      );
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pop();
    }
  }

  void completeAppointment({
    required BuildContext context,
    required String id,
    required String status,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$nodeApi/api/user/completeAppointment'),
        body: jsonEncode({'status': status, 'id': id}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          final Map<String, dynamic> responseData = jsonDecode(res.body);

          // ignore: unnecessary_null_comparison
          if (res.body != null) {
            final appointment = responseData['appointment'];
            print(appointment);
            print(appointmentsList);
            _appointmentsList
                .firstWhere((element) => element.id == appointment['id'])
                .status = appointment['status'];
            notifyListeners();
            showSnackBar(context, "Appointment completed successfully!");
          }
        },
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(error.toString()),
          );
        },
      );
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pop();
      showSnackBar(context, error.toString());
    }
  }
}
