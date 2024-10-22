// ignore: file_names
import 'package:flutter/foundation.dart';

class DiseaseLabel with ChangeNotifier {
  final String id;
  final String name;
  final String percentage;
  final String likeness;

  DiseaseLabel(
      {required this.id,
      required this.name,
      required this.percentage,
      required this.likeness});
}
