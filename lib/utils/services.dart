import 'dart:developer';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:msf/database/database_helper.dart';

class AppServices {
  AppServices._();

  static final AppServices instance = AppServices._();

  List<List<dynamic>> _csvData = [];

  Future<void> loadData() async {
    // final data = await rootBundle.load('assets/ANNEX_1_Unidat_DB_extract_small.xlsx');
    final data = await rootBundle.load('assets/ANNEX_1_Unidat_DB_extract_small.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      log(table); //sheet Name
      log((excel.tables[table]?.maxColumns).toString(), name: 'Columns');
      log((excel.tables[table]?.maxRows).toString(), name: 'Total horizontal');
      log(((excel.tables[table]?.rows)?.length).toString(), name: 'Total Excel Length');
      print("====started=====");
      for (int i = 1; i < (excel.tables[table]?.rows.length ?? 0); i++) {
        // final tempList = [];
        // for(int j = 0 ; j < (excel.tables[table]?.rows[i].length ?? 0); j++){
        //   tempList.add((excel.tables[table]?.rows[i][j]?.value).toString());
        // }
        if (i % 100 == 0) {
          print(i);
        }
        String title = (excel.tables[table]?.rows[i][1]?.value).toString() ?? '';
        await DatabaseHelper.instance.createItem(title, '', '');
        // tempList.add((excel.tables[table]?.rows[i][0]?.value).toString());
        // tempList.add((excel.tables[table]?.rows[i][1]?.value).toString());
        // tempList.add((excel.tables[table]?.rows[i][6]?.value).toString());
        // _csvData.add(tempList);
      }
      // print(excel.tables[table]?.rows[0][0]?.value.toString());
      // print(excel.tables[table]?.rows[0][1]?.value.toString());
      // print(excel.tables[table]?.rows[0][1]?.value.toString());
    }
    log('message ap');
    log(_csvData.length.toString(), name: 'CSV Data List Length');
  }

  Future<List<dynamic>> findClosestMatch(String query) async {
    // if (_csvData.isEmpty) {
    //   throw Exception("CSV data not loaded");
    // }

    final availableData = await DatabaseHelper.instance.getItems();

    // Define a list to store the top 5 matches and their scores
    List<Map<String, dynamic>> topMatches = [];

    // for (var i = 0; i < _csvData.length; i++) {
    for (var i = 0; i < availableData.length; i++) {
      // final description = _csvData[i][0]?.toString() ?? "";
      final description = availableData[i]['title']?.toString() ?? "";
      final score = ratio(query.toLowerCase(), description.toLowerCase());

      // If we have less than 5 matches, simply add the current match
      if (topMatches.length < 5) {
        topMatches.add({'description': description, 'score': score});
      } else if (score > topMatches.last['score']) {
        // If the current score is higher than the lowest score in the topMatches list, update the list
        topMatches.last['description'] = description;
        topMatches.last['score'] = score;
      }

      // Sort the topMatches list to keep the highest scores at the beginning
      topMatches.sort((a, b) => b['score'].compareTo(a['score']));
    }

    // Extract descriptions of the top 5 matches
    List<dynamic> closestMatches = topMatches.map((match) => match['description']).toList();

    log(closestMatches.toString(), name: 'Matches');
    // return closestMatches.join(";");  // Or return the list if needed
    return closestMatches;
  }
}
