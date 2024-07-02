import 'dart:developer';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MsfOcrService {
  MsfOcrService._();

  static final MsfOcrService instance = MsfOcrService._();

  Future<String> recognizeText(XFile image) async {
    String recognizedTextValue = '';
    final InputImage inputImage = InputImage.fromFilePath(image.path);
    final TextRecognizer textRecognizer = TextRecognizer();

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    recognizedTextValue = "$recognizedTextValue\n${recognizedText.text}";
    print("_recognizedText    $recognizedTextValue");
    textRecognizer.close();
    return recognizedTextValue;
  }

  String extractBatchNumber(String input) {
    final regex = RegExp(
      r'(Batch No\.|Batch|Lot|Batch\/Lot|Lot Number|Batch ID|Batch Code|Lot Code)\s*[:\s]*([\dA-Za-z]+)',
      caseSensitive: false,
    );
    final match = regex.firstMatch(input);
    if (match != null && match.groupCount >= 2) {
      return match.group(2)!;
    } else {
      return 'No batch number found';
    }
  }

  String extractExpiryDate(String input) {
    final regex = RegExp(
      r'(expiry|expirydate|expires|exp|exp date|use before|use by)\s*[:\s]*([\d]{2}[-/][\d]{2}[-/][\d]{4}|[\d]{4}[-/][\d]{2}[-/][\d]{2}|[\d]{2}[-/][\d]{4}|[\d]{2}[-/][\d]{4}|[\d]{2}[\s][\d]{4})',
      caseSensitive: false,
    );
    final matches = regex.allMatches(input);
    if (matches.isNotEmpty) {
      final lastMatch = matches.last.group(2);
      return _isValidDate(lastMatch!) ? lastMatch : 'Invalid date format';
    } else {
      return 'No expiry date found';
    }
  }


  bool _isValidDate(String date) {
    final dateFormats = [
      DateFormat('dd-MM-yyyy'),
      DateFormat('MM-dd-yyyy'),
      DateFormat('yyyy-MM-dd'),
      DateFormat('dd/MM/yyyy'),
      DateFormat('MM/dd/yyyy'),
      DateFormat('yyyy/MM/dd'),
      DateFormat('MM-yyyy'),
      DateFormat('MM yyyy'),
    ];

    for (var format in dateFormats) {
      try {
        format.parseStrict(date);
        return true;
      } catch (_) {}
    }
    return false;
  }
}
