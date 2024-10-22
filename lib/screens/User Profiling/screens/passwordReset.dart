// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/constants/const.dart';
import 'package:test/providers/auth.dart';

class PasswordReset extends StatefulWidget {
  static const routeName = '/password-reset';
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final TextEditingController _emailController = TextEditingController();

  void verifyEmailForPasswordRecover() {
    final auth = Provider.of<Auth>(context, listen: false);
    auth.verifyEmailForPasswordRecovery(
      context: context,
      email: _emailController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

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
                left: deviceSize.width * 0.2,
              ),
              child: Text(
                'Recover Password',
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
                  // TextFormField(
                  //   decoration: decoration("Email", Icons.mail),
                  //   style: const TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.w600,
                  //     fontFamily: 'League Spartan',
                  //   ),
                  //   obscureText: true,
                  //   controller: _emailController,
                  // ),
                  Center(
                    child: SizedBox(
                      width: deviceSize.width * 0.85,
                      child: Material(
                        elevation: 20,
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter you email',
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
                            prefixIcon: const Icon(Icons.mail),
                            prefixIconColor: Colors.black54,
                          ),
                          controller: _emailController,
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
                        verifyEmailForPasswordRecover();
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
                              'Validate Email',
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
