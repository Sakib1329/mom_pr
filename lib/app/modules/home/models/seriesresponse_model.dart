import 'package:Nuweli/app/modules/home/models/series_model.dart';

class SeriesResponse {
  final List<Series> popular;
  final List<Series> watchLater;
  final List<Series> watchHistory;
  final List<Series> previousYear;
  final List<Series> animation;
  final List<Series> action;
  final List<Series> drama;
  final List<Series> horror;
  final List<Series> scienceFiction;
  final List<Series> mystery;

  SeriesResponse({
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

  factory SeriesResponse.fromJson(Map<String, dynamic> json) {
    List<Series> parseList(dynamic list) {
      return (list as List<dynamic>?)?.map((e) => Series.fromJson(e as Map<String, dynamic>)).toList() ?? [];
    }

    return SeriesResponse(
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
    List<Map<String, dynamic>> convert(List<Series> list) => list.map((e) => e.toJson()).toList();

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