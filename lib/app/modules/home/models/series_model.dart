import 'package:Nuweli/app/modules/home/models/seasons_model.dart';
import 'genre_model.dart';

class Series {
  final int id;
  final String name;
  final List<Genre> genres;
  final String createdAt;
  final String updatedAt;
  final bool? isCollection;
  final List<String> postersUrl;
  final bool isPremium;
  final String premiumPriceUsd;
  final String premiumPriceGourde;
  final String description;
  final String aliasType;
  final List<Season> seasons;
  final List<Series> relatedSeries;
  final int likes;
  final int dislikes;
  final bool liked;
  final bool disliked;

  Series({
    required this.id,
    required this.name,
    required this.genres,
    required this.createdAt,
    required this.updatedAt,
    this.isCollection,
    required this.postersUrl,
    required this.isPremium,
    required this.premiumPriceUsd,
    required this.premiumPriceGourde,
    required this.description,
    required this.aliasType,
    required this.seasons,
    required this.relatedSeries,
    required this.likes,
    required this.dislikes,
    required this.liked,
    required this.disliked,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    bool? parseBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true' || value == '1';
      if (value is int) return value == 1;
      return false;
    }

    List<String> parsePostersUrl(dynamic value) {
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      } else if (value is String && value.isNotEmpty) {
        return [value];
      }
      return [];
    }

    return Series(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      genres: (json['genres'] as List<dynamic>?)
          ?.map((g) => Genre.fromJson(g as Map<String, dynamic>))
          .toList() ??
          [],
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      isCollection: parseBool(json['is_collection']),
      postersUrl: parsePostersUrl(json['posters_url']),
      isPremium: parseBool(json['is_premium']) ?? false,
      premiumPriceUsd: json['premium_price_usd']?.toString() ?? '0.00',
      premiumPriceGourde: json['premium_price_gourde']?.toString() ?? '0.00',
      description: json['description']?.toString() ?? '',
      aliasType: json['alias_type']?.toString() ?? 'series',
      seasons: (json['seasons'] as List<dynamic>?)
          ?.map((s) => Season.fromJson(s as Map<String, dynamic>))
          .toList() ??
          [],
      relatedSeries: (json['related_series'] as List<dynamic>?)
          ?.map((r) => Series.fromJson(r as Map<String, dynamic>))
          .toList() ??
          [],
      likes: json['likes'] is int
          ? json['likes']
          : int.tryParse(json['likes']?.toString() ?? '') ?? 0,
      dislikes: json['dislikes'] is int
          ? json['dislikes']
          : int.tryParse(json['dislikes']?.toString() ?? '') ?? 0,
      liked: parseBool(json['liked']) ?? false,
      disliked: parseBool(json['disliked']) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'genres': genres.map((g) => g.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_collection': isCollection,
      'posters_url': postersUrl,
      'is_premium': isPremium,
      'premium_price_usd': premiumPriceUsd,
      'premium_price_gourde': premiumPriceGourde,
      'description': description,
      'alias_type': aliasType,
      'seasons': seasons.map((s) => s.toJson()).toList(),
      'related_series': relatedSeries.map((r) => r.toJson()).toList(),
      'likes': likes,
      'dislikes': dislikes,
      'liked': liked,
      'disliked': disliked,
    };
  }

  int get totalEpisodes {
    return seasons.fold(0, (total, season) => total + season.episodes.length);
  }

  String get formattedSeasons {
    if (seasons.isEmpty) return 'N/A';
    return '${seasons.length} ${seasons.length == 1 ? 'season' : 'seasons'}';
  }

  String get formattedGenres {
    return genres.isNotEmpty ? genres.map((g) => g.name).join(', ') : 'N/A';
  }

  String get firstPosterUrl => postersUrl.isNotEmpty ? postersUrl.first : '';
}