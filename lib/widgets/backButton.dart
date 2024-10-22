import 'package:flutter/material.dart';

Widget backButton(context) {
  return Container(
    margin: const EdgeInsets.only(
      top: 70,
      left: 30,
    ),
    child: SizedBox(
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 30,
        ),
        color: const Color(0xFF8587DC),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
  );
}
