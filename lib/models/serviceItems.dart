import 'package:flutter/material.dart';

class Service {
  String image;
  String label;
  Color color;
  VoidCallback onTap;

  Service(this.image, this.label, this.color, this.onTap);
}
