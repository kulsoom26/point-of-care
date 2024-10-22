// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/constants/const.dart';
import 'package:test/providers/auth.dart';
import 'package:test/providers/user_provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _CpasswordController = TextEditingController();
  String _errorMessage1 = '';

  void passwordReset(String email) {
    final auth = Provider.of<Auth>(context, listen: false);
    auth.passwordReset(
      context: context,
      email: email,
      password: _passwordController.text,
      confirmPassword: _CpasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            // Header Image
            const Image(
              image: AssetImage('assets/images/topWaves1.png'),
            ),

            // Title
            Container(
              margin: EdgeInsets.only(
                top: deviceSize.height * 0.1,
                left: deviceSize.width * 0.15,
              ),
              child: Text(
                'Reset Password',
                style: TextStyle(
                  color: const Color(0xff200E32).withOpacity(0.8),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                ),
              ),
            ),

            // Back Button
            Container(
              margin: EdgeInsets.only(
                top: deviceSize.height * 0.09,
                left: deviceSize.width * 0.05,
              ),
              child: CupertinoNavigationBarBackButton(
                color: const Color(0xFF8587DC),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            Container(
              height: deviceSize.height * 0.8,
              margin: EdgeInsets.only(
                top: deviceSize.width * 0.35,
                left: deviceSize.width * 0.05,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "To reset your password, please enter your valid registered email for OTP verification!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: deviceSize.width * 0.033,
                        color: Colors.black87,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: SizedBox(
                      width: deviceSize.width * 0.85,
                      child: Material(
                        elevation: 20,
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter your new password',
                            labelStyle: TextStyle(
                              fontFamily: 'League Spartan',
                              fontSize: deviceSize.width * 0.035,
                              fontWeight: FontWeight.w600,
                            ),
                            filled: true,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            contentPadding: EdgeInsets.fromLTRB(
                              deviceSize.width * 0.05,
                              deviceSize.height * 0.03,
                              deviceSize.width * 0.05,
                              deviceSize.height * 0.02,
                            ),
                            prefixIcon: const Icon(Icons.lock),
                            prefixIconColor: primaryColor,
                          ),
                          controller: _passwordController,
                          obscureText: true,
                          onChanged: (val) {
                            validatePass(val);
                          },
                          style: TextStyle(
                            fontSize: deviceSize.width * 0.04,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'League Spartan',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: deviceSize.height * 0.01),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        _errorMessage1,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: deviceSize.width * 0.03,
                          fontFamily: 'League Spartan',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: SizedBox(
                      width: deviceSize.width * 0.85,
                      child: Material(
                        elevation: 20,
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Confirm new password',
                            labelStyle: TextStyle(
                              fontFamily: 'League Spartan',
                              fontSize: deviceSize.width * 0.035,
                              fontWeight: FontWeight.w600,
                            ),
                            filled: true,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            contentPadding: EdgeInsets.fromLTRB(
                              deviceSize.width * 0.05,
                              deviceSize.height * 0.03,
                              deviceSize.width * 0.05,
                              deviceSize.height * 0.02,
                            ),
                            prefixIcon: const Icon(Icons.lock),
                            prefixIconColor: primaryColor,
                          ),
                          controller: _CpasswordController,
                          obscureText: true,
                          onChanged: (val) {
                            validatePass(val);
                          },
                          // onSaved: (val) {
                          //   validateConfirmPass(val!);
                          // },
                          style: TextStyle(
                            fontSize: deviceSize.width * 0.04,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'League Spartan',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        passwordReset(user.email);
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
                              'Reset Password',
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
          ],
        ),
      ),
    );
  }

  void validatePass(String val) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    var passNonNullValue = val;
    if (passNonNullValue.isEmpty) {
      setState(() {
        _errorMessage1 = "Password is required";
      });
    } else if (passNonNullValue.length < 6) {
      setState(() {
        _errorMessage1 = "Password Must be more than 5 characters";
      });
    } else if (!regex.hasMatch(passNonNullValue)) {
      setState(() {
        _errorMessage1 =
            "Password should contain upper,lower,digit and Special character";
      });
    } else {
      setState(() {
        _errorMessage1 = "";
      });
    }
  }
}
