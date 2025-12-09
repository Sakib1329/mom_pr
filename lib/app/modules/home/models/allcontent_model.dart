import 'package:Nuweli/app/modules/home/models/series_model.dart';
import 'package:Nuweli/app/modules/home/models/seriesresponse_model.dart';

import 'movie_model.dart';
import 'movieresponse_model.dart';

class AllContentResponse {
  final MovieResponse movies;
  final SeriesResponse series;

  AllContentResponse({required this.movies, required this.series});

  factory AllContentResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final moviesData = data['movies'] ?? {};
    final seriesData = data['series'] ?? {};

    // Helper: Parse movie category list
    List<Movie> _parseMovieCategory(dynamic categoryList) {
      if (categoryList == null) return [];
      return (categoryList as List<dynamic>)
          .map((item) => Movie.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    // Helper: Parse series category list
    List<Series> _parseSeriesCategory(dynamic categoryList) {
      if (categoryList == null) return [];
      return (categoryList as List<dynamic>)
          .map((item) => Series.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    // Parse movies into MovieResponse
    MovieResponse parseMovies(Map<String, dynamic> moviesData) {
      return MovieResponse(
        popular: _parseMovieCategory(moviesData['popular']),
        watchLater: _parseMovieCategory(moviesData['watch_later']),
        watchHistory: _parseMovieCategory(moviesData['watch_history']),
        previousYear: _parseMovieCategory(moviesData['previous_year']),
        animation: _parseMovieCategory(moviesData['animation']),
        action: _parseMovieCategory(moviesData['action']),
        drama: _parseMovieCategory(moviesData['drama']),
        horror: _parseMovieCategory(moviesData['horror']),
        scienceFiction: _parseMovieCategory(moviesData['science-fiction']),
        mystery: _parseMovieCategory(moviesData['mystery']),
      );
    }

    // Parse series into SeriesResponse
    SeriesResponse parseSeries(Map<String, dynamic> seriesData) {
      return SeriesResponse(
        popular: _parseSeriesCategory(seriesData['popular']),
        watchLater: _parseSeriesCategory(seriesData['watch_later']),
        watchHistory: _parseSeriesCategory(seriesData['watch_history']),
        previousYear: _parseSeriesCategory(seriesData['previous_year']),
        animation: _parseSeriesCategory(seriesData['animation']),
        action: _parseSeriesCategory(seriesData['action']),
        drama: _parseSeriesCategory(seriesData['drama']),
        horror: _parseSeriesCategory(seriesData['horror']),
        scienceFiction: _parseSeriesCategory(seriesData['science-fiction']),
        mystery: _parseSeriesCategory(seriesData['mystery']),
      );
    }

    return AllContentResponse(
      movies: parseMovies(moviesData),
      series: parseSeries(seriesData),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movies': movies.toJson(),
      'series': series.toJson(),
    };
  }
}