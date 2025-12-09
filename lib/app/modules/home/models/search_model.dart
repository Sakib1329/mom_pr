import 'package:Nuweli/app/modules/home/models/movie_model.dart';
import 'package:Nuweli/app/modules/home/models/series_model.dart';

class SearchContentResponse {
  final List<Movie> movies;
  final List<Series> series;

  SearchContentResponse({required this.movies, required this.series});

  factory SearchContentResponse.fromJson(Map<String, dynamic> json) {
    final movieList = (json['data']?['movies'] as List<dynamic>?)
        ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [];
    final seriesList = (json['data']?['series'] as List<dynamic>?)
        ?.map((e) => Series.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [];

    return SearchContentResponse(
      movies: movieList,
      series: seriesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movies': movies.map((m) => m.toJson()).toList(),
      'series': series.map((s) => s.toJson()).toList(),
    };
  }
}