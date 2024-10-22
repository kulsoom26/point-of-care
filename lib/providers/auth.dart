import 'dart:convert';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test/constants/const.dart';
import 'package:test/providers/doctor.dart';
import 'package:test/providers/patient.dart';
import 'package:test/providers/radiologist.dart';
import 'package:test/providers/user_provider.dart';
import 'package:test/screens/User%20Profiling/screens/authentication.dart';
import 'package:test/screens/User%20Profiling/screens/emailOTP.dart';
import 'package:test/utils/snack_bar_util.dart';

class Auth with ChangeNotifier {
  String? userid;
  String? useremail;
  String? userName;
  String? Role;
  List<Auth> _users = [];

  Auth({
    required this.userid,
    required this.useremail,
    required this.userName,
    required this.Role,
  });

  Auth.toauth();

  List<Auth> get users {
    return [..._users];
  }

  set setName(name) {
    userName = name;
    notifyListeners();
  }

  set setEmail(email) {
    useremail = email;
    notifyListeners();
  }

  String? get role {
    return Role;
  }

  String? get username {
    return userName;
  }

  String? get userId {
    return userid;
  }

  String? get userEmail {
    return useremail;
  }

  Future<void> login(String email, String password) async {
    final url = "$nodeApi/api/users/login";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            "email": email,
            "password": password,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 401 || response.statusCode == 500) {
        throw responseData['message'].toString();
      }
      userid = responseData['user']['_id'];
      useremail = responseData['user']['email'];
      userName = responseData['user']['name'];
      Role = responseData['user']['role'];
      notifyListeners();
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  Future<void> signup(
      String name, String email, String password, String role) async {
    final url = "$nodeApi/api/users/signup";
    try {
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(
            {"name": name, "email": email, "password": password, "role": role},
          ));
      final responseData = json.decode(response.body);
      if (response.statusCode == 500 || response.statusCode == 422) {
        throw responseData['message'].toString();
      }
      userid = responseData['user']['_id'];
      useremail = responseData['user']['email'];
      userName = responseData['user']['name'];
      Role = responseData['user']['role'];
      // _expiryDate = DateTime.now().add(
      //   Duration(seconds: int.parse(responseData['expiresIn'])),
      // );
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> fetchUsers() async {
    final url = "$nodeApi/api/users";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      extractedData = extractedData['users'] as List;
      print(extractedData);

      final List<Auth> loadedUsers = [];
      for (int i = 0; i < extractedData.length; i++) {
        var doc = extractedData[i];
        loadedUsers.add(Auth(
            userid: doc['id'],
            userName: doc['name'],
            useremail: doc['email'],
            Role: doc['role']));
      }
      _users = loadedUsers;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  void logout() {
    userid = null;
    notifyListeners();
  }

  void verifyEmailForPasswordRecovery({
    required BuildContext context,
    required String email,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);

      final url = "$nodeApi/api/users/emailVerification";
      EmailOTP myauth = EmailOTP();
      http.Response res = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'email': email,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var response = jsonDecode(res.body);
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          if (response == false) {
            showSnackBar(
              context,
              'Email is not registered, Please enter correct email',
            );
          } else {
            userProvider.setUser(res.body);
            myauth.setConfig(
                appEmail: "Hashir@POC.com",
                appName: "Point-Of-Care",
                userEmail: email,
                otpLength: 6,
                otpType: OTPType.digitsOnly);
            if (await myauth.sendOTP() == true) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("OTP has been sent"),
              ));
            } else {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Oops, OTP send failed"),
              ));
            }

            navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => EmailOtp(myauth: myauth),
              ),
              (route) => true,
            );
          }
        },
      );
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void passwordReset({
    required BuildContext context,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final navigator = Navigator.of(context);
      http.Response res = await http.post(
        Uri.parse('$nodeApi/api/users/passwordReset'),
        body: jsonEncode({
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => Authentication(),
            ),
            (route) => false,
          );
          showSnackBar(
            context,
            'Password reset successfully!',
          );
        },
      );
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void updateDoctor(
      {required BuildContext context,
      required String name,
      required String email,
      required String contact,
      required String experience,
      required String specialization,
      required String description,
      required String time,
      required String fees,
      required String image,
      required String gender}) async {
    try {
      final navigator = Navigator.of(context);
      var userProvider = Provider.of<Auth>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$nodeApi/api/users/updateDoctor'),
        body: jsonEncode({
          'userId': userProvider.userId,
          'email': email,
          'name': name,
          'contact': contact,
          'experience': experience,
          'specialization': specialization,
          'description': description,
          'time': time,
          'fees': fees,
          'image': image,
          'gender': gender
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var doctorProvider = Provider.of<Doctor>(context, listen: false);
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          final Map<String, dynamic> responseData = jsonDecode(res.body);

          // ignore: unnecessary_null_comparison
          if (res.body != null) {
            final user = responseData['user'];
            final doctor = responseData['doctor'];

            userProvider.setName = user['name'];
            doctorProvider.setDoctor(
              userProvider.userId,
              doctor['userName'],
              doctor['contact'],
              doctor['experience'],
              doctor['specialization'],
              doctor['description'],
              doctor['time'],
              doctor['fees'],
              doctor['image'],
              doctor['gender'],
            );
            notifyListeners();
            navigator.pop();
            showSnackBar(
              context,
              'Information updated successfully!!',
            );
          } else {
            showSnackBar(context, 'Response body is null');
          }
        },
      );
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void updatePatient(
      {required BuildContext context,
      required String name,
      required String email,
      required String contact,
      required String age,
      required String image,
      required String gender}) async {
    try {
      var userProvider = Provider.of<Auth>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$nodeApi/api/users/updatePatient'),
        body: jsonEncode({
          'userId': userProvider.userId,
          'email': email,
          'userName': name,
          'contact': contact,
          'age': age,
          'image': image,
          'gender': gender
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var patientProvider = Provider.of<Patient>(context, listen: false);

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          final Map<String, dynamic> responseData = jsonDecode(res.body);

          // ignore: unnecessary_null_comparison
          if (res.body != null) {
            final user = responseData['user'];
            final patient = responseData['patient'];

            userProvider.setName = user['name'];
            patientProvider.setPatient(
                userProvider.userId,
                patient['userName'],
                patient['contact'],
                patient['gender'],
                patient['image'],
                patient['age'].toString());
            Navigator.of(context).pop();
            showSnackBar(
              context,
              'Information updated successfully!!',
            );
          } else {
            showSnackBar(context, 'Response body is null');
          }
        },
      );
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void updateRadiologist(
      {required BuildContext context,
      required String name,
      required String email,
      required String contact,
      required String age,
      required String image,
      required String gender}) async {
    try {
      var userProvider = Provider.of<Auth>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('${nodeApi}/api/users/updateRadiologist'),
        body: jsonEncode({
          'userId': userProvider.userId,
          'email': email,
          'userName': name,
          'contact': contact,
          'age': age,
          'image': image,
          'gender': gender
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var radiologistProvider =
          Provider.of<Radiologist>(context, listen: false);

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          final Map<String, dynamic> responseData = jsonDecode(res.body);

          // ignore: unnecessary_null_comparison
          if (res.body != null) {
            final user = responseData['user'];
            final radiologist = responseData['radiologist'];

            userProvider.setName = user['name'];
            radiologistProvider.setRadiologist(
                userProvider.userId,
                radiologist['userName'],
                radiologist['contact'],
                radiologist['gender'],
                radiologist['image'],
                radiologist['age'].toString());
            Navigator.of(context).pop();
            showSnackBar(
              context,
              'Information updated successfully!!',
            );
          } else {
            showSnackBar(context, 'Response body is null');
          }
        },
      );
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }
}
