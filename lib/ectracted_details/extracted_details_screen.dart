import 'dart:collection';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msf/common_graphics/buttons/common_filled_button.dart';
import 'package:msf/details/details_screen.dart';
import 'package:msf/utils/color_consts.dart';
import 'package:msf/utils/services.dart';

class ExtractedDetailsScreen extends StatefulWidget {
  const ExtractedDetailsScreen({super.key, required this.extractedDetails});

  final String extractedDetails;

  // final String extractedDetails;

  @override
  State<ExtractedDetailsScreen> createState() => _ExtractedDetailsScreenState();
}

class _ExtractedDetailsScreenState extends State<ExtractedDetailsScreen> {
  final detailsController = TextEditingController();

  List<dynamic> searchedList = [];
  bool listPopulated = false;

  @override
  void initState() {
    detailsController.text = widget.extractedDetails;
    super.initState();
  }

  @override
  void dispose() {
    detailsController.dispose();
    setState(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD8D9DB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
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
            const SizedBox(height: 32.0),
            // Align(
            //   child: Container(
            //     height: 80,
            //     width: 300,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(15.0),
            //       color: AppColorConsts.lightestWhite,
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         // ...List.generate(
            //         //   widget.pictures.length,
            //         //   (cx) {
            //         //     return Padding(
            //         //       padding: const EdgeInsets.only(right: 12.0),
            //         //       child: ClipRRect(
            //         //         child: Stack(
            //         //           children: [
            //         //             Image.file(
            //         //               widget.pictures[cx],
            //         //               height: 60,
            //         //               width: 60,
            //         //             ),
            //         //             // Image.asset(
            //         //             //   pictures[cx],
            //         //             //   height: 60,
            //         //             //   width: 60,
            //         //             // ),
            //         //             BackdropFilter(
            //         //               filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            //         //               child: SizedBox(
            //         //                 height: 60,
            //         //                 width: 60,
            //         //                 child: UnconstrainedBox(
            //         //                   child: Image.asset(
            //         //                     'assets/delete.png',
            //         //                     height: 35,
            //         //                     width: 35,
            //         //                     fit: BoxFit.fill,
            //         //                   ),
            //         //                 ),
            //         //               ),
            //         //             )
            //         //           ],
            //         //         ),
            //         //       ),
            //         //     );
            //         //   },
            //         // ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 28.0),
            Text(
              'Extracted details',
              style: GoogleFonts.monomaniacOne.call().copyWith(color: AppColorConsts.lightPrimGrey, fontSize: 16),
            ),
            const SizedBox(height: 4.0),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                decoration: BoxDecoration(color: AppColorConsts.lightestWhite, borderRadius: BorderRadius.circular(16.0)),
                child: TextFormField(
                  controller: detailsController,
                  decoration: const InputDecoration(border: InputBorder.none),
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  style: GoogleFonts.monomaniacOne.call().copyWith(fontSize: 16, color: AppColorConsts.steel),
                ),
              ),
            ),
            const SizedBox(height: 35),
            Row(
              children: [
                Expanded(
                  child: CommonFilledButton(
                    onPressed: () async {
                      setState(() {
                        listPopulated = true;
                      });
                      // await AppServices.instance.loadData();
                      searchedList = await AppServices.instance.findClosestMatch(detailsController.text);
                      setState(() {
                        listPopulated = false;
                      });
                    },
                    borderRadius: BorderRadius.circular(50),
                    buttonText: 'search'.toUpperCase(),
                  ),
                )
              ],
            ),
            // const SizedBox(height: 20),
            // Align(
            //   child: GestureDetector(
            //       onTap: () {},
            //       child: Text(
            //         'Import from gallery'.toUpperCase(),
            //         style: GoogleFonts.monomaniacOne.call().copyWith(color: AppColorConsts.blackishGrey, fontSize: 18),
            //       )),
            // ),
            const SizedBox(height: 20),
            // if (searchedList.isNotEmpty || listPopulated)
            Expanded(
              child: listPopulated
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                          margin: const EdgeInsets.only(bottom: 5.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColorConsts.lightDeepRed,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Title',
                                  style: GoogleFonts.monomaniacOne.call().copyWith(fontSize: 16, color: AppColorConsts.white),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Action',
                                  style: GoogleFonts.monomaniacOne.call().copyWith(fontSize: 16, color: AppColorConsts.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...List.generate(
                                searchedList.length,
                                (i) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                                    margin: const EdgeInsets.only(bottom: 5.0),
                                    decoration: BoxDecoration(
                                      color: AppColorConsts.steel,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            searchedList[i],
                                            style: GoogleFonts.monomaniacOne
                                                .call()
                                                .copyWith(fontSize: 16, color: AppColorConsts.white),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(builder: (cx) {
                                                  return DetailsScreen(medicineName: searchedList[i]);
                                                }),
                                              );
                                            },
                                            child: Text(
                                              'Next',
                                              style: GoogleFonts.monomaniacOne
                                                  .call()
                                                  .copyWith(fontSize: 16, color: AppColorConsts.lightDeepRed),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
