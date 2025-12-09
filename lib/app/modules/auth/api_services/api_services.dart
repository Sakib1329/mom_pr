import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../constants/appconstant.dart';
import '../models/login_model.dart';
import '../models/signup_models.dart';

class AuthProvider {
  final String _baseUrl = AppConstants.baseUrl;
  final GetStorage box = GetStorage();
  final String refreshtoken = ""; // single storage instance

  // login
  Future<bool> login(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access'];
        final refresh = data['refresh'];

        if (token != null) box.write('loginToken', token);

        if (refresh != null) box.write('refreshToken', refresh);
        return true;
      }
      print('Login failed: ${response.body}');
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> refreshAccessToken() async {

    final refreshToken = box.read('refreshToken');
    print(refreshToken);

    if (refreshToken == null) {
      print('No refresh token found');
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/refresh_token/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['access'];
        if (newAccessToken != null) {
          box.write('loginToken', newAccessToken);
          print('Access token refreshed successfully');
          return true;
        }
      } else {
        print('Failed to refresh token: ${response.body}');
      }
    } catch (e) {
      print('Token refresh error: $e');
    }
    return false;
  }

  // register
  Future<bool> register(SignupModel newuser) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newuser.toJson()),
      );
      print(response.body);
      return response.statusCode == 201;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  Future<bool> activateAccount(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/activate/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        if (token != null) box.write('signupToken', token);
        return true;
      }
      print('Activation failed: ${response.body}');
      return false;
    } catch (e) {
      print('Activation error: $e');
      return false;
    }
  }

  // otpactivate
  Future<bool> otpActivate(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/verify_otp/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp, 'action' : "password_reset"}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['action_token'];
        print(token);
        if (token != null) box.write('actionToken', token);
        return true;
      }
      print('OTP Activation failed: ${response.body}');
      return false;
    } catch (e) {
      print('OTP Activation error: $e');
      return false;
    }
  }

  // resend otp
  Future<bool> resendOtp(String email) async {
    print(email);
    final r = await http.post(
      Uri.parse('$_baseUrl/accounts/email-verification/resend/'),
      body: {'email': email},
    );
    return r.statusCode == 200;
  }

  // reset pass req
  Future<bool> resetPassword(String email) async {
    print(email);
    final r = await http.post(
      Uri.parse('$_baseUrl/auth/request_password_reset/'),
      body: {'email': email},
    );
    return r.statusCode == 200;
  }

  // set new password
  Future<bool> setNewPassword(String email, String newPassword) async {
    final token =box.read("actionToken");
    print( token);
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/reset_password/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "new_password": newPassword,
        "action_token": token
      }),
    );

    if (response.statusCode == 200) {
      print('Password reset successful');
      final data = jsonDecode(response.body);
      if (data['access_token'] != null) {
        box.write('loginToken', data['access_token']);
      }
      return true;
    }
    print('Set password failed: ${response.body}');
    return false;
  }
}