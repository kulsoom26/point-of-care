import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:test/providers/auth.dart';
import 'package:test/utils/snack_bar_util.dart';

import 'package:test/widgets/myButton.dart';

import 'addProfile.dart';

class EmailOtp extends StatefulWidget {
  static const routeName = "email-otp";

  const EmailOtp({super.key});

  @override
  State<EmailOtp> createState() => _EmailOtpState();
}

class _EmailOtpState extends State<EmailOtp> {
  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;
  String otpPin = " ";
  bool _isLoading = false;

  void verifyOTP(String name, String email, String password, String role,
      EmailOTP myauth, String otp) async {
    setState(() {
      _isLoading = true;
    });
    if (await myauth.verifyOTP(otp: otp) == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP is verified"),
      ));

      Provider.of<Auth>(context, listen: false)
          .signup(name, email, password, role)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context)
            .pushNamed(DoctorProfile.routeName, arguments: {"role": role});
      }).catchError((c) {
        Navigator.of(context).pop();
        showSnackBar(context, c);
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid OTP"),
      ));
    }
  }

  Future<void> sendOTP(String email, EmailOTP myauth) async {
    myauth.setConfig(
        appEmail: "Hashir@POC.com",
        appName: "Point-Of-Care",
        userEmail: email,
        otpLength: 6,
        otpType: OTPType.digitsOnly);
    if (await myauth.sendOTP() == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP has been sent"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oops, OTP send failed"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottom = MediaQuery.of(context).viewInsets.bottom;

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final password = args['password'];
    final email = args['email'];
    final name = args['name'];
    final myauth = args['myauth'];
    final role = args['role'];

    print(name);

    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: screenHeight,
              width: screenWidth,
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  otp(email!),
                  myButton("Continue", () {
                    otpPin.length >= 6
                        ? verifyOTP(name, email, password, role, myauth, otpPin)
                        : showSnackBarText("Enter OTP correctly!");
                  })
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

  Widget otp(String email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              const TextSpan(
                  text: "We just sent a code to ",
                  style: TextStyle(color: Colors.black)),
              TextSpan(
                  text: email, style: const TextStyle(color: Colors.black)),
              const TextSpan(
                  text: "\nEnter the code here and we can continue!",
                  style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
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
        const SizedBox(
          height: 20,
        ),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                  text: "Didn't receive the code? ",
                  style: TextStyle(color: Colors.black)),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      //
                    });
                  },
                  child: const Text(
                    "Resend",
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
