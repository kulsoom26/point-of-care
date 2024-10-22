import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/constants/const.dart';
import 'package:test/widgets/backButton.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorialScreen extends StatefulWidget {
  static const routeName = '/tutorial-screen';

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            const Image(
              image: AssetImage('assets/images/eclipse.png'),
            ),
            // Title
            Container(
              margin: EdgeInsets.only(
                top: deviceSize.height * 0.095,
                left: deviceSize.width * 0.2,
              ),
              child: Text(
                'Tutorials',
                style: TextStyle(
                  color: const Color(0xff200E32).withOpacity(0.8),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                ),
              ),
            ),
            // Back Button
            backButton(context),
            Container(
              margin: EdgeInsets.only(
                top: deviceSize.height * 0.2,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  TutorialCard(
                    image: AssetImage('assets/images/doctor.jpeg'),
                    caption: 'Doctor Profile Tutorial',
                    youtubeLink: 'https://www.youtube.com/watch?v=rgbCcBNZcdQ',
                  ),
                  TutorialCard(
                    image: AssetImage('assets/images/patient.jpeg'),
                    caption: 'Patient Profile Tutorial',
                    youtubeLink: 'https://www.youtube.com/watch?v=rgbCcBNZcdQ',
                  ),
                  TutorialCard(
                    image: AssetImage('assets/images/doctor.jpeg'),
                    caption: 'Radiologist Profile Tutorial',
                    youtubeLink: 'https://www.youtube.com/watch?v=rgbCcBNZcdQ',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TutorialCard extends StatelessWidget {
  final ImageProvider image;
  final String caption;
  final String youtubeLink;

  const TutorialCard({
    required this.image,
    required this.caption,
    required this.youtubeLink,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launch(youtubeLink);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Image(
              image: image,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                caption,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
