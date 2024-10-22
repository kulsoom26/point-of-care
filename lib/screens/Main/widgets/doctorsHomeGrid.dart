// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/constants/const.dart';
import 'package:test/providers/auth.dart';
import 'package:test/providers/doctor.dart';
import 'package:test/screens/Appointments/screens/doctorDetail.dart';
// import 'package:test/screens/doctorDetail.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:test/services/appointment_services.dart';

// ignore: use_key_in_widget_constructors
class DoctorsHomeGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var doctorProvider = Provider.of<Doctor>(context).doctors;
    final users = Provider.of<Auth>(context, listen: false).users;

    // AppointmentServices appointmentServices = AppointmentServices();
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: doctorProvider.length,
        itemBuilder: (context, index) {
          final doctor = doctorProvider[index];
          final user =
              users.firstWhere((element) => element.userId == doctor.userId);

          return GestureDetector(
            onTap: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => DoctorDetail(doctor, user, true)),
              );
            },
            child: Container(
              width: 160,
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(blurRadius: 15, color: Colors.black12)
                  ]),
              child: Column(
                children: [
                  CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        doctor.image!,
                      )), // Use the doctor's image URL

                  const SizedBox(height: 10),
                  FittedBox(
                    child: Text(
                      "Dr. ${user.userName!}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  FittedBox(
                    child: SizedBox(
                      child: Text(
                        doctor.specialization!,
                        softWrap: true,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow[700],
                        size: 14,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 2, right: 6),
                        child: Text(
                          "4.0",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        width: 50,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Row(
                            children: [
                              Text(
                                "Rs. ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                              ),
                              Text(
                                "${doctor.fees}",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
