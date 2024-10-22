import 'package:flutter/material.dart';

class MainTitle extends StatelessWidget {
  final String title;
  MainTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        title,
        style: const TextStyle(
            fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }
}
