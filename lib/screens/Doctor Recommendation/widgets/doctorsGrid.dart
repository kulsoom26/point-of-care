// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/constants/const.dart';
import 'package:test/providers/auth.dart';
import 'package:test/providers/doctor.dart';
import 'package:test/screens/Appointments/screens/doctorDetail.dart';

// ignore: use_key_in_widget_constructors
class DoctorsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var doctorProvider = Provider.of<Doctor>(context).doctors;
    final users = Provider.of<Auth>(context, listen: false).users;

    return Container(
      height: 400,
      margin: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.05,
      ),
      child: ListView.builder(
        itemCount: doctorProvider.length,
        itemBuilder: (context, index) {
          final doctor = doctorProvider[index];
          final user =
              users.firstWhere((element) => element.userId == doctor.userId);

          return GestureDetector(
            onTap: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => DoctorDetail(doctor, user, false)),
              );
            },
            child: Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 18),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(
                              doctor.image!), // Use the doctor's image URL
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dr. ${user.userName!}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 180,
                          child: Text(
                            "Online Consultation",
                            style: TextStyle(fontSize: 13),
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.watch_later,
                              color: Color(0xFF7165D6),
                              size: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 6),
                              child: Text(
                                doctor.time!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.black45),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: primaryColor,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
