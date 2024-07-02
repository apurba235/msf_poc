import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

// Function to load the JSON data
Future<List<dynamic>> loadJsonData() async {
  String jsonString = await rootBundle.loadString('assets/ANNEX_1_Unidat_DB_extract.json');
  print("jsonString    $jsonString");

  List<dynamic> jsonData = json.decode(jsonString);
  print("jsonData    $jsonData");

  return jsonData;
}
