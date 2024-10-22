import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:test/providers/patient.dart';
import 'package:test/providers/radiologist.dart';
import 'package:test/screens/Main/screens/tabScreen.dart';

import '../../../providers/auth.dart';
import '../../../providers/doctor.dart';
import '../../../widgets/MyButton.dart';

class DoctorProfile extends StatefulWidget {
  static const routeName = 'doctor-profile';
  DoctorProfile({super.key});

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  File? _image;
  int id = 1;
  TextEditingController _ageController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _feeController = TextEditingController();
  TextEditingController _specializationController = TextEditingController();
  bool _isLoading = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTime1 =
      TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 30)));

  String _errorMessage6 = '';

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
              title: const Text('An Error Occurred!'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(c).pop();
                  },
                  child: const Text('Okay'),
                )
              ],
            ));
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;
      });
  }

  Future<void> _selectTime1(BuildContext context) async {
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime1 = picked_s;
      });
  }

  Future getImage(bool isCamera) async {
    XFile? image;
    if (isCamera) {
      image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 100);
    } else {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    File? file = File(image!.path);
    setState(() {
      _image = file;
    });
  }

  Future<void> addData() async {
    if (_contactController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _experienceController.text.isEmpty ||
        _specializationController.text.isEmpty) {
      _showErrorDialog("Some fields are empty!");
      return;
    }
    setState(() {
      _isLoading = true;
    });

    var url;
    if (_image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child("userImage")
          .child(DateTime.now().toString() + ".jpg");
      await ref.putFile(_image!);
      url = await ref.getDownloadURL();
    } else {
      return;
    }

    final user = Provider.of<Auth>(context, listen: false);
    try {
      Provider.of<Doctor>(context, listen: false)
          .addDoctor(Doctor(
              userId: user.userId,
              userName: user.userName,
              fees: _feeController.text,
              time: "${(selectedTime.hour % 12).toString()}:${selectedTime.minute.toString()} ${selectedTime.period.name}" +
                  "-" +
                  "${(selectedTime1.hour % 12).toString()}:${selectedTime1.minute.toString()} ${selectedTime1.period.name}",
              contact: _contactController.text,
              description: _descriptionController.text,
              experience: _experienceController.text,
              gender: _genderController.text,
              image: url,
              specialization: _specializationController.text))
          .then((_) {
        int count = 0;
        Provider.of<Doctor>(context, listen: false).fetchDoctors();
        Navigator.of(context).popUntil((_) => count++ >= 2);
        setState(() {
          _isLoading = false;
        });
      });
    } on HttpException catch (e) {
      var errorMessage = 'Authentication failed.';
      if (e.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address exists.';
      } else if (e.toString().contains("INVALID_EMAIL")) {
        errorMessage = 'This is not a valid email address.';
      } else if (e.toString().contains("WEAK_PASSWORD")) {
        errorMessage = 'This password is too weak.';
      } else if (e.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = 'Could not find a user with that email.';
      } else if (e.toString().contains("INVALID_PASSWORD")) {
        errorMessage = 'Incorrect password.';
      }
      _showErrorDialog(errorMessage);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';

      setState(() {
        _isLoading = false;
      });
    }
  }

  void addData1(String role) async {
    if (_ageController.text.isEmpty ||
        _contactController.text.isEmpty ||
        _genderController.text.isEmpty) {
      _showErrorDialog("Some fields are empty!");
      return;
    }

    var url;
    if (_image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child("userImage")
          .child(DateTime.now().toString() + ".jpg");
      await ref.putFile(_image!);
      url = await ref.getDownloadURL();
    } else {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    final user = Provider.of<Auth>(context, listen: false);

    try {
      if (role == 'Radiologist') {
        Provider.of<Radiologist>(context, listen: false)
            .addRadiologist(Radiologist(
          userId: user.userId,
          userName: user.userName,
          age: _ageController.text,
          contact: _contactController.text,
          gender: _genderController.text,
          image: url,
        ))
            .then((_) {
          var count = 0;
          Navigator.of(context).popUntil(
            (_) => count++ >= 2,
          );
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        Provider.of<Patient>(context, listen: false)
            .addPatient(Patient(
          userId: user.userId,
          userName: user.userName,
          age: _ageController.text,
          contact: _contactController.text,
          gender: _genderController.text,
          image: url,
        ))
            .then((_) {
          var count = 0;
          Navigator.of(context).popUntil(
            (_) => count++ >= 2,
          );
          setState(() {
            _isLoading = false;
          });
        });
      }
    } on HttpException catch (e) {
      var errorMessage = 'Authentication failed.';
      if (e.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address exists.';
      } else if (e.toString().contains("INVALID_EMAIL")) {
        errorMessage = 'This is not a valid email address.';
      } else if (e.toString().contains("WEAK_PASSWORD")) {
        errorMessage = 'This password is too weak.';
      } else if (e.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = 'Could not find a user with that email.';
      } else if (e.toString().contains("INVALID_PASSWORD")) {
        errorMessage = 'Incorrect password.';
      }
      _showErrorDialog(errorMessage);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var route =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        route['role'] == "Doctor"
                            ? "Doctor Profile"
                            : route['role'] == "Patient"
                                ? "Patient Profile"
                                : "Radiologist Profile",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            color: Color.fromARGB(255, 247, 247, 247)),
                        child: ClipOval(
                          child: _image != null
                              ? Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                )
                              : const Center(
                                  child: Text(
                                  "Choose a photo",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'League Spartan'),
                                )),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              getImage(true);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFB9A0E6)),
                            child: const Text('Camera'),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              getImage(false);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFB9A0E6)),
                            child: const Text('Gallery'),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _contactController,
                        decoration: const InputDecoration(
                          labelText: 'Contact',
                          labelStyle: TextStyle(
                            fontFamily: 'League Spartan',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: Colors.grey,
                          ),
                          prefixIconColor: Colors.black,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'League Spartan',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (route['role'] == 'Patient' ||
                          route['role'] == "Radiologist")
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2, left: 0),
                          child: TextField(
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(width: 1),
                              ),
                              prefixIcon: Icon(Icons.calendar_month_outlined),
                              hintText: 'Enter your age',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                fontFamily: 'League Spartan',
                              ),
                            ),
                            controller: _ageController,
                            onChanged: (val) {
                              validateAge(val);
                            },
                          ),
                        ),
                      route['role'] != 'Doctor'
                          ? Container()
                          : TextFormField(
                              controller: _specializationController,
                              decoration: const InputDecoration(
                                labelText: 'Specialization',
                                labelStyle: TextStyle(
                                  fontFamily: 'League Spartan',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                prefixIcon: Icon(
                                  Icons.app_registration_rounded,
                                  color: Colors.grey,
                                ),
                                prefixIconColor: Colors.black,
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'League Spartan',
                              ),
                              keyboardType: TextInputType.text,
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      route['role'] != 'Doctor'
                          ? Container()
                          : TextFormField(
                              controller: _experienceController,
                              decoration: const InputDecoration(
                                labelText: 'Experience',
                                labelStyle: TextStyle(
                                  fontFamily: 'League Spartan',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                prefixIcon: Icon(
                                  Icons.badge_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'League Spartan',
                              ),
                              keyboardType: TextInputType.text,
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      route['role'] != 'Doctor'
                          ? Container()
                          : TextFormField(
                              controller: _descriptionController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                  fontFamily: 'League Spartan',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                prefixIcon: Icon(
                                  Icons.description_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'League Spartan',
                              ),
                              keyboardType: TextInputType.text,
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          SizedBox(
                            width: 13,
                          ),
                          Icon(Icons.group, color: Colors.grey),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Gender",
                            style: TextStyle(
                              fontFamily: "League Spartan",
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: id,
                            onChanged: (val) {
                              setState(() {
                                id = 1;
                                _genderController.text = 'Male';
                              });
                            },
                          ),
                          const Text(
                            'Male',
                            style: TextStyle(
                              fontFamily: 'League Spartan',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF696969),
                            ),
                          ),
                          Radio(
                            value: 2,
                            groupValue: id,
                            onChanged: (val) {
                              setState(() {
                                _genderController.text = 'Female';
                                id = 2;
                              });
                            },
                          ),
                          const Text(
                            'Female',
                            style: TextStyle(
                              fontFamily: 'League Spartan',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF696969),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (route['role'] == 'Doctor')
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2, left: 6),
                          child: TextField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.money),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(width: 1),
                              ),
                              label: Text('Consultation Fee'),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'League Spartan',
                            ),
                            controller: _feeController,
                            onChanged: (val) {
                              // validatefees(val);
                            },
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (route['role'] == 'Doctor')
                        Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.watch_later_outlined,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            const Text(
                              "Timings",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'League Spartan',
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width / 3,
                                padding:
                                    const EdgeInsets.only(bottom: 2, left: 2),
                                child: Row(
                                  children: [
                                    const Text(
                                      "From: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'League Spartan',
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _selectTime(context);
                                      },
                                      child: Container(
                                        color: Colors.grey.shade200,
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                            "${(selectedTime.hour % 12).toString()}:${selectedTime.minute.toString()} ${selectedTime.period.name}"),
                                      ),
                                    )
                                  ],
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width / 4,
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  children: [
                                    const Text(
                                      "To: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'League Spartan',
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _selectTime1(context);
                                      },
                                      child: Container(
                                        color: Colors.grey.shade200,
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                            "${(selectedTime1.hour % 12).toString()}:${selectedTime1.minute.toString()} ${selectedTime1.period.name}"),
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: double.infinity,
                        height: 50,
                        child: myButton(
                          "Save",
                          () => route['role'] != 'Doctor'
                              ? addData1(route['role']!)
                              : addData(),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void validateAge(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage6 = "Please enter valid input, it connot be empty";
      });
    } else {
      setState(() {
        _errorMessage6 = "";
      });
    }
  }
}
