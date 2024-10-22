import 'package:flutter/material.dart';
import 'package:test/screens/Diagnosis/widgets/upload.dart';
import 'package:test/widgets/backButton.dart';

class UploadScreen extends StatelessWidget {
  static const routeName = '/upload-screen';
  final user;
  final dis;
  UploadScreen(this.user, this.dis);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          const Image(
            image: AssetImage('assets/images/eclipse.png'),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 0.0,
              top: 50,
              right: deviceSize.width * 0.0467,
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/images/authLogo.png',
                height: 80,
                width: 80,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: deviceSize.width > 600 ? 2 : 1,
                      child: Upload(dis),
                    ),
                  ],
                ),
              ),
            ),
          ),
          backButton(context)
        ],
      ),
    );
  }
}
