import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/constants/const.dart';
import 'package:test/providers/appointment_services.dart';
import 'package:test/providers/auth.dart';
import 'package:test/providers/doctor.dart';
import 'package:test/providers/patient.dart';
import 'package:test/providers/radiologist.dart';
import 'package:test/screens/Appointments/screens/scheduledAppointment.dart';
import 'package:test/screens/Chats/screens/MessageListScreen.dart';

import 'homeScreen.dart';
import '../../User Profiling/screens/profile.dart';
import '../../Feedback and Settings/screens/setting.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tab-screen';
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  bool _isLoading = true;
  var auth;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    auth = Provider.of<Auth>(context, listen: false);
    auth.fetchUsers();
    Provider.of<Doctor>(context, listen: false).fetchDoctors();
    Provider.of<Patient>(context, listen: false).fetchPatients();
    Provider.of<Radiologist>(context, listen: false).fetchRadiologists();
    Provider.of<AppointmentServices>(context, listen: false)
        .getAppointments(context: context)
        .then((value) => setState(() {
              _isLoading = false;
            }));

    super.initState();
  }

  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = auth.role == "Radiologist"
        ? [
            Profile(),
            HomeScreen(),
            const SettingScreen(),
          ]
        : [
            Profile(),
            const ScheduleScreen(),
            HomeScreen(),
            const MessagesScreen(),
            const SettingScreen(),
          ];
    return Scaffold(
      // drawer: AppDrawer(),
      backgroundColor: const Color(0xFFFCFCFF),
      body: _isLoading
          ? Center(
              child: Image.asset(
                "assets/images/heart-beat.gif",
                height: 100,
                width: 100,
              ),
            )
          : widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
            color: primaryColor, fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(
            color: Colors.grey.shade300,
            fontSize: 10,
            fontWeight: FontWeight.bold),
        iconSize: 30,
        items: auth.role == 'Radiologist'
            ? [
                BottomNavigationBarItem(
                    icon: Image.asset(
                      _selectedIndex == 0
                          ? "assets/images/profile_on.png"
                          : "assets/images/profile_off.png",
                      height: 25,
                    ),
                    label: "Profile"),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      _selectedIndex == 1
                          ? "assets/images/home_on.png"
                          : "assets/images/home_off.png",
                      height: 28,
                    ),
                    label: "Home"),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      _selectedIndex == 2
                          ? "assets/images/settings_on.png"
                          : "assets/images/settings_off.png",
                      height: 25,
                    ),
                    label: "Settings"),
              ]
            : [
                BottomNavigationBarItem(
                    icon: Image.asset(
                      _selectedIndex == 0
                          ? "assets/images/profile_on.png"
                          : "assets/images/profile_off.png",
                      height: 25,
                    ),
                    label: "Profile"),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      _selectedIndex == 1
                          ? "assets/images/calendar1.png"
                          : "assets/images/calendar_off.png",
                      height: 25,
                    ),
                    label: "Appointments"),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      _selectedIndex == 2
                          ? "assets/images/home_on.png"
                          : "assets/images/home_off.png",
                      height: 28,
                    ),
                    label: "Home"),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      _selectedIndex == 3
                          ? "assets/images/chat_on.png"
                          : "assets/images/chat_off.png",
                      height: 25,
                    ),
                    label: "Chat"),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      _selectedIndex == 4
                          ? "assets/images/settings_on.png"
                          : "assets/images/settings_off.png",
                      height: 25,
                    ),
                    label: "Settings"),
              ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
