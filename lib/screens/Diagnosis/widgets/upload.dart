import 'package:flutter/material.dart';
import 'uploadOptions.dart';

class Upload extends StatefulWidget {
  final dis;
  Upload(this.dis);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final double headingFontSize = deviceSize.width * 0.08;
    final double subHeadingFontSize = deviceSize.width * 0.04;
    final double marginSize = deviceSize.width * 0.02;

    return Container(
      constraints: BoxConstraints(minHeight: deviceSize.height * 0.444),
      width: deviceSize.width * 0.85,
      padding: EdgeInsets.all(deviceSize.width * 0.04),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Heading
            Container(
              margin: EdgeInsets.only(
                top: deviceSize.height * 0.12,
                left: marginSize,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.dis == 'chest'
                      ? 'Chest Diagnosis'
                      : widget.dis == 'breast'
                          ? "Breast Diagnosis"
                          : "Kidney Diagnosis",
                  style: TextStyle(
                    fontSize: headingFontSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // SubHeading
            Container(
              margin: EdgeInsets.only(
                bottom: deviceSize.height * 0.025,
                top: deviceSize.height * 0.0075,
                left: marginSize,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Upload file',
                  style: TextStyle(
                    fontSize: subHeadingFontSize,
                    color: Colors.black38,
                    fontFamily: 'League Spartan',
                  ),
                ),
              ),
            ),

            UploadOptions(widget.dis),
          ],
        ),
      ),
    );
  }
}
