import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:Nuweli/app/constants/appconstant.dart';
import '../models/comingsoon_model.dart';


class ComingSoonService {


  Future<List<ComingSoonItem>> fetchComingSoon() async {
    try {
      final box = GetStorage();
      final token = box.read('loginToken');
      if (token == null) {
        throw Exception('No login token found');
      }

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/comming_soon/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Coming soon response: ${response.body}');
      print('Coming soon status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final movies = json['data']['movies'] as List<dynamic>? ?? [];
        final series = json['data']['series'] as List<dynamic>? ?? [];

        final List<ComingSoonItem> items = [];
        items.addAll(movies.map((movie) => ComingSoonItem.fromMovie(movie)));
        items.addAll(series.map((series) => ComingSoonItem.fromSeries(series)));
        return items;
      } else {
        throw Exception('Failed to load data: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching coming soon data: $e');
      throw Exception('Error fetching coming soon data: $e');
    }
  }
  Future<bool> remindMe(int id) async {
    try {
      final box = GetStorage();
      final token = box.read('loginToken');
      if (token == null) {
        throw Exception('No login token found');
      }


      final url = Uri.parse(
        '${AppConstants.baseUrl}/movie_and_series/movies/$id/notify/',
      );

      print("RemindMe POST URL: $url");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Remind Me status: ${response.statusCode}");
      print("Remind Me response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }

    } catch (e) {
      print("Error in remindMe: $e");
      return false;
    }
  }
}