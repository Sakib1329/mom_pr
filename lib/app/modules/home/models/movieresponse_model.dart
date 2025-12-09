import 'movie_model.dart';

class MovieResponse {
  final List<Movie> popular;
  final List<Movie> watchLater;
  final List<Movie> watchHistory;
  final List<Movie> previousYear;
  final List<Movie> animation;
  final List<Movie> action;
  final List<Movie> drama;
  final List<Movie> horror;
  final List<Movie> scienceFiction;
  final List<Movie> mystery;

  MovieResponse({
    required this.popular,
    required this.watchLater,
    required this.watchHistory,
    required this.previousYear,
    required this.animation,
    required this.action,
    required this.drama,
    required this.horror,
    required this.scienceFiction,
    required this.mystery,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    List<Movie> parseList(dynamic list) {
      return (list as List<dynamic>?)?.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList() ?? [];
    }

    return MovieResponse(
      popular: parseList(json['popular']),
      watchLater: parseList(json['watch_later']),
      watchHistory: parseList(json['watch_history']),
      previousYear: parseList(json['previous_year']),
      animation: parseList(json['animation']),
      action: parseList(json['action']),
      drama: parseList(json['drama']),
      horror: parseList(json['horror']),
      scienceFiction: parseList(json['science-fiction']),
      mystery: parseList(json['mystery']),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> convert(List<Movie> list) => list.map((e) => e.toJson()).toList();

    return {
      'popular': convert(popular),
      'watch_later': convert(watchLater),
      'watch_history': convert(watchHistory),
      'previous_year': convert(previousYear),
      'animation': convert(animation),
      'action': convert(action),
      'drama': convert(drama),
      'horror': convert(horror),
      'science-fiction': convert(scienceFiction),
      'mystery': convert(mystery),
    };
  }
}