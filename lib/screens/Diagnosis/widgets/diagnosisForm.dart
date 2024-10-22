import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:test/screens/Diagnosis/screens/symptomsScreen.dart';
import 'package:test/widgets/inputDecoration.dart';
import 'package:test/widgets/myButton.dart';

class DiagnosisForm extends StatefulWidget {
  final user;
  final type;
  final dis;
  const DiagnosisForm(this.user, this.type, this.dis, {super.key});

  @override
  State<DiagnosisForm> createState() => _DiagnosisFormState();
}

class _DiagnosisFormState extends State<DiagnosisForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final Map<String, String> _authData = {
    'email': '',
    'contact': '',
    'name': '',
    'age': '',
  };

  String radioButtonItem = '';
  int id = 2;

  bool _nameActive = false;
  bool _emailActive = false;
  bool _contactActive = false;
  bool _ageActive = false;

  @override
  void initState() {
    print(widget.user.toString());
    _authData['email'] = widget.user.useremail;
    _authData['contact'] = widget.type.contact;
    _authData['name'] = widget.user.userName;
    _authData['age'] = widget.type.age;
    radioButtonItem = widget.type.gender;
    radioButtonItem == "Male" ? id = 1 : 2;

    _emailActive = true;
    _contactActive = true;

    super.initState();
  }

  String type = '';

  String _errorMessage = '';
  String _errorMessage1 = '';
  String _errorMessage2 = '';
  String _errorMessage3 = '';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      constraints: const BoxConstraints(minHeight: 320),
      width: deviceSize.width * 0.85,
      padding: EdgeInsets.all(deviceSize.width * 0.0427),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Heading
              Container(
                margin: EdgeInsets.only(
                  top: deviceSize.height * 0.135,
                  left: deviceSize.width * 0.0187,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Diagnosis',
                    style: TextStyle(
                      fontSize: deviceSize.width * 0.09,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // SubHeading
              Container(
                margin: EdgeInsets.only(
                  bottom: deviceSize.height * 0.025,
                  top: deviceSize.height * 0.005,
                  left: deviceSize.width * 0.0187,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Enter your personal details',
                    style: TextStyle(
                      fontSize: deviceSize.width * 0.032,
                      color: Colors.black38,
                      fontFamily: 'League Spartan',
                    ),
                  ),
                ),
              ),

              // name field
              FocusScope(
                child: Focus(
                  child: TextFormField(
                    decoration: decoration("Name", Icons.account_circle),
                    initialValue: _authData['name'],
                    style: TextStyle(
                      fontSize: deviceSize.width * 0.04,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'League Spartan',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) {
                      validateName(val);
                      _authData['name'] = val;
                    },
                    onSaved: (value) {
                      validateAge(value!);
                      _authData['name'] = value;
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: deviceSize.height * 0.0075),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    _errorMessage2,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: deviceSize.width * 0.034,
                      fontFamily: 'League Spartan',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              // Email field
              FocusScope(
                child: Focus(
                  child: TextFormField(
                    decoration: decoration("Email", Icons.email),
                    initialValue: _authData['email'],
                    onChanged: (val) {
                      validateEmail(val);
                      _authData['email'] = val;
                    },
                    onSaved: (value) {
                      validateAge(value!);
                      _authData['email'] = value;
                    },
                    style: TextStyle(
                      fontSize: deviceSize.width * 0.04,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'League Spartan',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: deviceSize.height * 0.0075),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: deviceSize.width * 0.034,
                      fontFamily: 'League Spartan',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              // Contact Field
              FocusScope(
                child: Focus(
                  child: TextFormField(
                    decoration: decoration("Contact", Icons.contact_phone),
                    initialValue: _authData['contact'],
                    style: TextStyle(
                      fontSize: deviceSize.width * 0.04,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'League Spartan',
                    ),
                    keyboardType: TextInputType.phone,
                    onSaved: (value) {
                      validateAge(value!);
                      _authData['contact'] = value;
                    },
                    onChanged: (val) {
                      validatePhone(val);
                      _authData['contact'] = val;
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: deviceSize.height * 0.0075),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    _errorMessage1,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: deviceSize.width * 0.034,
                      fontFamily: 'League Spartan',
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // Age
              FocusScope(
                child: Focus(
                  child: TextFormField(
                    decoration:
                        decoration("Age", Icons.supervisor_account_rounded),
                    initialValue: _authData['age'],
                    style: TextStyle(
                      fontSize: deviceSize.width * 0.04,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'League Spartan',
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _authData['age'] = value!;

                      validateAge(value);
                    },
                    onChanged: (val) {
                      _authData['age'] = val;

                      validateAge(val);
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: deviceSize.height * 0.0075),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    _errorMessage3,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: deviceSize.width * 0.034,
                      fontFamily: 'League Spartan',
                    ),
                  ),
                ),
              ),

              // Gender
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: deviceSize.height * 0.015,
                      left: deviceSize.width * 0.035,
                    ),
                    child: const Icon(
                      Icons.male_outlined,
                      color: Color(0xFF696969),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: deviceSize.width * 0.03,
                      top: deviceSize.height * 0.015,
                    ),
                    child: Text(
                      'Gender',
                      style: TextStyle(
                        fontFamily: 'League Spartan',
                        fontSize: deviceSize.width * 0.04,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF696969),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: deviceSize.height * 0.015),
                    child: Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: id,
                          onChanged: (val) {
                            setState(() {
                              radioButtonItem = 'Male';
                              id = 1;
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
                              radioButtonItem = 'Female';
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
                ],
              ),

              SizedBox(
                height: deviceSize.height * 0.03,
              ),

              // Next button
              Align(
                  alignment: Alignment.bottomRight,
                  child: myButton1(
                    () {
                      // _formKey.currentState!.save();
                      if (_authData['email'] != '' &&
                          _authData['name'] != '' &&
                          _contactActive &&
                          _emailActive &&
                          _authData['contact'] != '' &&
                          _authData['age'] != '') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                SymptomsScreen(widget.user, widget.dis),
                          ),
                        );
                      }
                    },
                    "Next",
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email can not be empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
      });
      setState(() {
        _emailActive = false;
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
      setState(() {
        _emailActive = true;
      });
    }
  }

  void validateName(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage2 = "Invalid Name";
      });
    } else {
      setState(() {
        _errorMessage2 = "";
      });
      setState(() {
        _nameActive = true;
      });
    }
  }

  void validatePhone(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage1 = "Invalid Number";
      });
    } else if (val.length < 10) {
      setState(() {
        _errorMessage1 = "Number can not be less than 11 digits";
      });
      setState(() {
        _contactActive = false;
      });
    } else {
      setState(() {
        _errorMessage1 = "";
      });
      setState(() {
        _contactActive = true;
      });
    }
  }

  void validateAge(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage3 = "Invalid Age";
      });
    } else if (int.parse(val) <= 0) {
      setState(() {
        _errorMessage3 = "Age cannot be 0 or less";
      });
    } else {
      setState(() {
        _errorMessage3 = "";
      });
      setState(() {
        _ageActive = true;
      });
    }
  }
}
