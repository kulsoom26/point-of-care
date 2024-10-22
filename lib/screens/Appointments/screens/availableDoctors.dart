// ignore_for_file: file_names

import 'package:provider/provider.dart';
import 'package:test/providers/auth.dart';
import 'package:test/providers/doctor.dart';
import 'package:test/screens/Doctor%20Recommendation/widgets/doctorsGrid.dart';
import 'package:flutter/material.dart';
import 'package:test/widgets/backButton.dart';

class AvailableDoctorsScreen extends StatefulWidget {
  static const routeName = '/available-doctors';
  const AvailableDoctorsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AvailableDoctorsScreenState createState() => _AvailableDoctorsScreenState();
}

class _AvailableDoctorsScreenState extends State<AvailableDoctorsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    Provider.of<Doctor>(context, listen: false).fetchDoctors().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    Provider.of<Auth>(context, listen: false).fetchUsers();

    super.initState();
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

            // SearchBar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.only(left: 80, top: 70),
              width: deviceSize.width * 0.65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: deviceSize.width * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            // displayList = messagesProvider!
                            //     .where((element) => element.userName
                            //         .toLowerCase()
                            //         .contains(val.toLowerCase()))
                            //     .toList();
                          });
                        },
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
            backButton(context),
            Padding(
              padding: const EdgeInsets.only(top: 150.0, left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Title(
                    child: Text(
                      "Book appointment!",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    color: Colors.black,
                  ),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : DoctorsGrid(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
