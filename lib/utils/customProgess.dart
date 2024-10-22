import 'package:flutter/material.dart';

class CustomProgress extends StatelessWidget {
  final message;
  CustomProgress({required this.message});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(backgroundColor: Color(0xFFFCFCFF), children: [
      Container(
          margin: EdgeInsets.all(20),
          height: 130,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFCFCFF),
          ),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Image.asset("assets/images/heart-beat.gif")),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: FittedBox(child: Text(message)))
            ],
          )),
    ]);
  }
}
