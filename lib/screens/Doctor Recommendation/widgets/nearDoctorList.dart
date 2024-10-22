import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test/constants/const.dart';
import 'package:test/utils/customProgess.dart';
import 'package:test/utils/maps_utils.dart';

class NearDoctorList extends StatefulWidget {
  final String selectedValue;

  const NearDoctorList({required this.selectedValue, super.key});

  @override
  State<NearDoctorList> createState() => _NearDoctorListState();
}

class _NearDoctorListState extends State<NearDoctorList> {
  double? lat;
  double? long;
  String? address;
  var names = [];
  var images = [];
  var specialization = [];
  var degree = [];
  var waitTime = [];
  var exp = [];
  var satisfied = [];
  var location = [];
  var available = [];
  var fee = [];

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getLatLong() {
    Future<Position> data = _determinePosition();
    data.then((value) async {
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });
      List<Placemark> placemarks =
          await placemarkFromCoordinates(value.latitude, value.longitude);
      setState(() {
        address = placemarks[0].locality!;
      });
      String url;
      if (widget.selectedValue == 'Chest Diseases') {
        url = '$flaskApi/NearbyPulmonologistDoctors';
      } else if (widget.selectedValue == 'Liver Tumor') {
        url = '$flaskApi/NearbyHepatologistDoctors';
      } else if (widget.selectedValue == 'Kidney Tumor') {
        url = '$flaskApi/NearbyKidneyTumorDoctors';
      } else {
        url = '$flaskApi/NearbyBreastCancerDoctors';
      }
      final doctorData = await http.post(Uri.parse(url),
          body: json.encode(
              {'latitude': lat, 'longitude': long, 'address': address}));
      // final doctorData = await http.post(Uri.parse(url));
      final decoded = json.decode(doctorData.body) as Map<String, dynamic>;
      setState(() {
        names = decoded['Names'];
        images = decoded['Images'];
        specialization = decoded['Specialization'];
        degree = decoded['Degree'];
        waitTime = decoded['WaitTime'];
        exp = decoded['Experience'];
        satisfied = decoded['Satisfied'];
        location = decoded['location'];
        available = decoded['AvailableTime'];
        fee = decoded['Fee'];
      });
    }).catchError((error) {});
  }

  @override
  void initState() {
    super.initState();
    getLatLong();
  }

  void _showDoctorDetailsModal(int index, double deviceSize) {
    String firstPart = satisfied[index].split('%')[0];
    double satisfactionPercentage = double.tryParse(firstPart) ?? 0.0;
    double totalSize = 100.0;
    double itemSize = totalSize / 5;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: deviceSize,
          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: deviceSize * 0.03,
                  ),
                  color: const Color(0xFF8587DC),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -20.0),
                child: Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(
                      images[index],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Text(
                names[index],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Dr. ${names[index].split(' ')[1]} is ${specialization[index]}. This doctor has done ${degree[index]}.'
                ' For physical appointments, ${available[index]}.',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timer_sharp,
                        size: deviceSize * 0.03,
                        color: const Color(0xFF8587DC),
                      ),
                      Text(
                        ': ${waitTime[index]}',
                        style: const TextStyle(
                            fontFamily: 'Poppins', fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.money,
                        size: deviceSize * 0.03,
                        color: const Color(0xFF8587DC),
                      ),
                      Text(
                        ': ${fee[index]}',
                        style: const TextStyle(
                            fontFamily: 'Poppins', fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.badge,
                        size: deviceSize * 0.03,
                        color: const Color(0xFF8587DC),
                      ),
                      Text(
                        ': ${exp[index]}',
                        style: const TextStyle(
                            fontFamily: 'Poppins', fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: deviceSize * 0.03,
                    color: const Color(0xFF8587DC),
                  ),
                  Text(
                    ': ${location[index].split('(')[0]}',
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Text(
                    'Rating: ',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                  ),
                  RatingBarIndicator(
                    rating: (satisfactionPercentage / 20),
                    itemBuilder: (context, index) {
                      final isFilled =
                          index < (satisfactionPercentage / 20).floor();
                      return Icon(
                        isFilled ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    },
                    itemCount: 5,
                    itemSize: itemSize,
                    direction: Axis.horizontal,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    MapUtils.openMap(location[index]);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
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
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      width: deviceSize / 3,
                      height: deviceSize / 15,
                      alignment: Alignment.center,
                      child: const Center(
                        child: Text(
                          'Open Directions',
                          style: TextStyle(
                            fontSize: 16,
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double modalHeight = deviceSize.height * 0.8;

    return Align(
      alignment: Alignment.center,
      child: Builder(builder: (BuildContext context) {
        return names.isEmpty
            ? CustomProgress(
                message: "Please wait while we fetch doctors near you.",
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: deviceSize.width * 0.85,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: names.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        String satisfaction = satisfied[index];
                        String firstPart = satisfaction.split('%')[0];
                        double satisfactionPercentage =
                            double.tryParse(firstPart) ?? 0.0;
                        double totalSize = 100.0;
                        double itemSize = totalSize / 5;

                        return InkWell(
                          onTap: () {
                            _showDoctorDetailsModal(index, modalHeight);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(images[index]),
                                ),
                                Center(
                                  child: Text(
                                    names[index],
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  specialization[index].split(',')[0],
                                  style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 10,
                                  ),
                                ),
                                RatingBarIndicator(
                                  rating: (satisfactionPercentage / 20),
                                  itemBuilder: (context, index) {
                                    final isFilled = index <
                                        (satisfactionPercentage / 20).floor();
                                    return Icon(
                                      isFilled ? Icons.star : Icons.star_border,
                                      color: Colors.amber,
                                      size: 16,
                                    );
                                  },
                                  itemCount: 5,
                                  itemSize: itemSize,
                                  direction: Axis.horizontal,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
      }),
    );
  }
}
