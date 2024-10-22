import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test/constants/const.dart';
import 'package:test/widgets/backButton.dart';
import 'package:test/widgets/inputDecoration.dart';
import 'package:test/widgets/myButton.dart';
import 'package:http/http.dart' as http;

class Retinopathy extends StatefulWidget {
  const Retinopathy({super.key});

  @override
  State<Retinopathy> createState() => _RetinopathyState();
}

class _RetinopathyState extends State<Retinopathy> {
  TextEditingController _ageController = TextEditingController();
  TextEditingController _sysController = TextEditingController();
  TextEditingController _diaController = TextEditingController();
  TextEditingController _cholesterolController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const Image(
              image: AssetImage('assets/images/eclipse.png'),
            ),
            Container(
              margin: EdgeInsets.only(left: 0.0, top: 50, right: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  'assets/images/authLogo.png',
                  height: 80,
                  width: 80,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                height: deviceSize.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Title(
                      color: Colors.black,
                      child: Text(
                        "Retinopathy Risk Score",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextField(
                      controller: _ageController,
                      decoration: decoration("Age", Icons.person),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _sysController,
                      decoration: decoration("Systole", Icons.arrow_upward),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _diaController,
                      decoration: decoration("Diastole", Icons.arrow_downward),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _cholesterolController,
                      decoration: decoration("Cholesterol", Icons.bloodtype),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    myButton("Diagnose", () async {
                      final response =
                          await http.post(Uri.parse('${flaskApi}/retinopathy'),
                              body: json.encode({
                                'user': [
                                  int.parse(_ageController.text),
                                  int.parse(_sysController.text),
                                  int.parse(_diaController.text),
                                  int.parse(_cholesterolController.text)
                                ]
                              }),
                              headers: {'Content-Type': 'application/json'});
                      showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                                title: Text(
                                  "Retinopathy",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: [
                                  Padding(
                                      padding: EdgeInsets.all(30),
                                      child: Text(response.body.toString()))
                                ],
                              ));
                    })
                  ],
                ),
              ),
            ),
            backButton(context),
          ],
        ),
      ),
    );
  }
}
