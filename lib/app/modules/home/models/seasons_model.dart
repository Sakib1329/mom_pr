import 'episode.dart';

class Season {
  final int id;
  final int seriesId;
  final String seasonName;
  final int? releaseYear;
  final String createdAt;
  final String updatedAt;
  final List<Episode> episodes;

  Season({
    required this.id,
    required this.seriesId,
    required this.seasonName,
    this.releaseYear,
    required this.createdAt,
    required this.updatedAt,
    required this.episodes,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      seriesId: json['series_id'] is int
          ? json['series_id']
          : int.tryParse(json['series_id'].toString()) ?? 0,
      seasonName: json['season_name'] ?? '',
      releaseYear: json['release_year'] is int
          ? json['release_year']
          : int.tryParse(json['release_year']?.toString() ?? ''),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      episodes: (json['episodes'] as List<dynamic>?)
          ?.map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'series_id': seriesId,
      'season_name': seasonName,
      'release_year': releaseYear,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }
}