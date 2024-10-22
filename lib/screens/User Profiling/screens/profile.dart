import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/providers/doctor.dart';
import 'package:test/providers/auth.dart';
import 'package:test/providers/patient.dart';
import 'package:test/screens/User%20Profiling/widgets/profileInfo.dart';

import 'package:test/screens/User%20Profiling/screens/editProfile.dart';
import '../../../providers/radiologist.dart';

class Profile extends StatelessWidget {
  static const routeName = '/profile-screen';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    final type;

    if (user.role == 'Doctor') {
      type = Provider.of<Doctor>(context).getDoctor(user.userId!);
    } else if (user.role == 'Patient') {
      type = Provider.of<Patient>(context).getPatient(user.userId!);
    } else {
      type = Provider.of<Radiologist>(context).getRadiologist(user.userId!);
    }
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          //header
          const Align(
            alignment: Alignment.topRight,
            child: Image(
              image: AssetImage('assets/images/profileEclipse.png'),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 26.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_note_sharp),
                    color: Color(0xFF8587DC),
                    iconSize: 35,
                    onPressed: () {
                      Navigator.of(context).pushNamed(EditProfile.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: deviceSize.height * 0.09,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(type.image!),
                ),
                const SizedBox(
                  height: 30,
                ),
                Consumer<Auth>(
                  builder: ((context, val, _) => Column(
                        children: [
                          ProfileInfo("Name", val.userName),
                          const Divider(),
                          ProfileInfo("Email", val.userEmail),
                        ],
                      )),
                ),
                const Divider(),
                user.role == 'Patient'
                    ? ProfileInfo("Age", type.age)
                    : Container(),
                user.role == 'Doctor'
                    ? ProfileInfo("Specialization", type.specialization)
                    : Container(),
                const Divider(),
                ProfileInfo("Gender", type.gender),
                const Divider(),
                ProfileInfo("Contact", type.contact),
                const Divider(),
                user.role == 'Doctor'
                    ? ProfileInfo("Experience", type.experience + " yrs")
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
