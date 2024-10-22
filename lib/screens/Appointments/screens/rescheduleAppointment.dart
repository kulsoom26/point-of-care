import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:test/providers/appointment_services.dart';

class RescheduleAppointment extends StatefulWidget {
  RescheduleAppointment({super.key});
  static const routeName = '/reschedule-appointment';

  @override
  State<RescheduleAppointment> createState() => _RescheduleAppointmentState();
}

class _RescheduleAppointmentState extends State<RescheduleAppointment> {
  String selectedAge = '';
  List<String> age = [
    "0-10",
    "10-20",
    "20-30",
    "30-40",
    "40-50",
    "50-60",
    "60+"
  ];
  int id = 1;
  String radioButtonItem = 'Male';
  DateTime? selectedDate;
  String selectedTime = '';
  late AppointmentServices appointmentProvider;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    appointmentProvider = Provider.of<AppointmentServices>(context);
    super.initState();
  }

  void updateAppointment(String id, String userId, String doctorId) {
    appointmentProvider.updateAppointment(
      context: context,
      id: id,
      userId: userId,
      doctorId: doctorId,
      gender: radioButtonItem,
      contact: _contactController.text,
      reason: _reasonController.text,
      status: "confirmed",
      date: _dateController.text,
      time: selectedTime,
      name: _nameController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    String time = '9:00 A.M - 9:00 P.M';

    DateTime parseTime(String timeStr) {
      final parts = timeStr.split(' ');
      final timeParts = parts[0].split(':');
      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1]);

      if (parts[1] == 'P.M' && hours != 12) {
        hours += 12;
      } else if (parts[1] == 'A.M' && hours == 12) {
        hours = 0;
      }

      return DateTime(0, 1, 1, hours, minutes);
    }

    List<String> splitTimes = time.split(" - ");
    DateTime startTime = parseTime(splitTimes[0]);
    DateTime endTime = parseTime(splitTimes[1]);

    List<String> timeList = [];

    while (startTime.isBefore(endTime)) {
      timeList.add(DateFormat.jm().format(startTime));
      startTime = startTime.add(const Duration(minutes: 30));
    }
    timeList.add(DateFormat.jm().format(endTime));

    var appointment = appointmentProvider.singleAppointmentData;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            // Header Image
            const Image(
              image: AssetImage('assets/images/eclipse.png'),
            ),

            // Title
            Container(
              margin: EdgeInsets.only(
                top: deviceSize.height * 0.1,
                left: deviceSize.width * 0.2,
              ),
              child: Text(
                'Reschedule Appointment',
                style: TextStyle(
                  color: const Color(0xff200E32).withOpacity(0.8),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),

            // Back Button
            Container(
              margin: EdgeInsets.only(
                top: deviceSize.height * 0.09,
                left: deviceSize.width * 0.05,
              ),
              child: CupertinoNavigationBarBackButton(
                color: const Color(0xFF8587DC),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            // Form
            Container(
              height: deviceSize.height * 1.45,
              margin: EdgeInsets.only(
                top: deviceSize.width * 0.35,
                left: deviceSize.width * 0.05,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.account_circle_outlined,
                          color: Colors.grey),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Patient Name",
                        style: TextStyle(
                          fontFamily: "League Spartan",
                          fontSize: deviceSize.width * 0.04,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2, left: 6),
                    child: TextField(
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                        hintText: 'Enter patient name',
                        hintStyle: TextStyle(
                            fontSize: deviceSize.width * 0.035,
                            fontFamily: 'League Spartan',
                            color: Colors.black26),
                      ),
                      controller: _nameController,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.app_registration_rounded,
                          color: Colors.grey),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Select your age range",
                        style: TextStyle(
                          fontFamily: "League Spartan",
                          fontSize: deviceSize.width * 0.04,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: age.length,
                      itemBuilder: (context, index) {
                        final ageRange = age[index];
                        final isSelected = selectedAge == ageRange;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedAge = ageRange;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: deviceSize.width * 0.2,
                              child: Center(
                                child: Text(
                                  ageRange,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: deviceSize.width * 0.04,
                                    fontFamily: 'League Spartan',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.call, color: Colors.grey),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Contact Number",
                        style: TextStyle(
                          fontFamily: "League Spartan",
                          fontSize: deviceSize.width * 0.04,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2, left: 6),
                    child: TextField(
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                        hintText: 'Enter patient Contact number',
                        hintStyle: TextStyle(
                            fontSize: deviceSize.width * 0.035,
                            fontFamily: 'League Spartan',
                            color: Colors.black26),
                      ),
                      controller: _contactController,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.group, color: Colors.grey),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Gender",
                        style: TextStyle(
                          fontFamily: "League Spartan",
                          fontSize: deviceSize.width * 0.04,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            id = 1;
                            radioButtonItem = 'Male';
                          });
                        },
                      ),
                      Text(
                        'Male',
                        style: TextStyle(
                          fontFamily: 'League Spartan',
                          fontSize: deviceSize.width * 0.04,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF696969),
                        ),
                      ),
                      Radio(
                        value: 2,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'Female';
                            id = 2;
                          });
                        },
                      ),
                      Text(
                        'Female',
                        style: TextStyle(
                          fontFamily: 'League Spartan',
                          fontSize: deviceSize.width * 0.04,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF696969),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.grey),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Select the date for appointment",
                        style: TextStyle(
                          fontFamily: "League Spartan",
                          fontSize: deviceSize.width * 0.04,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: SfDateRangePicker(
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        setState(() {
                          selectedDate = args.value;
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(selectedDate!);
                          _dateController.text = formattedDate;
                        });
                      },
                      selectionMode: DateRangePickerSelectionMode.single,
                      minDate: DateTime.now(),
                      maxDate: DateTime(2040, 10, 20),
                      headerStyle: const DateRangePickerHeaderStyle(
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontFamily: 'League Spartan',
                        ),
                      ),
                      monthCellStyle: const DateRangePickerMonthCellStyle(
                        textStyle: TextStyle(
                          fontSize: 12,
                          fontFamily: 'League Spartan',
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.watch_later_outlined,
                          color: Colors.grey),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Select the time for appointment",
                        style: TextStyle(
                          fontFamily: "League Spartan",
                          fontSize: deviceSize.width * 0.04,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: timeList.length,
                      itemBuilder: (context, index) {
                        final timeSlot = timeList[index];
                        final isSelected = selectedTime == timeSlot;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedTime = timeSlot;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: deviceSize.width * 0.2,
                              child: Center(
                                child: Text(
                                  timeSlot,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: deviceSize.width * 0.04,
                                    fontFamily: 'League Spartan',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.note_add, color: Colors.grey),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Write reason for appointment",
                        style: TextStyle(
                          fontFamily: "League Spartan",
                          fontSize: deviceSize.width * 0.04,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Enter a reason',
                        hintStyle: TextStyle(
                          fontSize: deviceSize.width * 0.035,
                          fontFamily: 'League Spartan',
                          color: Colors.black26,
                        ),
                      ),
                      maxLines: 5,
                      controller: _reasonController,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        updateAppointment(appointment[0].id,
                            appointment[0].userId, appointment[0].doctorId);
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
                          width: deviceSize.width * 0.85,
                          height: deviceSize.height * 0.065,
                          alignment: Alignment.center,
                          child: Center(
                            child: Text(
                              'Set Appointment',
                              style: TextStyle(
                                fontSize: deviceSize.width * 0.048,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
