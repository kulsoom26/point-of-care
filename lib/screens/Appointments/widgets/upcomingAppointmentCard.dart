import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:test/constants/const.dart';
import 'package:test/providers/appointment_services.dart';
import 'package:test/providers/auth.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class UpcomingAppointmentCard extends StatefulWidget {
  final us;
  final doc;
  final appointment;
  final flag;

  UpcomingAppointmentCard(
      {required this.us,
      required this.doc,
      required this.appointment,
      required this.flag});

  @override
  _UpcomingAppointmentCardState createState() =>
      _UpcomingAppointmentCardState();
}

class _UpcomingAppointmentCardState extends State<UpcomingAppointmentCard> {
  @override
  Widget build(BuildContext context) {
    RegExp regExp = RegExp(r"\s+");
    DateTime currentTime = DateTime.now();

    DateTime targetTime = DateTime(
      int.parse(widget.appointment.date.split("-")[2]),
      int.parse(widget.appointment.date.split("-")[1]),
      int.parse(widget.appointment.date.split("-")[0]),
      int.parse(widget.appointment.time.split(":")[0]),
      int.parse(widget.appointment.time.split(":")[1].split(regExp)[0]),
    );
    DateTime thirtyMinutesLater = targetTime.add(Duration(minutes: 30));

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
          ),
        ],
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(8, 2, 2, 8),
              title: widget.us.role == 'Patient'
                  ? Text(
                      'Dr. ${widget.us.userName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : Row(
                      children: [
                        Text(
                          widget.appointment.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        widget.flag
                            // &&
                            // currentTime.isAfter(targetTime) &&
                            // currentTime.isBefore(thirtyMinutesLater) &&
                            // currentTime.year == targetTime.year &&
                            // currentTime.month == targetTime.month &&
                            // currentTime.day == targetTime.day
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LiveCall(
                                              widget.appointment.id,
                                              widget.appointment.name)));
                                },
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(35)),
                                    child: Icon(
                                      Icons.call,
                                      size: 20,
                                      color: Colors.white,
                                    )),
                              )
                            : Container()
                      ],
                    ),
              subtitle: widget.appointment.status == 'completed' ||
                      widget.appointment.status == 'cancelled'
                  ? Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: widget.appointment.status == 'completed'
                                ? Colors.green
                                : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.appointment.status,
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    )
                  : widget.us.role == 'Patient'
                      ? Text(
                          "${widget.doc.specialization}",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w600),
                        )
                      : Text(
                          "${widget.appointment.reason}",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w600),
                        ),
              trailing: widget.appointment.status == 'confirmed'
                  ? _buildThreeDotsMenu(context)
                  : _buildRatingWidget(),
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(widget.doc.image!),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10)),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/calendar1.png",
                          height: 23,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.appointment.date,
                        ),
                      ],
                    ),
                    const VerticalDivider(
                      thickness: 1,
                      width: 12,
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/clock.png",
                          height: 23,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.appointment.time,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThreeDotsMenu(BuildContext context) {
    final user = Provider.of<Auth>(context);
    final appointmentServices = Provider.of<AppointmentServices>(context);

    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) {
        if (user.role == 'Patient') {
          return [
            PopupMenuItem(
              value: 'reschedule',
              child: ListTile(
                leading: Icon(
                  Icons.schedule,
                  color: Colors.blue,
                ),
                title: Text('Reschedule'),
              ),
            ),
            PopupMenuItem(
              value: 'cancelled',
              child: ListTile(
                leading: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                title: Text('Cancel'),
              ),
            ),
          ];
        } else {
          return [
            PopupMenuItem(
              value: 'completed',
              child: ListTile(
                leading: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: Text('Complete'),
              ),
            ),
            PopupMenuItem(
              value: 'cancelled',
              child: ListTile(
                leading: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                title: Text('Cancel'),
              ),
            ),
          ];
        }
      },
      onSelected: (value) {
        if (value == 'reschedule') {
          String id = widget.appointment.id;
          appointmentServices.getAppointmentInformation(
            context: context,
            id: id,
          );
        } else {
          if (value == 'completed') {
            appointmentServices.completeAppointment(
              context: context,
              id: widget.appointment.id,
              status: 'completed',
            );
          } else if (value == 'cancelled') {
            appointmentServices.cancelAppointment(
              context: context,
              id: widget.appointment.id,
              status: 'cancelled',
            );
          }
        }
      },
    );
  }

  Widget _buildRatingWidget() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Row(children: [
          Icon(
            Icons.star,
            size: 18,
            color: Colors.amber,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "5.0",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ]),
      ),
    );
  }
}

final String localUserID = math.Random().nextInt(100000).toString();

class LiveCall extends StatefulWidget {
  final callingId;
  final userName;
  const LiveCall(this.callingId, this.userName);

  @override
  State<LiveCall> createState() => _LiveCallState();
}

class _LiveCallState extends State<LiveCall> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ZegoUIKitPrebuiltCall(
            appID: 257183186,
            appSign:
                '0cd8ec8c4b7f99ea03ffb73d585c0ca5ebd9dc0b4aaaf511b22a412134d2a7d6',
            callID: widget.callingId,
            userID: localUserID,
            userName: widget.userName,
            config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              ..onOnlySelfInRoom = (context) => Navigator.pop(context)));
  }
}
