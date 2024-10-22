// ignore_for_file: file_names

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:test/constants/const.dart';
import 'package:test/providers/auth.dart';
import 'package:test/providers/doctor.dart';
import 'package:test/providers/patient.dart';
import 'package:test/providers/radiologist.dart';
import 'package:test/utils/customProgess.dart';

class EditProfileForm extends StatefulWidget {
  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  int id = 1;
  bool _isLoading = false;
  File? _image;

  TextEditingController _ageController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _feesController = TextEditingController();
  TextEditingController _specializationController = TextEditingController();
  String _genderController = '';

  Future<void> _getImage(ImageSource source) async {
    XFile? image;
    image = await ImagePicker().pickImage(source: source);

    File? file = File(image!.path);

    setState(() {
      _image = file;
    });
  }

  var role;
  var type;
  var user;
  @override
  void initState() {
    user = Provider.of<Auth>(context, listen: false);
    if (user.role == 'Doctor') {
      type =
          Provider.of<Doctor>(context, listen: false).getDoctor(user.userId!);
    } else if (user.role == 'Patient') {
      type =
          Provider.of<Patient>(context, listen: false).getPatient(user.userId!);
    } else {
      type = Provider.of<Radiologist>(context, listen: false)
          .getRadiologist(user.userId!);
    }
    role = user.role;
    if (role == 'Doctor') {
      _nameController.text = type.userName!;
      _genderController = type.gender;
      _contactController.text = type.contact;
      _descriptionController.text = type.description;
      _experienceController.text = type.experience;
      _specializationController.text = type.specialization;
      _feesController.text = type.fees;
      _timeController.text = type.time;
      _emailController.text = user.userEmail!;
      _imageController.text = type.image;
    }
    if (role == 'Patient' || role == 'Radiologist') {
      _nameController.text = type.userName!;
      _genderController = type.gender;
      _contactController.text = type.contact;
      _ageController.text = type.age;
      _emailController.text = user.userEmail!;
      _imageController.text = type.image;
    }
    id = _genderController == 'Male' ? 1 : 2;

    super.initState();
  }

  void updateDoctor() async {
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
      _imageController.text = url;
    }

    user.updateDoctor(
        context: context,
        email: _emailController.text,
        gender: _genderController,
        contact: _contactController.text,
        experience: _experienceController.text,
        specialization: _specializationController.text,
        description: _descriptionController.text,
        time: _timeController.text,
        fees: _feesController.text,
        image: _imageController.text,
        name: _nameController.text);
  }

  void updatePatient() async {
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
      _imageController.text = url;
    }

    user.updatePatient(
        context: context,
        email: _emailController.text,
        gender: _genderController,
        contact: _contactController.text,
        age: _ageController.text,
        image: _imageController.text,
        name: _nameController.text);
    setState(() {
      _isLoading = false;
    });
  }

  void updateRadiologist() async {
    // ignore: use_build_context_synchronously
    user.updateRadiologist(
        context: context,
        email: _emailController.text,
        gender: _genderController,
        contact: _contactController.text,
        age: _ageController.text,
        image: _imageController.text,
        name: _nameController.text);
  }

  @override
  void dispose() {
    _ageController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _experienceController.dispose();
    _feesController.dispose();
    _imageController.dispose();
    _nameController.dispose();
    _specializationController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return _isLoading
        ? CustomProgress(message: "Please wait while we update your profile...")
        : SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      radius: deviceSize.width * 0.20,
                      backgroundImage: _image == null
                          ? NetworkImage(_imageController.text) as ImageProvider
                          : FileImage(_image!),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _getImage(ImageSource.camera);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB9A0E6),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Text(
                            'Camera',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          _getImage(ImageSource.gallery);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB9A0E6),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Text(
                            'Gallery',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                      width: deviceSize.width * 0.85,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: decoration("Name", Icons.account_circle),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'League Spartan',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: deviceSize.width * 0.85,
                    child: TextFormField(
                      controller: _emailController,
                      enabled: false,
                      decoration: decoration("Email", Icons.email_outlined),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'League Spartan',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  if (role == 'Patient' || role == 'Radiologist')
                    const SizedBox(
                      height: 20,
                    ),
                  if (role == 'Patient' || role == 'Radiologist')
                    SizedBox(
                        width: deviceSize.width * 0.85,
                        child: TextFormField(
                          controller: _ageController,
                          decoration: decoration("Age", Icons.group_outlined),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'League Spartan',
                          ),
                          keyboardType: TextInputType.emailAddress,
                        )),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: deviceSize.width * 0.85,
                    child: TextFormField(
                      controller: _contactController,
                      decoration: decoration("Contact", Icons.phone_outlined),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'League Spartan',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (role == 'Doctor')
                    SizedBox(
                      width: deviceSize.width * 0.85,
                      child: TextFormField(
                        controller: _specializationController,
                        decoration: decoration(
                            "Specialization", Icons.app_registration_rounded),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'League Spartan',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  if (role == 'Doctor')
                    const SizedBox(
                      height: 20,
                    ),
                  if (role == 'Doctor')
                    SizedBox(
                      width: deviceSize.width * 0.85,
                      child: TextFormField(
                        controller: _experienceController,
                        decoration: decoration("Experience", Icons.badge),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'League Spartan',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  if (role == 'Doctor')
                    const SizedBox(
                      height: 20,
                    ),
                  if (role == 'Doctor')
                    SizedBox(
                      width: deviceSize.width * 0.85,
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: decoration(
                            "Description", Icons.app_registration_rounded),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'League Spartan',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  if (role == 'Doctor')
                    const SizedBox(
                      height: 20,
                    ),
                  if (role == 'Doctor')
                    SizedBox(
                      width: deviceSize.width * 0.85,
                      child: TextFormField(
                        controller: _feesController,
                        decoration: decoration("Fees", Icons.money),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'League Spartan',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  if (role == 'Doctor')
                    const SizedBox(
                      height: 20,
                    ),
                  if (role == 'Doctor')
                    SizedBox(
                        width: deviceSize.width * 0.85,
                        child: TextFormField(
                          controller: _timeController,
                          decoration:
                              decoration("Time", Icons.watch_later_outlined),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'League Spartan',
                          ),
                          keyboardType: TextInputType.emailAddress,
                        )),
                  if (role == 'Doctor')
                    const SizedBox(
                      height: 20,
                    ),
                  Container(
                    margin: EdgeInsets.only(left: deviceSize.width * 0.085),
                    child: Row(
                      children: [
                        Icon(Icons.group_outlined, color: primaryColor),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Gender",
                          style: TextStyle(
                            fontFamily: "League Spartan",
                            fontSize: deviceSize.width * 0.04,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: deviceSize.width * 0.06),
                    child: Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: id,
                          onChanged: (val) {
                            setState(() {
                              id = 1;
                              _genderController = 'Male';
                            });
                          },
                        ),
                        Text(
                          'Male',
                          style: TextStyle(
                            fontFamily: 'League Spartan',
                            fontSize: deviceSize.width * 0.04,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF696969),
                          ),
                        ),
                        Radio(
                          value: 2,
                          groupValue: id,
                          onChanged: (val) {
                            setState(() {
                              _genderController = 'Female';
                              id = 2;
                            });
                          },
                        ),
                        Text(
                          'Female',
                          style: TextStyle(
                            fontFamily: 'League Spartan',
                            fontSize: deviceSize.width * 0.04,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF696969),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        if (role == 'Doctor') {
                          if (_imageController.text == '') {
                            if (id == 1) {
                              _genderController = 'Male';
                            } else {
                              _genderController = 'Female';
                            }
                            _imageController.text = type.image;
                          }
                          updateDoctor();
                        } else if (role == 'Patient') {
                          if (_imageController.text == '') {
                            print(_imageController.text);
                            if (id == 1) {
                              _genderController = 'Male';
                            } else {
                              _genderController = 'Female';
                            }
                            _imageController.text = type.image;
                          }
                          updatePatient();
                        } else {
                          if (_imageController.text == '') {
                            print("_imageController.text");
                            if (id == 1) {
                              _genderController = 'Male';
                            } else {
                              _genderController = 'Female';
                            }
                            _imageController.text = type.image;
                          }
                          updateRadiologist();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xFFB9A0E6),
                              Color(0xFF8587DC),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: deviceSize.width * 0.85,
                          height: deviceSize.height * 0.065,
                          alignment: Alignment.center,
                          child: Center(
                            child: Text(
                              'Update Profile',
                              style: TextStyle(
                                fontSize: deviceSize.width * 0.048,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  InputDecoration decoration(name, icon) {
    return InputDecoration(
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: primaryColor)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400)),
      labelText: name,
      labelStyle: TextStyle(
        // fontFamily: 'League Spartan',
        fontSize: 16,
        color: Colors.grey.shade400,
        fontWeight: FontWeight.w600,
      ),
      floatingLabelStyle: TextStyle(color: primaryColor),
      prefixIconColor: primaryColor,
      prefixIcon: Icon(
        icon,
        // color: Colors.grey.shade400,
      ),
    );
  }
}
