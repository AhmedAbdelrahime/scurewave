import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:phishing_detection_app/core/secrets.dart';

Future<bool> isPhishingUrl(String url) async {
  const apiUrl =
      'https://safebrowsing.googleapis.com/v4/threatMatches:find?key=$safeBrowsingApiKey';
  final body = jsonEncode({
    'client': {'clientId': 'yourcompanyname', 'clientVersion': '1.0'},
    'threatInfo': {
      'threatTypes': [
        'MALWARE',
        'SOCIAL_ENGINEERING',
        'UNWANTED_SOFTWARE',
        'POTENTIALLY_HARMFUL_APPLICATION'
      ],
      'platformTypes': ['ANY_PLATFORM'],
      'threatEntryTypes': ['URL'],
      'threatEntries': [
        {'url': Uri.encodeFull(url)}
      ]
    }
  });

  if (kDebugMode) {
    print('Request body: $body');
  }

  final response = await http.post(Uri.parse(apiUrl), body: body, headers: {
    'Content-Type': 'application/json',
  });

  if (kDebugMode) {
    print('Response status: ${response.statusCode}');
  }
  if (kDebugMode) {
    print('Response body: ${response.body}');
  }

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    if (jsonResponse['matches'] != null && jsonResponse['matches'].isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } else {
    throw Exception('Failed to check URL');
  }
}
