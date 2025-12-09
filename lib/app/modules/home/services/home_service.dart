import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:Nuweli/app/modules/home/models/allcontent_model.dart';
import 'package:Nuweli/app/modules/home/models/search_model.dart';

import '../../../constants/appconstant.dart';
import '../models/movie_model.dart';
import '../models/movieresponse_model.dart';
import '../models/series_model.dart';
import '../models/seriesresponse_model.dart';



class HomeService extends GetxService {
 static final box = GetStorage();
  Future<AllContentResponse> getAllContent() async {
    try {
      final token = box.read('loginToken');
      if (token == null) {
        throw Exception('No login token found');
      }

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/all/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({}),
      );



      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return AllContentResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load all content: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching all content: $e');
      throw Exception('Error fetching all content: $e');
    }
  }

  Future<SearchContentResponse> searchAll({String? title}) async {
    try {
      final token = box.read('loginToken');
      if (token == null) {
        throw Exception('No login token found');
      }
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/search_all/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(title != null ? {'title': title} : {}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SearchContentResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }


  Future<SearchContentResponse> getWatchLater() async {
    try {
      final token = box.read('loginToken');
      if (token == null) {
        throw Exception('No login token found');
      }
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/watch_later/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = jsonDecode(response.body);
        return SearchContentResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load watch later data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching watch later data: $e');
    }
  }

  Future<SearchContentResponse> getWatchHistory() async {
    try {
      final token = box.read('loginToken');
      if (token == null) {
        throw Exception('No login token found');
      }
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/watch_history/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = jsonDecode(response.body);
        return SearchContentResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load watch history data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching watch history data: $e');
    }
  }

  Future<void> removeFromWatchhistory(int id, String aliasType) async {
    try {
      final token = box.read('loginToken');
      if (token == null) {
        throw Exception('No login token found');
      }

      final body = aliasType == 'movie'
          ? {'movie_set': [id]}
          : {'series_set': [id]};

      final response = await http.patch(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/remove_watch_history/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Removed from watch history: ${response.body}'); // Debug log
      } else {
        throw Exception('Failed to remove from watch history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error removing from watch history: $e');
    }
  }

static  Future<Movie> getMovieDetails(int id, String aliastype) async {
    try {
      final token = box.read('loginToken');
      if (token == null) {
        throw Exception('No login token found');
      }
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/$aliastype/$id/detail/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Movie.fromJson(jsonData);
      } else {
        throw Exception('Failed to load movie details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movie details: $e');
    }
  }
static  Future<Series> getSeriesDetails(int id, String aliastype) async {
    try {
      final token = box.read('loginToken');
      if (token == null) {
        throw Exception('No login token found');
      }
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/$aliastype/$id/detail/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Series.fromJson(jsonData);
      } else {
        throw Exception('Failed to load movie details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movie details: $e');
    }
  }

  Future<Map<String, String>> getVideoPlaylist(String fileUuid) async {
    try {
      final token = box.read('loginToken');
      if (token == null) {
        throw Exception('No login token found');
      }
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/$fileUuid/get_video_playlist/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return {
          'otp': jsonData['otp'] as String,
          'playbackInfo': jsonData['playbackInfo'] as String,
        };
      } else {
        throw Exception('Failed to load video playlist: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching video playlist: $e');
    }
  }

  Future<List<String>> getGenres() async {
    try {
      final token = box.read('loginToken');
      if (token == null) {
        throw Exception('No login token found');
      }
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/genres/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return List<String>.from(jsonData['genres']);
      } else {
        throw Exception('Failed to load genres: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching genres: $e');
    }
  }

  Future<void> addToWatchLater(int id, String aliasType) async {
    try {
      final token = box.read('loginToken');
      if (token == null) {
        throw Exception('No login token found');
      }

      final body = aliasType == 'movie'
          ? {'movie_set': [id]}
          : {'series_set': [id]};

      final response = await http.patch(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/watch_later_add/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Added to watch later: ${response.body}');
      } else {
        throw Exception('Failed to add to watch later: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding to watch later: $e');
    }
  }

  // New method to remove from watch later
  Future<void> removeFromWatchLater(int id, String aliasType) async {
    try {
      final token = box.read('loginToken');
      if (token == null) {
        throw Exception('No login token found');
      }

      final body = aliasType == 'movie'
          ? {'movie_set': [id]}
          : {'series_set': [id]};

      final response = await http.patch(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/watch_later_remove/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Removed from watch later: ${response.body}'); // Debug log
      } else {
        throw Exception('Failed to remove from watch later: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error removing from watch later: $e');
    }
  }
  Future<MovieResponse> getAllMovies() async {
    try {
      final token = box.read('loginToken');
      if (token == null) throw Exception('No login token found');

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/movies/all/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
print(response.body);
print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        return MovieResponse.fromJson(jsonData); // parse to MovieResponse
      } else {
        throw Exception('Failed to load all movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching all movies: $e');
    }
  }
  Future<MovieResponse> getMoviesByGenre(String genreSlug) async {
    try {
      final token = box.read('loginToken');
      if (token == null) throw Exception('No login token found');

      final url = '${AppConstants.baseUrl}/movie_and_series/movies/by_genre/$genreSlug/';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Movies by genre ($genreSlug) response: ${response.body}');
      print('Movies by genre status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        return MovieResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load movies by genre: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movies by genre: $e');
    }
  }


  Future<SeriesResponse> getAllSeries() async {
    try {
      final token = box.read('loginToken');
      if (token == null) throw Exception('No login token found');

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/series/all/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        return SeriesResponse.fromJson(jsonData); // parse to MovieResponse
      } else {
        throw Exception('Failed to load all Series: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching all Series: $e');
    }
  }
  Future<SeriesResponse> getSeriesByGenre(String genreSlug) async {
    try {
      final token = box.read('loginToken');
      if (token == null) throw Exception('No login token found');

      final url = '${AppConstants.baseUrl}/movie_and_series/series/by_genre/$genreSlug/';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Series by genre ($genreSlug) response: ${response.body}');
      print('Series by genre status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        return SeriesResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load series by genre: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching series by genre: $e');
    }
  }


  Future<SearchContentResponse> getCollections() async {
    try {
      final token = box.read('loginToken');
      if (token == null) {
        throw Exception('No login token found');
      }
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/premium_collection/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = jsonDecode(response.body);
        return SearchContentResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load Collections data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching Collections data: $e');
    }
  }
  Future<void> likeItem(int id, String aliastype) async {
    try {
      final token = box.read('loginToken');
      if (token == null) throw Exception('No login token found');

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/$aliastype/$id/like'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Like $aliastype response: ${response.body}');
      if (response.statusCode != 200) {
        throw Exception('Failed to like $aliastype: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error liking $aliastype: $e');
    }
  }
  Future<void> dislikeContent(int id, String aliastype) async {
print(aliastype);
    try {
      final token = box.read('loginToken');
      if (token == null) throw Exception('No login token found');
print('${AppConstants.baseUrl}/movie_and_series/$aliastype/$id/dislike');
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/movie_and_series/$aliastype/$id/dislike'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
print(response);
      print('Dislike Response (${aliastype}): ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to dislike $aliastype: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error disliking $aliastype: $e');
    }
  }
}
