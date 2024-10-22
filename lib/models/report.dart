// ignore: file_names
import 'package:flutter/foundation.dart';

class Report with ChangeNotifier {
  final String id;
  final String name;
  final String result;
  final String date;

  Report({
    required this.id,
    required this.name,
    required this.result,
    required this.date,
  });
}
