// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';

class Feedback extends ChangeNotifier {
  final String userId;
  final String feedback;
  final double rating;

  Feedback({
    required this.userId,
    required this.feedback,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rating': rating,
      'feedback': feedback,
    };
  }

  factory Feedback.fromMap(Map<String, dynamic> map) {
    return Feedback(
      userId: map['userId'] ?? '',
      feedback: map['feedback'] ?? '',
      rating: map['rating'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());

  factory Feedback.fromJson(String source) =>
      Feedback.fromMap(json.decode(source));
}
