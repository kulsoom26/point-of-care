import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:test/constants/const.dart';

import 'package:test/providers/auth.dart';
import 'package:test/providers/doctor.dart';
import 'package:test/providers/patient.dart';
import 'package:test/providers/radiologist.dart';
import 'package:http/http.dart' as http;
import 'package:test/utils/customProgess.dart';
import 'package:test/utils/labelColors.dart';

import 'package:test/utils/report_pdf.dart';
import 'package:test/utils/snack_bar_util.dart';

class ReportScreen extends StatefulWidget {
  static const routeName = '/report-screen';
  final report;
  ReportScreen(this.report);

  @override
  State<ReportScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ReportScreen> {
  bool flag = true;
  bool flag1 = false;
  late final image1;
  List percentages = [];
  List results = [];
  List<int>? bytes;
  File? image;
  var type;
  var user;
  List flags = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  void initState() {
    results = widget.report['results'];
    image1 = widget.report['image'];
    user = Provider.of<Auth>(context, listen: false);
    if (user.role == "Doctor") {
      type =
          Provider.of<Doctor>(context, listen: false).getDoctor(user.userId!);
    } else if (user.role == "Patient") {
      type =
          Provider.of<Patient>(context, listen: false).getPatient(user.userId!);
    } else {
      type = Provider.of<Radiologist>(context, listen: false)
          .getRadiologist(user.userId!);
    }

    super.initState();
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    page.graphics
        .drawString("Report", PdfStandardFont(PdfFontFamily.helvetica, 30));

    page.graphics.drawString(
        "Name: " + user.username, PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTRB(0, 50, 0, 0));

    page.graphics.drawString(
        "Age: " + type.age, PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTRB(0, 70, 0, 0));

    page.graphics.drawString(
        "Gender: " + type.gender, PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTRB(0, 90, 0, 0));

    page.graphics.drawString("Contact: " + type.contact,
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTRB(0, 110, 0, 0));

    page.graphics.drawImage(
        PdfBitmap(
          await imageUrlToUint8List(type.image!),
        ),
        const Rect.fromLTWH(300, 50, 150, 150));

    page.graphics.drawImage(
        PdfBitmap(
          await imageFileToUint8List(image!),
        ),
        Rect.fromLTWH(0, 300, 70, 70));
    page.graphics.drawString(
        "Original Image", PdfStandardFont(PdfFontFamily.helvetica, 7),
        bounds: const Rect.fromLTWH(0, 380, 150, 50));
    double left = 100;
    double top = 300;
    for (int i = 0; i < 14; i++) {
      page.graphics.drawImage(
          PdfBitmap(
            await imageFileToUint8List(image!),
          ),
          Rect.fromLTWH(left, top, 70, 70));
      page.graphics.drawImage(
          PdfBitmap.fromBase64String(results[i].values.first['heatmap']),
          Rect.fromLTWH(left, top, 70, 70));
      final MapEntry<String, dynamic> entry = results[i].entries.first;
      final String key = entry.key;
      page.graphics.drawString(
          entry.key +
              " = " +
              (results[i][key]['percentage'] * 100).round().toString() +
              "%",
          PdfStandardFont(PdfFontFamily.helvetica, 7),
          bounds: Rect.fromLTWH(left, top + 80, 150, 50));

      left = left + 100;
      if (left == 500) {
        left = 0;
        top = top + 130;
      }
    }

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

  void verifyReport() async {
    try {
      final response = await http.patch(
          Uri.parse(
              "https://point-of-care-4ad46-default-rtdb.firebaseio.com/reports/${widget.report['key']}.json"),
          body: json.encode({
            "results": widget.report['results'],
            "name": widget.report['name'],
            "time": widget.report['time'],
            "id": widget.report['id'],
            "image": widget.report['image'],
            "Verification": "Verified"
          }));
      final data = response.body;
      print(data.toString());
    } catch (c) {
      throw c;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: user.role == "Radiologist"
            ? GestureDetector(
                onTap: () {
                  verifyReport();
                  showSnackBar(context, 'Report verified');
                  Navigator.pop(context);
                },
                child: Container(
                  width: 150,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: primaryColor.withOpacity(0.8)),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        Text(
                          "Verify Report",
                          style: TextStyle(color: Colors.white),
                        )
                      ]),
                ),
              )
            : null,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 60,
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8, left: 12, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: primaryColor,
                            size: 20,
                          ),
                          Text(
                            "Back",
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
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
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
              ),
              SingleChildScrollView(
                // ignore: sized_box_for_whitespace
                child: Container(
                  height: deviceSize.height * 0.88,
                  width: deviceSize.width,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 0, bottom: 10),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: Image.memory(base64Decode(image1)),
                              ),
                              flags[0]
                                  ? Image.memory(base64Decode(
                                      results[0].values.first['heatmap']))
                                  : const SizedBox(),
                              flags[1]
                                  ? Image.memory(base64Decode(
                                      results[1].values.first['heatmap']))
                                  : const SizedBox(),
                              flags[2]
                                  ? Image.memory(base64Decode(
                                      results[2].values.first['heatmap']))
                                  : const SizedBox(),
                              flags[3]
                                  ? Image.memory(base64Decode(
                                      results[3].values.first['heatmap']))
                                  : const SizedBox(),
                              flags[4]
                                  ? Image.memory(base64Decode(
                                      results[4].values.first['heatmap']))
                                  : const SizedBox(),
                              flags[5]
                                  ? Image.memory(base64Decode(
                                      results[5].values.first['heatmap']))
                                  : const SizedBox(),
                              flags[6]
                                  ? Image.memory(base64Decode(
                                      results[6].values.first['heatmap']))
                                  : const SizedBox(),
                              flags[7]
                                  ? Image.memory(base64Decode(
                                      results[7].values.first['heatmap']))
                                  : const SizedBox(),
                              flags[8]
                                  ? Image.memory(base64Decode(
                                      results[8].values.first['heatmap']))
                                  : const SizedBox(),
                              flags[9]
                                  ? Image.memory(base64Decode(
                                      results[9].values.first['heatmap']))
                                  : const SizedBox(),
                              flags[10]
                                  ? Image.memory(base64Decode(
                                      results[10].values.first['heatmap']))
                                  : const SizedBox(),
                              flags[11]
                                  ? Image.memory(base64Decode(
                                      results[11].values.first['heatmap']))
                                  : const SizedBox(),
                              flags[12]
                                  ? Image.memory(base64Decode(
                                      results[12].values.first['heatmap']))
                                  : const SizedBox(),
                              flags[13]
                                  ? Image.memory(base64Decode(
                                      results[13].values.first['heatmap']))
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: deviceSize.width > 600 ? 2 : 1,
                          child: ListView.builder(
                            itemCount: 14,
                            itemBuilder: (context, position) {
                              final MapEntry<String, dynamic> entry =
                                  results[position].entries.first;
                              final String key = entry.key;

                              return Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: deviceSize.width * 0.9,
                                  child: Card(
                                      elevation: 18,
                                      color: flags[position]
                                          ? labelColors[key]
                                          : Colors.white,
                                      child: ListTile(
                                        titleAlignment:
                                            ListTileTitleAlignment.top,
                                        title: Text(
                                          key,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: flags[position]
                                                ? Colors.white
                                                : Colors.black,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          (results[position][key]
                                                              ['percentage'] *
                                                          100)
                                                      .round() >
                                                  70
                                              ? "Very Likely"
                                              : (results[position][key][
                                                                  'percentage'] *
                                                              100)
                                                          .round() >
                                                      35
                                                  ? "Uncertain"
                                                  : "Unlikely",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: flags[position]
                                                ? Colors.grey.shade300
                                                : Colors.black45,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        leading: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 8),
                                            child: IconButton(
                                              icon: flags[position]
                                                  ? const Icon(
                                                      Icons.remove_red_eye,
                                                      color: Colors.white,
                                                    )
                                                  : const Icon(Icons
                                                      .remove_red_eye_outlined),
                                              onPressed: () {
                                                setState(() {
                                                  flags[position] =
                                                      !flags[position];
                                                });
                                              },
                                              color: const Color(0xFF200e32),
                                            )),
                                        trailing: Container(
                                          margin:
                                              const EdgeInsets.only(top: 17),
                                          child: Text(
                                            "${(results[position][key]['percentage'] * 100).round()}%",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Poppins',
                                              color: flags[position]
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
