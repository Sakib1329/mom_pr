import 'package:Nuweli/app/modules/home/models/series_model.dart';
import 'package:Nuweli/app/modules/home/models/seriesresponse_model.dart';
import 'movie_model.dart';
import 'movieresponse_model.dart';

class AllContentResponse {
  final MovieResponse movies;
  final SeriesResponse series;
  // Added a direct list for flat responses like 'Continue Watching'
  final List<Movie> continueWatchingMovies;

  AllContentResponse({
    required this.movies,
    required this.series,
    this.continueWatchingMovies = const [],
  });

  factory AllContentResponse.fromJson(Map<String, dynamic> json) {
    // Check if the response is from the 'continue_progress' endpoint
    // which has 'movies' at the root instead of inside 'data'
    final bool isContinueProgress = json.containsKey('movies') && !json.containsKey('data');

    final data = json['data'] ?? {};
    final moviesData = data['movies'] ?? {};
    final seriesData = data['series'] ?? {};

    // Helper: Parse movie list
    List<Movie> _parseMovieList(dynamic list) {
      if (list == null) return [];
      return (list as List<dynamic>)
          .map((item) => Movie.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    // Helper: Parse series list
    List<Series> _parseSeriesList(dynamic list) {
      if (list == null) return [];
      return (list as List<dynamic>)
          .map((item) => Series.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    if (isContinueProgress) {
      // Logic for /movie_and_series/continue_progress/
      return AllContentResponse(
        continueWatchingMovies: _parseMovieList(json['movies']),
        movies: MovieResponse(popular: [], watchLater: [], watchHistory: [], previousYear: [], animation: [], action: [], drama: [], horror: [], scienceFiction: [], mystery: []),
        series: SeriesResponse(popular: [], watchLater: [], watchHistory: [], previousYear: [], animation: [], action: [], drama: [], horror: [], scienceFiction: [], mystery: []),
      );
    }

    // Standard Logic for the Home Feed /movie_and_series/all/
    return AllContentResponse(
      movies: MovieResponse(
        popular: _parseMovieList(moviesData['popular']),
        watchLater: _parseMovieList(moviesData['watch_later']),
        watchHistory: _parseMovieList(moviesData['watch_history']),
        previousYear: _parseMovieList(moviesData['previous_year']),
        animation: _parseMovieList(moviesData['animation']),
        action: _parseMovieList(moviesData['action']),
        drama: _parseMovieList(moviesData['drama']),
        horror: _parseMovieList(moviesData['horror']),
        scienceFiction: _parseMovieList(moviesData['science-fiction']),
        mystery: _parseMovieList(moviesData['mystery']),
      ),
      series: SeriesResponse(
        popular: _parseSeriesList(seriesData['popular']),
        watchLater: _parseSeriesList(seriesData['watch_later']),
        watchHistory: _parseSeriesList(seriesData['watch_history']),
        previousYear: _parseSeriesList(seriesData['previous_year']),
        animation: _parseSeriesList(seriesData['animation']),
        action: _parseSeriesList(seriesData['action']),
        drama: _parseSeriesList(seriesData['drama']),
        horror: _parseSeriesList(seriesData['horror']),
        scienceFiction: _parseSeriesList(seriesData['science-fiction']),
        mystery: _parseSeriesList(seriesData['mystery']),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movies': movies.toJson(),
      'series': series.toJson(),
      'continue_watching_movies': continueWatchingMovies.map((e) => e.toJson()).toList(),
    };
  }
}