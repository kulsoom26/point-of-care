import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:test/providers/results.dart';

import 'package:test/utils/customProgess.dart';
import 'package:test/widgets/myButton.dart';

class UploadOptions extends StatefulWidget {
  final dis;
  const UploadOptions(this.dis, {super.key});
  @override
  State<UploadOptions> createState() => _UploadOptionsState();
}

class _UploadOptionsState extends State<UploadOptions> {
  File? image;
  Map<String, dynamic>? results;
  var res;

  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var pickedImage = await picker.pickImage(source: media);
    if (pickedImage == null) return;

    final croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: false,
          ),
        ]);

    if (croppedImage == null) return;

    final croppedFile = File(croppedImage.path);

    setState(() {
      image = croppedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: deviceSize.width * 0.3,
              height: deviceSize.height * 0.15,
              child: DottedBorder(
                  borderType: BorderType.RRect,
                  dashPattern: const [5, 5],
                  color: Colors.grey,
                  strokeWidth: 2,
                  child: Center(
                    child: TextButton.icon(
                        icon: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.collections,
                              size: 35,
                              color: Colors.grey,
                            ),
                            Text('upload xray',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                        label: const Text(''),
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        }),
                  )),
            ),
            widget.dis == 'chest'
                ? SizedBox(
                    width: deviceSize.width * 0.3,
                    height: deviceSize.height * 0.15,
                    child: DottedBorder(
                        borderType: BorderType.RRect,
                        dashPattern: const [5, 5],
                        color: Colors.grey,
                        strokeWidth: 2,
                        child: Center(
                          child: TextButton.icon(
                              icon: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 35,
                                    color: Colors.grey,
                                  ),
                                  Text('Take Photo',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Poppins',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              ),
                              label: const Text(''),
                              onPressed: () {
                                getImage(ImageSource.camera);
                              }),
                        )),
                  )
                : Container(),
          ],
        ),
        // ignore: unnecessary_null_comparison
        const SizedBox(
          height: 20,
        ),
        image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Image.file(
                  //to show image, you type like this.
                  File(image!.path),
                  fit: BoxFit.cover,
                  // width: deviceSize.width * 0.7,
                  // height: deviceSize.height * 0.3,
                ),
              )
            : Container(),
        const SizedBox(
          height: 50,
        ),

        //next button
        myButton1(() async {
          showDialog(
              context: context,
              builder: (context) => CustomProgress(
                    message: "Please wait...\n(This might take 2-4 minutes)",
                  ));
          await Provider.of<Results>(context, listen: false)
              .diagnose(image, widget.dis)
              .then((_) {
            Navigator.pop(context);
            widget.dis == 'chest'
                ? Navigator.pushNamed(context, '/result-screen', arguments: {
                    'image': image!.path,
                    "results":
                        Provider.of<Results>(context, listen: false).result
                  })
                : widget.dis == 'breast'
                    ? showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                              title: const Text(
                                "Result",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 28),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    "Prediction: ${Provider.of<Results>(context, listen: false).breast}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              ],
                            ))
                    : showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                              title: const Text(
                                "Result",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 28),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    "Prediction: " +
                                        Provider.of<Results>(
                                          context,
                                          listen: false,
                                        ).kidney,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              ],
                            ));
          });
        }, "Submit")
      ],
    );
  }
}
