import 'package:flutter/material.dart';
import 'package:test/screens/Appointments/widgets/canceledAppointment.dart';

import 'package:test/screens/Appointments/widgets/completedAppointmentList.dart';

import 'package:test/screens/Appointments/widgets/upcomingAppointmentList.dart';

class ScheduleScreen extends StatefulWidget {
  static const routeName = '/appointment-schedule';

  const ScheduleScreen({Key? key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _buttonIndex = 0;

  final _scheduleWidgets = [
    UpcomingSchedule(flag: false),
    CompletedSchedule(flag: false),
    CanceledAppointment(flag: false),
  ];

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: deviceSize.height * 0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: deviceSize.width * 0.07,
                ),
                child: Title(
                  color: Colors.black,
                  child: const Text(
                    "Appointments",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                )),
            SizedBox(height: deviceSize.height * 0.02),
            Center(
              child: Container(
                width: deviceSize.width * 0.95,
                padding: const EdgeInsets.all(5),
                margin: EdgeInsets.only(left: deviceSize.width * 0.001),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _buttonIndex = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: deviceSize.height * 0.015,
                          horizontal: deviceSize.width * 0.05,
                        ),
                        decoration: BoxDecoration(
                          color: _buttonIndex == 0
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Upcoming",
                          style: TextStyle(
                            fontSize: 13 * textScaleFactor,
                            fontWeight: FontWeight.w500,
                            fontFamily:
                                'Poppins', // Set fontFamily to 'Poppins'
                            color: _buttonIndex == 0
                                ? Colors.white
                                : Colors.black38,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _buttonIndex = 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: deviceSize.height * 0.015,
                          horizontal: deviceSize.width * 0.05,
                        ),
                        decoration: BoxDecoration(
                          color: _buttonIndex == 1
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Completed",
                          style: TextStyle(
                            fontSize: 13 * textScaleFactor,
                            fontWeight: FontWeight.w500,
                            fontFamily:
                                'Poppins', // Set fontFamily to 'Poppins'
                            color: _buttonIndex == 1
                                ? Colors.white
                                : Colors.black38,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _buttonIndex = 2;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: deviceSize.height * 0.015,
                          horizontal: deviceSize.width * 0.05,
                        ),
                        decoration: BoxDecoration(
                          color: _buttonIndex == 2
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Cancelled",
                          style: TextStyle(
                            fontSize: 13 * textScaleFactor,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: _buttonIndex == 2
                                ? Colors.white
                                : Colors.black38,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _scheduleWidgets[_buttonIndex],
          ],
        ),
      ),
    );
  }
}
