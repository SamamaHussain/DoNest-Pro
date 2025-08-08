import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SummaryProvider extends ChangeNotifier {
  String? summary;
  final dio =Dio();
  bool isSummaryLoading = false;
  final url='https://api.apyhub.com/ai/summarize-url';
  Future<void> fetchSummary(String noteContent, String summaryLength, String output_language) async{
    isSummaryLoading = true;
    notifyListeners();
    try{
       final response = await dio.post(
        url,
        data: {
          'input': noteContent,
          'summary_length': summaryLength,
          'output_language': output_language,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'apy-token':   'APY0c0PNcCQxKEc0nYZo1r6mddh0eiA1g8Oh0xfrHNLIqqDRpzUwu3lsZZeN0ExnqSU3tt5uo2rp',

          }
        )
      );

      if(response.statusCode == 200) {
        summary = response.data['data']['summary'];
        dev.log('Summary fetched successfully: $response.$summary');
        notifyListeners();
      } else {
        summary ='Failed to fetch summary, Error Code: ${response.statusCode}';
      }
    }
    catch (e) {
      print('Error fetching summary: $e');
      summary = 'Failed to fetch summary';
    }
    isSummaryLoading = false;
    notifyListeners();

  }

}