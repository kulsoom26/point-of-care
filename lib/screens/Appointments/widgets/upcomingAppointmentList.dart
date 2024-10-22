import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/models/appointment.dart';
import 'package:test/providers/auth.dart';
import 'package:test/providers/doctor.dart';
import 'package:test/providers/appointment_services.dart';
import 'package:test/screens/Appointments/widgets/upcomingAppointmentCard.dart';

class UpcomingSchedule extends StatelessWidget {
  final bool flag;

  UpcomingSchedule({required this.flag});

  bool isUpcomingAppointment(List<Appointment> appointmentsList) {
    for (final appointment in appointmentsList) {
      if (appointment.status != 'confirmed') {
        continue;
      } else {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    final deviceSize = MediaQuery.of(context).size;

    final role = user.role;
    var appointmentsList =
        Provider.of<AppointmentServices>(context).appointmentsList;
    var doctorAppointments = appointmentsList
        .where((element) =>
            element.doctorId == user.userId && element.status == 'confirmed')
        .toList();

    var userAppointments = appointmentsList
        .where((element) =>
            element.userId == user.userId && element.status == 'confirmed')
        .toList();
    final doctor = Provider.of<Doctor>(context).doctors;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            role == 'Doctor'
                ? Container(
                    height: !flag ? deviceSize.height * .73 : 190,
                    child: doctorAppointments.length == 0
                        ? Center(
                            child: Text("No upcoming appointments yet."),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(top: 10),
                            scrollDirection:
                                flag ? Axis.horizontal : Axis.vertical,
                            itemCount: !flag ? doctorAppointments.length : 1,
                            itemBuilder: (context, index) {
                              final appointment = doctorAppointments[index];
                              final doc = doctor.firstWhere((element) =>
                                  element.userId == appointment.doctorId);
                              final us = user.users.firstWhere((element) =>
                                  element.userId == appointment.doctorId);
                              return appointment.status == 'confirmed'
                                  ? UpcomingAppointmentCard(
                                      us: us,
                                      doc: doc,
                                      appointment: appointment,
                                      flag: true,
                                    )
                                  : Container(
                                      child: Center(
                                        child: Text("No appointments yet."),
                                      ),
                                    );
                            }),
                  )
                : Container(
                    height: !flag ? deviceSize.height * .73 : 190,
                    child: userAppointments.length == 0
                        ? Center(
                            child: Text("No appointments yet."),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(top: 10),
                            scrollDirection:
                                flag ? Axis.horizontal : Axis.vertical,
                            itemCount: !flag ? userAppointments.length : 1,
                            itemBuilder: (context, index) {
                              final appointment = userAppointments[index];
                              final doc = doctor.firstWhere((element) =>
                                  element.userId == appointment.doctorId);
                              final us = user.users.firstWhere((element) =>
                                  element.userId == appointment.doctorId);
                              return appointment.status == 'confirmed'
                                  ? UpcomingAppointmentCard(
                                      us: us,
                                      doc: doc,
                                      appointment: appointment,
                                      flag: true,
                                    )
                                  : Container();
                            }))
          ],
        ));
  }
}
