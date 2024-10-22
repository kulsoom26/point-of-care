// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/widgets/backButton.dart';

import '../widgets/nearDoctorList.dart';
import '../widgets/searchBar.dart';

class NearbyDoctors extends StatefulWidget {
  static const routeName = '/nearby-doctors-screen';

  const NearbyDoctors({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NearbyDoctorsState createState() => _NearbyDoctorsState();
}

class _NearbyDoctorsState extends State<NearbyDoctors> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedValue = "None";
  bool closeDialog = false;

  Widget _showDialogue(double deviceSize) {
    return Container(
      margin: EdgeInsets.only(top: deviceSize * 0.5, bottom: deviceSize * 0.5),
      child: Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Select the Preference",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Select the disease: ',
                    style: TextStyle(
                      fontFamily: 'League Spartan',
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: const Color(0xFF949494),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  DropdownButton(
                    value: selectedValue,
                    style: TextStyle(
                      color: const Color(0xFF8587DC),
                      fontSize: MediaQuery.of(context).size.width * 0.038,
                      fontFamily: 'League Spartan',
                    ),
                    items: dropdownItems,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (selectedValue != 'None') {
                  setState(() {
                    closeDialog = true;
                  });
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
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.height / 15,
                  alignment: Alignment.center,
                  child: const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double modalHeight = deviceSize.height * 0.8;
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
                top: deviceSize.height * 0.09,
                left: deviceSize.width * 0.2,
              ),
              child: Text(
                'Recommendation',
                style: TextStyle(
                  color: Color.fromARGB(255, 2, 2, 2).withOpacity(0.8),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
              ),
            ),

            // Back Button
            backButton(context),
            // Doctor grid
            Builder(
              builder: (BuildContext context) {
                return closeDialog
                    ? Container(
                        margin: EdgeInsets.only(top: deviceSize.height * 0.2),
                        child: NearDoctorList(selectedValue: selectedValue),
                      )
                    : _showDialogue(modalHeight);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "None", child: Text("None")),
      const DropdownMenuItem(
          value: "Chest Diseases", child: Text("Pulmonologist")),
      const DropdownMenuItem(value: "Liver Tumor", child: Text("Liver Tumor")),
      const DropdownMenuItem(
          value: "Kidney Tumor", child: Text("Kidney Tumor")),
      const DropdownMenuItem(
          value: "Breast Cancer", child: Text("Breast Cancer")),
    ];
    return menuItems;
  }
}
