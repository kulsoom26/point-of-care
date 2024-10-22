// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test/constants/const.dart';
import '../utils/snack_bar_util.dart';
import 'package:http/http.dart' as http;

class FeedbackServices extends ChangeNotifier {
  void addFeedback({
    required BuildContext context,
    required String userId,
    required double rating,
    required String feedback,
  }) async {
    try {
      print(feedback);
      http.Response res = await http.post(
        Uri.parse('$nodeApi/api/users/addFeedback'),
        body: jsonEncode(
            {'userId': userId, 'feedback': feedback, 'rating': rating}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                content: Text("Feedback recieved, Thank you!"),
              );
            },
          );
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pop(context);
          Navigator.pushNamed(context, '/setting');
        },
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(error.toString()),
          );
        },
      );
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pop();
    }
  }
}
