import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:test/constants/const.dart';
import 'package:test/utils/customProgess.dart';
import 'package:test/utils/report_pdf.dart';
import 'package:test/utils/snack_bar_util.dart';

class BreastResult extends StatelessWidget {
  BreastResult({super.key});

  List<int>? bytes;

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    bytes = await document.save();
    document.dispose();
  }

  Future<List<int>> imageFileToUint8List(File file) async {
    final bytes = await file.readAsBytes();
    final uint8List = Uint8List.fromList(bytes);
    return uint8List;
  }

  Future<List<int>> imageUrlToUint8List(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Uint8List.fromList(response.bodyBytes);
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            width: 40,
          ),
          GestureDetector(
            onTap: () {
              showSnackBar(
                  context, "Your report has been sent for verification!");
            },
            child: Container(
                width: 100,
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: primaryColor.withOpacity(.8)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Verify",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                )),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => CustomProgress(
                        message:
                            "Please wait, your document is being prepared!",
                      ));
              await _createPDF().then((value) => Navigator.of(context).pop());
              saveAndShareFile(bytes!, "report.pdf");
            },
            child: Container(
              width: 100,
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: primaryColor.withOpacity(.8)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Share",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )
                ],
              ),
            ),
          )
        ]),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
          Container(
            height: 60,
            padding:
                const EdgeInsets.only(top: 8.0, bottom: 8, left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    int count = 0;
                    Navigator.popUntil(context, (route) => count++ >= 4);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: primaryColor,
                        size: 20,
                      ),
                      Text(
                        "Home",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Result',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                ),
                IconButton(
                  disabledColor: Colors.grey,
                  icon: Icon(
                    Icons.download,
                    size: 30,
                    color: primaryColor,
                  ),
                  onPressed: () async {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => CustomProgress(
                              message:
                                  "Please wait, your document is being prepared!",
                            ));
                    await _createPDF()
                        .then((value) => Navigator.of(context).pop());

                    saveAndLaunchFile(bytes!, 'Report.pdf');
                  },
                  color: const Color(0xFF200e32),
                )
              ],
            ),
          )
        ]))));
  }
}
