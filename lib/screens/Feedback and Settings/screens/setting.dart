// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/providers/auth.dart';
import 'package:test/screens/Feedback%20and%20Settings/screens/Faq.dart';
import 'package:test/screens/Feedback%20and%20Settings/screens/Feedback.dart';
import 'package:test/screens/Feedback%20and%20Settings/screens/Tutorial.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = '/setting';
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Material(
      child: Stack(
        children: [
          const Image(
            image: AssetImage('assets/images/eclipse.png'),
          ),

          // Title
          Container(
            margin: EdgeInsets.only(
              top: deviceSize.height * 0.09,
              left: deviceSize.width * 0.15,
            ),
            child: Text(
              'Settings',
              style: TextStyle(
                color: const Color(0xff200E32).withOpacity(0.8),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 34,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: deviceSize.width * 0.05,
              vertical: deviceSize.height * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: deviceSize.height * 0.13),
                buildListTile(
                  context: context,
                  icon: Icons.question_mark,
                  text: "FAQ",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FAQScreen(),
                      ),
                    );
                  },
                  deviceSize: deviceSize,
                  textScaleFactor: textScaleFactor,
                ),
                SizedBox(height: deviceSize.height * 0.02),
                buildListTile(
                  context: context,
                  icon: Icons.privacy_tip_outlined,
                  text: "Feedback",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FeedbackScreen(),
                      ),
                    );
                  },
                  deviceSize: deviceSize,
                  textScaleFactor: textScaleFactor,
                ),
                SizedBox(height: deviceSize.height * 0.02),
                buildListTile(
                  context: context,
                  icon: Icons.play_arrow_outlined,
                  text: "Tutorials",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TutorialScreen(),
                      ),
                    );
                  },
                  deviceSize: deviceSize,
                  textScaleFactor: textScaleFactor,
                ),
                SizedBox(height: deviceSize.height * 0.02),
                buildListTile(
                  context: context,
                  icon: Icons.logout,
                  text: "Log Out",
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                  deviceSize: deviceSize,
                  textScaleFactor: textScaleFactor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListTile buildListTile({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Size deviceSize,
    required double textScaleFactor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(deviceSize.width * 0.03),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 34,
        ),
      ),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20 * textScaleFactor,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
    );
  }
}
