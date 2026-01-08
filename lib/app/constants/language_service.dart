import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'appconstant.dart';

class LanguageApiService {
  static final box = GetStorage();

  static Future<void> changeLanguage(String languageCode) async {
    print(languageCode);
    try {
      final token = box.read('loginToken');
      if (token == null) {
        throw Exception('No login token found');
      }

      final Uri url = Uri.parse(
        '${AppConstants.baseUrl}/auth/change_language/$languageCode/',
      );

      final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // ✅ Success
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          final jsonData = jsonDecode(response.body);
          print('🌍 Language updated successfully → $jsonData');
        } else {
          print('🌍 Language updated successfully');
        }
      }
      // ❌ Backend error
      else {
        print(
          '❌ Failed to update language '
              '[${response.statusCode}] → ${response.body}',
        );
      }
    } catch (e, stackTrace) {
      print('🚨 Language API error: $e');
      print(stackTrace);
    }
  }
}
