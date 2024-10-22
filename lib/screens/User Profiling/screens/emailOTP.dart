// ignore_for_file: file_names, prefer_const_constructors_in_immutables, use_build_context_synchronously, duplicate_ignore

import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/providers/user_provider.dart';
import './resetPassword.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EmailOtp extends StatefulWidget {
  static const routeName = '/otp';
  final EmailOTP myauth;
  EmailOtp({Key? key, required this.myauth}) : super(key: key);

  @override
  State<EmailOtp> createState() => _EmailOTPState();
}

class _EmailOTPState extends State<EmailOtp> {
  String otpPin = " ";
  // ignore: unused_field
  bool _isLoading = false;
  EmailOTP myauth = EmailOTP();

  void verifyOTP(EmailOTP myauth, String otp) async {
    setState(() {
      _isLoading = true;
    });
    if (await myauth.verifyOTP(otp: otp) == true) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP is verified"),
      ));

      setState(() {
        _isLoading = false;
      });
      final navigator = Navigator.of(context);
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const ResetPassword(),
        ),
        (route) => true,
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid OTP"),
      ));
    }
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
                left: deviceSize.width * 0.2,
              ),
              child: Text(
                'OTP Verification',
                style: TextStyle(
                  color: const Color(0xff200E32).withOpacity(0.8),
                  fontFamily: 'Trap',
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
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
                      'OTP Verification code has been sent to your registered email address ${user.email}',
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
                    height: 50,
                  ),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    onChanged: (value) {
                      setState(() {
                        otpPin = value;
                      });
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        otpPin.length >= 6
                            ? verifyOTP(widget.myauth, otpPin)
                            : showSnackBarText("Enter OTP correctly!");
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
                              'Verify OTP',
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

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
