import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:msf/common_graphics/buttons/common_filled_button.dart';
import 'package:msf/utils/color_consts.dart';
import 'package:msf/utils/image_picker.dart';
import 'package:msf/utils/ocr_service.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.medicineName});

  final String medicineName;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  XFile image = XFile('');
  final expiryController = TextEditingController();
  final batchNoController = TextEditingController();
  bool isEnable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConsts.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: AppColorConsts.lightDeepRed,
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: AppColorConsts.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      'Details',
                      style: GoogleFonts.monomaniacOne.call().copyWith(color: AppColorConsts.blackishGrey, fontSize: 22),
                    ),
                    const SizedBox(height: 32.0),
                    Text(
                      'Medicine name',
                      style: GoogleFonts.monomaniacOne.call().copyWith(color: AppColorConsts.lightPrimGrey, fontSize: 16),
                    ),
                    const SizedBox(height: 4.0),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                      decoration: BoxDecoration(color: AppColorConsts.lightestWhite, borderRadius: BorderRadius.circular(16.0)),
                      child: Text(
                        widget.medicineName,
                        style: GoogleFonts.monomaniacOne.call().copyWith(fontSize: 16, color: AppColorConsts.steel),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expiry date',
                                style:
                                    GoogleFonts.monomaniacOne.call().copyWith(color: AppColorConsts.lightPrimGrey, fontSize: 16),
                              ),
                              const SizedBox(height: 4.0),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                                decoration:
                                    BoxDecoration(color: AppColorConsts.lightestWhite, borderRadius: BorderRadius.circular(16.0)),
                                child: TextFormField(
                                  controller: expiryController,
                                  decoration: const InputDecoration(border: InputBorder.none),
                                  style: GoogleFonts.monomaniacOne.call().copyWith(fontSize: 16, color: AppColorConsts.steel),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Batch No.',
                                style:
                                    GoogleFonts.monomaniacOne.call().copyWith(color: AppColorConsts.lightPrimGrey, fontSize: 16),
                              ),
                              const SizedBox(height: 4.0),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                                decoration:
                                    BoxDecoration(color: AppColorConsts.lightestWhite, borderRadius: BorderRadius.circular(16.0)),
                                child: TextFormField(
                                  controller: batchNoController,
                                  decoration: const InputDecoration(border: InputBorder.none),
                                  style: GoogleFonts.monomaniacOne.call().copyWith(fontSize: 16, color: AppColorConsts.steel),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (image.path.isNotEmpty)
                      Align(
                        child: Container(
                          height: 80,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: AppColorConsts.lightestWhite,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (image.path.isNotEmpty)
                                ClipRRect(
                                  child: Stack(
                                    children: [
                                      Image.file(
                                        File(image.path),
                                        height: 60,
                                        width: 60,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          image = XFile('');
                                          isEnable =
                                              image.path.isNotEmpty && (expiryController.text.isNotEmpty) && (batchNoController.text.isNotEmpty);
                                          setState(() {});
                                        },
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                                          child: SizedBox(
                                            height: 60,
                                            width: 60,
                                            child: UnconstrainedBox(
                                              child: Image.asset(
                                                'assets/delete.png',
                                                height: 35,
                                                width: 35,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CommonFilledButton(
                    onPressed: isEnable ? () {} : null,
                    borderRadius: BorderRadius.circular(50),
                    buttonText: 'save'.toUpperCase(),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CommonFilledButton(
                    onPressed: () {},
                    borderRadius: BorderRadius.circular(50),
                    buttonText: 'Reset/check another'.toUpperCase(),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Align(
              child: GestureDetector(
                  onTap: () async {
                    final result = await MsfImagePicker.instance.captureImage();
                    if (result != null) {
                      image = result;
                      final text = await MsfOcrService.instance.recognizeText(image);
                      final expiryDate = MsfOcrService.instance.extractExpiryDate(text);
                      final batchNoDate = MsfOcrService.instance.extractBatchNumber(text);
                      expiryController.text = expiryDate;
                      batchNoController.text = batchNoDate;
                      isEnable =
                          image.path.isNotEmpty && (expiryController.text.isNotEmpty) && (batchNoController.text.isNotEmpty);
                      setState(() {});
                    }
                  },
                  child: Text(
                    'Import from camera'.toUpperCase(),
                    style: GoogleFonts.monomaniacOne.call().copyWith(color: AppColorConsts.blackishGrey, fontSize: 18),
                  )),
            ),
            const SizedBox(height: 20),
            Align(
              child: GestureDetector(
                  onTap: () async {
                    final result = await MsfImagePicker.instance.pickImageFromGallery();
                    if (result != null) {
                      image = result;
                      final text = await MsfOcrService.instance.recognizeText(image);
                      final expiryDate = MsfOcrService.instance.extractExpiryDate(text);
                      final batchNoDate = MsfOcrService.instance.extractBatchNumber(text);
                      expiryController.text = expiryDate;
                      batchNoController.text = batchNoDate;
                      isEnable =
                          image.path.isNotEmpty && (expiryController.text.isNotEmpty) && (batchNoController.text.isNotEmpty);
                      setState(() {});
                    }
                  },
                  child: Text(
                    'Import from gallery'.toUpperCase(),
                    style: GoogleFonts.monomaniacOne.call().copyWith(color: AppColorConsts.blackishGrey, fontSize: 18),
                  )),
            ),
            const SizedBox(height: 20),
            GestureDetector(
                onTap: () {},
                child: Text(
                  'Report'.toUpperCase(),
                  style: GoogleFonts.monomaniacOne.call().copyWith(color: AppColorConsts.blackishGrey, fontSize: 18),
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
