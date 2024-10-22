import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/constants/const.dart';
import 'package:test/models/serviceItems.dart';
import 'package:test/providers/auth.dart';
import 'package:test/providers/doctor.dart';
import 'package:test/providers/patient.dart';
import 'package:test/providers/radiologist.dart';
import 'package:test/screens/Appointments/screens/availableDoctors.dart';
import 'package:test/screens/Diagnosis/screens/selectDiagnosis.dart';
import 'package:test/screens/Doctor%20Recommendation/screens/nearbyDoctors.dart';
import 'package:test/screens/Result%20and%20Reporting/screens/reportList.dart';
import 'package:test/screens/Main/widgets/categoryItems.dart';
import 'package:test/screens/Main/widgets/doctorsHomeGrid.dart';

import 'package:test/utils/customProgess.dart';

import 'package:test/widgets/title.dart';
import 'package:test/screens/Appointments/widgets/upcomingAppointmentList.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    final user = Provider.of<Auth>(context);
    final type;

    if (user.role == 'Doctor') {
      type = Provider.of<Doctor>(context).getDoctor(user.userId!);
    } else if (user.role == 'Patient') {
      type = Provider.of<Patient>(context).getPatient(user.userId!);
    } else {
      type = Provider.of<Radiologist>(context).getRadiologist(user.userId!);
    }
    setState(() {
      _isLoading = false;
    });

    final items = [
      Service("assets/images/diagnostic.png", "Diagnose\nNow",
          Colors.green.withOpacity(0.05), () {
        Navigator.of(context).pushNamed(SelectDiagnosis.routeName,
            arguments: {"type": type, "user": user});
      }),
      Service("assets/images/appointment.png", "Book\nAppointment",
          Colors.blue.withOpacity(0.05), () {
        Navigator.of(context).pushNamed(AvailableDoctorsScreen.routeName);
      }),
      Service("assets/images/location1.png", "Nearby\nDoctors",
          Colors.brown.withOpacity(0.05), () {
        Navigator.of(context).pushNamed(NearbyDoctors.routeName);
      }),
      Service("assets/images/report.png", "Reports",
          Colors.blueGrey.withOpacity(0.05), () {
        Navigator.of(context).pushNamed(ReportList.routeName);
      }),
    ];
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: _isLoading
              ? Center(
                  child: Image.asset(
                    "assets/images/heart-beat.gif",
                    height: 100,
                    width: 100,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(type.image!),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome 🎉',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.normal),
                            ),
                            Consumer<Auth>(
                              builder: (context, value, _) {
                                return Text(
                                  "${value.userName}",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                );
                              },
                            ),
                          ],
                        ),
                        trailing: Container(
                            decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(40)),
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => CustomProgress(
                                    message: "Please wait!",
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.notifications,
                                size: 26,
                                color: primaryColor,
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: TextFormField(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AvailableDoctorsScreen.routeName);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search for doctors...',
                          hintStyle: TextStyle(
                            fontFamily: 'League Spartan',
                            fontSize: 16,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w600,
                          ),
                          fillColor: const Color.fromARGB(255, 245, 245, 245),
                          filled: true,
                          border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                          suffixIcon: Icon(
                            Icons.search_outlined,
                            color: primaryColor,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'League Spartan',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 20),
                        height: 150,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              if (user.role == 'Doctor') {
                                return index != 0
                                    ? Container()
                                    : CategoryItem(
                                        items[index].image,
                                        items[index].label,
                                        items[index].color,
                                        items[index].onTap);
                              } else if (user.role == 'Radiologist') {
                                return index == 1 || index == 2
                                    ? Container()
                                    : CategoryItem(
                                        items[index].image,
                                        items[index].label,
                                        items[index].color,
                                        items[index].onTap);
                              } else {
                                return CategoryItem(
                                    items[index].image,
                                    items[index].label,
                                    items[index].color,
                                    items[index].onTap);
                              }
                            })),
                    SizedBox(
                      height: 20,
                    ),
                    user.role == "Radiologist"
                        ? Container()
                        : MainTitle("Upcoming Appointments"),
                    SizedBox(
                      height: 10,
                    ),
                    user.role == "Radiologist"
                        ? Container()
                        : UpcomingSchedule(flag: true),
                    SizedBox(
                      height: 20,
                    ),
                    user.role == "Patient"
                        ? MainTitle("Top Doctors")
                        : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    user.role == "Patient" ? DoctorsHomeGrid() : Container(),

                    // Container(
                    //   padding: EdgeInsets.only(left: 20),
                    //   height: 150,
                    //   child: ListView.builder(
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: 4,
                    //       itemBuilder: (context, index) => GestureDetector(
                    //           onTap: () {
                    //             Navigator.of(context).push(
                    //               MaterialPageRoute(
                    //                   builder: (context) => Diagnosis()),
                    //             );
                    //           },
                    //           child: ServiceItem(
                    //               items[index].image, items[index].label))),
                    // ),
                    SizedBox(
                      height: 30,
                    ),
                    // Container(height: 300, child: HomeGrid())

                    // MainTitle("Top Doctors"),
                    // DoctorsGrid()
                  ],
                ),
        ),
      ),
    );
  }
}
