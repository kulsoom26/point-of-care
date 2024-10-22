import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:test/constants/const.dart';
import 'package:test/providers/appointment_services.dart';
import 'package:test/providers/auth.dart';
import 'package:test/providers/doctor.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:test/utils/snack_bar_util.dart';
import 'package:http/http.dart' as http;
import 'package:test/widgets/backButton.dart';

class DoctorDetail extends StatefulWidget {
  static const routeName = '/doctor-detail';
  Doctor doctor;
  final user;
  final flag1;
  DoctorDetail(this.doctor, this.user, this.flag1);

  @override
  State<DoctorDetail> createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetail> {
  DateTime? selectedDate;
  String selectedTime = '';
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  var appointmentService;
  bool _isLoading = false;
  bool flag = false;
  Map<String, dynamic>? paymentIntentData;
  var patient;

  @override
  void initState() {
    appointmentService =
        Provider.of<AppointmentServices>(context, listen: false);
    patient = Provider.of<Auth>(context, listen: false);
    super.initState();
  }

  displayPaymentSheet() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              merchantDisplayName: "Point-Of-Care",
              paymentIntentClientSecret: paymentIntentData!['client_secret']));
      await Stripe.instance.presentPaymentSheet();
      setState(() {
        paymentIntentData = null;
      });
      showSnackBar(context, "Paid successfully!");
      addAppointment(widget.doctor.userId!, patient.userId);
    } on StripeException catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e.toString());
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text("Cancelled."),
              ));
    }
  }

  calculateAmount(String amount) {
    final price = int.parse(amount) * 100;
    return price.toString();
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51OLPrsJlgl4sLrLcnH9Qid8FmH5q97cM9MwLO5sSfumgtxlWFhnGKss4IHOT3wKcpPzvbzyDCmUXwW12IcK74oJO00epPjgwkH",
            "Content-Type": "application/x-www-form-urlencoded"
          });
      return jsonDecode(response.body.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> makePayment() async {
    try {
      paymentIntentData =
          await createPaymentIntent(widget.doctor.fees.toString(), 'USD');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'US'),
              merchantDisplayName: "Point-Of-Care"));

      displayPaymentSheet();
    } catch (c) {
      print(c.toString());
    }
  }

  void addAppointment(String doctorId, String userId) {
    appointmentService.addAppointment(
        context: context,
        userId: userId,
        doctorId: doctorId,
        gender: widget.doctor.gender,
        contact: widget.doctor.contact,
        reason: _reasonController.text,
        status: "confirmed",
        date: _dateController.text,
        time: selectedTime,
        name: patient.userName,
        flag: widget.flag1);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    List<Map<String, String>> dataList = [
      {
        'imagePath': 'assets/images/contact.png',
        'title': widget.doctor.contact!,
        'detail': 'Contact',
      },
      {
        'imagePath': 'assets/images/exp.png',
        'title': "${widget.doctor.experience!}+",
        'detail': 'Years Exp.',
      },
      {
        'imagePath': 'assets/images/star.png',
        'title': '4.9+',
        'detail': 'Rating',
      },
    ];

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

    List<String> splitTimes = widget.doctor.time!.split("-");
    DateTime startTime = parseTime(splitTimes[0]);
    DateTime endTime = parseTime(splitTimes[1]);

    List<String> timeList = [];

// Generate time slots
    while (startTime.isBefore(endTime)) {
      timeList.add(DateFormat.jm().format(startTime));
      startTime = startTime.add(const Duration(minutes: 30));
    }

// Add the end time
    timeList.add(DateFormat.jm().format(endTime));
    return Scaffold(
      body: SingleChildScrollView(
        child: _isLoading
            ? Padding(
                padding: const EdgeInsets.only(top: 300.0),
                child: Center(
                  child: Image.asset(
                    "assets/images/heart-beat.gif",
                    height: 120,
                    width: 120,
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      backButton(context),
                      Container(
                        margin: EdgeInsets.only(
                          top: deviceSize.height * 0.08,
                        ),
                        child: Text(
                          'Book Appointment',
                          style: TextStyle(
                            color: const Color(0xff200E32).withOpacity(0.8),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: deviceSize.width * 0.06),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(widget.doctor.image!),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Dr. ${widget.user.username}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              widget.doctor.specialization!,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                const Image(
                                  image: AssetImage(
                                      'assets/images/description.png'),
                                  width: 15,
                                  height: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.doctor.description!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: deviceSize.height * 0.13,
                    width: deviceSize.width,
                    child: ListView.builder(
                      itemCount: dataList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: primaryColor.withOpacity(0.3),
                                child: Image(
                                  image:
                                      AssetImage(dataList[index]['imagePath']!),
                                  width: 25,
                                ),
                              ),
                              const SizedBox(height: 5),
                              FittedBox(
                                child: Text(
                                  dataList[index]['title']!,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: primaryColor),
                                ),
                              ),
                              Text(
                                dataList[index]['detail']!,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: deviceSize.width * 0.04),
                    child: const Text(
                      'Time',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 70,
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
                              borderRadius: BorderRadius.circular(30),
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
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: deviceSize.width * 0.04),
                    child: const Text(
                      'Date',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
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
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: deviceSize.width * 0.04),
                    child: const Text(
                      'Reason',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
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
                ],
              ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(deviceSize.width * 0.04),
        height: deviceSize.height * 0.16,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Consultation Fees",
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  "Rs ${widget.doctor.fees}/-",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedTime.isEmpty || _reasonController.text == '') {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text("Please fill all the fields!"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Okay"))
                              ],
                            ));
                    return;
                  }
                  await makePayment();
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
                        'Book Appointment',
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
            ),
          ],
        ),
      ),
    );
  }
}
