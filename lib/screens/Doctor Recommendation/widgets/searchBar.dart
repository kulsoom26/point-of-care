// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  final double topMargin; // Add a topMargin property
  final double width; // Add a width property
  final Color color;
  final double leftMargin; // Add a height property

  const Search({
    Key? key,
    required this.topMargin,
    required this.width,
    required this.color,
    required this.leftMargin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: leftMargin,
        top: topMargin,
      ),
      width: width,
      decoration: BoxDecoration(color: color, boxShadow: [
        BoxShadow(color: Color.fromARGB(255, 207, 207, 207), blurRadius: 15)
      ]),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Search',
          labelStyle: TextStyle(
            fontFamily: 'League Spartan',
            fontSize: deviceSize.width * 0.035,
            fontWeight: FontWeight.w600,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(
            deviceSize.width * 0.05,
            deviceSize.height * 0.03,
            deviceSize.width * 0.05,
            deviceSize.height * 0.02,
          ),
          prefixIcon: const Icon(Icons.search_outlined),
          prefixIconColor: Colors.black,
        ),
        style: TextStyle(
          fontSize: deviceSize.width * 0.04,
          fontWeight: FontWeight.w600,
          fontFamily: 'League Spartan',
        ),
      ),
    );
  }
}
