import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:msf/common_graphics/buttons/common_filled_button.dart';
import 'package:msf/config/size_config.dart';
import 'package:msf/ectracted_details/extracted_details_screen.dart';
import 'package:msf/utils/color_consts.dart';
import 'package:msf/utils/image_picker.dart';
import 'package:msf/utils/ocr_service.dart';

class ScanOCRPage extends StatefulWidget {
  @override
  _ScanOCRPageState createState() => _ScanOCRPageState();
}

class _ScanOCRPageState extends State<ScanOCRPage> {
  final ImagePicker _picker = ImagePicker();
  String _recognizedTextValue = '';
  late final TextEditingController _searchController = TextEditingController();
  bool isLoaderShow = false;
  List<dynamic> _jsonData = [];
  List<dynamic> _searchResults = [];
  TextEditingController registerTextController = TextEditingController();
  String extractedTextValue = '';

  @override
  void initState() {
    super.initState();
    // _loadData();
  }

  // void _loadData() async {
  //   List<dynamic> jsonData = await loadJsonData();
  //   setState(() {
  //     _jsonData = jsonData;
  //     _searchResults = jsonData.cast<Map<String, dynamic>>();
  //   });
  // }

  // List<dynamic> searchItems(List<dynamic> items, String query) {
  //   final fuse = Fuzzy(
  //     items.map((item) => item.description).toList(),
  //     options: FuzzyOptions(
  //       findAllMatches: true,
  //       tokenize: true,
  //       threshold: 0.3,
  //     ),
  //   );
  //
  //   final result = fuse.search(query);
  //   return result.map((res) => items[res.item]).toList();
  // }

// Function to search data
//   List searchJson(List<dynamic> jsonData, String query) {
//     return jsonData.where((element) {
//       return element.values.any((value) => value.toString().toLowerCase().contains(query.toLowerCase()));
//     }).toList();
//   }

  // void _search(String query) {
  //   List results = searchJson(_jsonData, query);
  //   setState(() {
  //     _searchResults = results;
  //     print("_searchResults    $_searchResults");
  //   });
  // }

  XFile imageList = XFile('');

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageList = image;
      setState(() {});
      // _recognizeText(image);
    }
  }

  Future<void> captureImageNew() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      imageList = image;
      setState(() {});
    }
  }

  Future<void> _recognizeText(XFile image) async {
    _recognizedTextValue = '';
    setState(() {
      isLoaderShow = true;
    });
    final InputImage inputImage = InputImage.fromFilePath(image.path);
    final TextRecognizer textRecognizer = TextRecognizer();

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    setState(() {
      _recognizedTextValue = "$_recognizedTextValue\n${recognizedText.text}";
      print("_recognizedText    $_recognizedTextValue");
      isLoaderShow = false;
    });
    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: const Color(0xffD8D9DB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: GestureDetector(
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).padding.top),
            GestureDetector(
                onTap: () async {
                  final image = await MsfImagePicker.instance.pickImageFromGallery();
                  if (image != null) {
                    imageList = image;
                    setState(() {});
                  }
                },
                child: Text(
                  'Import from gallery',
                  style: GoogleFonts.monomaniacOne.call().copyWith(color: AppColorConsts.blackishGrey, fontSize: 18),
                )
                // Icon(
                //   Icons.qr_code_scanner,
                //   size: SizeConfig.screenWidth * 0.2,
                // ),
                ),
            const SizedBox(height: 22.0),
            GestureDetector(
                onTap: () async {
                  final image = await MsfImagePicker.instance.captureImage();
                  if (image != null) {
                    imageList = image;
                  }
                  setState(() {});
                },
                child: Text(
                  'Import from Camera',
                  style: GoogleFonts.monomaniacOne.call().copyWith(color: AppColorConsts.blackishGrey, fontSize: 18),
                )
                // Icon(
                //   Icons.qr_code_scanner,
                //   size: SizeConfig.screenWidth * 0.2,
                // ),
                ),
            const SizedBox(height: 22.0),
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
                    if (imageList.path.isNotEmpty)
                      ClipRRect(
                        child: Stack(
                          children: [
                            Image.file(
                              File(imageList.path),
                              height: 60,
                              width: 60,
                            ),
                            GestureDetector(
                              onTap: () {
                                imageList = XFile('');
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
            const SizedBox(height: 22.0),
            Row(
              children: [
                Expanded(
                  child: CommonFilledButton(
                    onPressed: imageList.path.isNotEmpty
                        ? () async {
                            if (imageList.path.isNotEmpty) {
                              _recognizedTextValue = await MsfOcrService.instance.recognizeText(imageList);
                              setState(() {});
                            }
                            extractedTextValue = _recognizedTextValue;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (cx) {
                                  return ExtractedDetailsScreen(extractedDetails: extractedTextValue);
                                },
                              ),
                            );
                          }
                        : null,
                    borderRadius: BorderRadius.circular(50),
                    buttonText: 'Submit'.toUpperCase(),
                  ),
                ),
              ],
            ),

            /// Rutuja Code
            // Row(
            //   children: [
            //     const Text("Extract Text "),
            //     Container(
            //       height: 150,
            //       width: (MediaQuery.of(context).size.width * 0.7) - 20.0,
            //       decoration: BoxDecoration(border: Border.all()),
            //       child: SingleChildScrollView(
            //         child: Text(
            //           _recognizedText,
            //           style: const TextStyle(fontSize: 16.0),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: TextFormField(
            //         controller: registerText,
            //       ),
            //     )
            //   ],
            // ),
            /// Rutuja Code
            // Padding(
            //   padding: const EdgeInsets.only(top: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       GestureDetector(
            //         onTap: () {
            //           if (_recognizedText.isNotEmpty) _search(_recognizedText);
            //         },
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            //           alignment: Alignment.center,
            //           decoration: BoxDecoration(
            //             color: Colors.blue,
            //             borderRadius: BorderRadius.circular(50.0),
            //           ),
            //           child: const Text(
            //             'Search',
            //             textAlign: TextAlign.center,
            //             style: TextStyle(color: Colors.white, fontSize: 18),
            //           ),
            //
            //           /* shape: RoundedRectangleBorder(
            //                               borderRadius: BorderRadius.circular(30)),
            //                           color: Colors.blue,*/
            //         ),
            //       ),
            //       GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             _recognizedText = "";
            //             _searchResults = [];
            //           });
            //         },
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            //           alignment: Alignment.center,
            //           decoration: BoxDecoration(
            //             color: Colors.blue,
            //             borderRadius: BorderRadius.circular(50.0),
            //           ),
            //           child: const Text(
            //             'Reset',
            //             textAlign: TextAlign.center,
            //             style: TextStyle(color: Colors.white, fontSize: 18),
            //           ),
            //
            //           /* shape: RoundedRectangleBorder(
            //                               borderRadius: BorderRadius.circular(30)),
            //                           color: Colors.blue,*/
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            /// Rutuja Code
            // const SizedBox(height: 20),
            // Row(
            //   children: [
            //     Expanded(
            //       child: CommonFilledButton(
            //         onPressed: () {
            //           if (_recognizedText.isNotEmpty) _search(_recognizedText);
            //         },
            //         borderRadius: BorderRadius.circular(50),
            //         buttonText: 'search'.toUpperCase(),
            //       ),
            //     )
            //   ],
            // ),
            // const SizedBox(height: 20),
            // Row(
            //   children: [
            //     Expanded(
            //       child: CommonFilledButton(
            //         onPressed: () {
            //           setState(() {
            //             _recognizedText = "";
            //             _searchResults = [];
            //           });
            //         },
            //         borderRadius: BorderRadius.circular(50),
            //         buttonText: 'Reset/check anothher'.toUpperCase(),
            //       ),
            //     )
            //   ],
            // ),
            /// Rutuja Code
            // const SizedBox(height: 20),
            // Row(
            //   children: [
            //     Expanded(
            //       child: CommonFilledButton(
            //         onPressed: () {
            //           Navigator.of(context).push(
            //             MaterialPageRoute(
            //               builder: (cx) =>  ExtractedDetailsScreen(
            //                 extractedDetails: 'Cefimix 200mg\n06   /   2024\n312022',
            //                 pictures: [
            //                   ...List.generate(imageList.length, (i){
            //                     return File(imageList[i].path);
            //                   })
            //                 ],
            //               ),
            //             ),
            //           );
            //         },
            //         borderRadius: BorderRadius.circular(50),
            //         buttonText: 'Extracted Details Page'.toUpperCase(),
            //       ),
            //     )
            //   ],
            // ),
            const SizedBox(height: 20),
            // Row(
            //   children: [
            //     Expanded(
            //       child: CommonFilledButton(
            //         onPressed: () {
            //           Navigator.of(context).push(
            //             MaterialPageRoute(
            //               builder: (cx) => const DetailsScreen(
            //                 medicineName: 'Cefimix 200mg',
            //                 expiryDate: '06   /   2024',
            //                 batchNo: '312022',
            //               ),
            //             ),
            //           );
            //         },
            //         borderRadius: BorderRadius.circular(50),
            //         buttonText: 'Details Page'.toUpperCase(),
            //       ),
            //     )
            //   ],
            // ),
            /// Search by Rutuja
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: _searchResults.length,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         title: Text(_searchResults[index].toString()),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

// Visibility(
//     visible: isLoaderShow,
//     child: Center(child: CircularProgressIndicator()))
}
