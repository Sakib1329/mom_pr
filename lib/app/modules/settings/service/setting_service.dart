import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../../constants/appconstant.dart';

class SettingService extends GetxService {
  final box = GetStorage();
  Future<String> fetchPrivacyPolicy() async {
    try {
      final token = box.read('loginToken');
      if (token == null) throw Exception("No login token found");

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/auth/privacy_policy/'),
        headers: {
          "Content-Type": "application/json",
        },
      );
print(response.statusCode);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json["privacy_policy"]?.toString() ?? "";
      } else {
        throw Exception(
            "Failed to fetch privacy policy: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching privacy policy: $e");
    }
  }
  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final token = box.read('loginToken');
      if (token == null) throw Exception('No login token found');

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/auth/profile/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  /// 🔹 Submit Help & Support request
  Future<bool> helpSupport({
    required String email,
    required String description,
  }) async {
    try {
      final token = box.read('loginToken');
      if (token == null) throw Exception('No login token found');

      final body = {
        "email": email,
        "description": description,
      };

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/help_support/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Help Support failed: ${response.body}");
        return false;
      }
    } catch (e) {
      throw Exception('Error submitting help request: $e');
    }
  }

  /// 🔹 Delete profile (GET)
  Future<Map<String, dynamic>> deleteProfile() async {
    try {
      final token = box.read('loginToken');
      if (token == null) throw Exception('No login token found');

      final response = await http.delete(
        Uri.parse('${AppConstants.baseUrl}/auth/delete/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to delete profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting profile: $e');
    }
  }

  /// 🔹 Update profile data (PATCH)
  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String gender,
    required String email,
    required String phone,
    File? profileImageFile, // ✅ optional file
  }) async {
    try {
      final token = box.read('loginToken');
      if (token == null) throw Exception('No login token found');

      final uri = Uri.parse('${AppConstants.baseUrl}/auth/profile/');

      final request = http.MultipartRequest('PATCH', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['first_name'] = firstName
        ..fields['last_name'] = lastName
        ..fields['date_of_birth'] = dateOfBirth
        ..fields['gender'] = gender
        ..fields['email'] = email
      ..fields['phone']=phone;

      // ✅ Add image if selected
      if (profileImageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          profileImageFile.path,
        ));
      }
print(profileImageFile);
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('✅ Profile updated successfully');
        return true;
      } else {
        print('❌ Profile update failed: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }
  /// 🔹 Purchase Payment
  Future<String?> purchase({
    required int id,
    required String aliasType,
    required bool isMonCash,
  }) async {
    try {
      final token = box.read('loginToken');
      if (token == null) throw Exception('No login token found');

      final body = aliasType == 'movie'
          ? {'movie_set': [id], 'is_moncash': isMonCash}
          : {'series_set': [id], 'is_moncash': isMonCash};

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/payment/purchase/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url']?.toString();
      } else {
        throw Exception('Failed to initiate payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error purchasing: $e');
    }
  }

  /// 🔹 Subscription Payment
  Future<String?> subscriptionPayment({
    required String period,
    required bool isMonCash,
  }) async {
    try {
      final token = box.read('loginToken');
      if (token == null) throw Exception('No login token found');

      final body = {
        "period": period,
        "is_moncash": isMonCash,
      };

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/payment/subscribe/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url']?.toString();
      } else {
        throw Exception(
            'Failed to initiate subscription payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error initiating subscription payment: $e');
    }
  }

  Future<Map<String, dynamic>> fetchSubscriptionPrices() async {
    try {
      final token = box.read('loginToken');
      if (token == null) throw Exception('No login token found');

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/payment/subcription_prices/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to fetch subscription prices: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching subscription prices: $e');
    }
  }
}
