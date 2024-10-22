import 'package:flutter/material.dart';
import 'package:test/constants/const.dart';

InputDecoration decoration(name, icon) {
  return InputDecoration(
    border: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: primaryColor)),
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
    labelText: name,
    labelStyle: TextStyle(
      // fontFamily: 'League Spartan',
      fontSize: 16,
      color: Colors.grey.shade400,
      fontWeight: FontWeight.w600,
    ),
    floatingLabelStyle: TextStyle(color: primaryColor),
    prefixIconColor: primaryColor,
    prefixIcon: Icon(
      icon,
      // color: Colors.grey.shade400,
    ),
  );
}
