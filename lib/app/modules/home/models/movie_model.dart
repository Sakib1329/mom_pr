import 'genre_model.dart';

class Movie {
  final int id;
  final String title;
  final int? releaseYear;
  final int? runtimeMinutes;
  final List<Genre> genres;
  final bool? isCollection;
  final List<String> postersUrl;
  final bool isPremium;
  final String premiumPriceUsd;
  final String premiumPriceGourde;
  final String description;
  final String aliasType;
  final String fileUuid;
  final List<Movie> relatedMovies;
  final int likes;
  final int dislikes;
  final bool liked;
  final bool disliked;
  final String? trailer;
  final String? comingSoonTime; // <-- NOW INCLUDED

  Movie({
    required this.id,
    required this.title,
    this.releaseYear,
    this.runtimeMinutes,
    required this.genres,
    this.isCollection,
    required this.postersUrl,
    required this.isPremium,
    required this.premiumPriceUsd,
    required this.premiumPriceGourde,
    required this.description,
    required this.aliasType,
    required this.fileUuid,
    required this.relatedMovies,
    required this.likes,
    required this.dislikes,
    required this.liked,
    required this.disliked,
    this.trailer,
    this.comingSoonTime, // <-- Added
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
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

    return Movie(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      releaseYear: json['release_year'] is int
          ? json['release_year']
          : int.tryParse(json['release_year']?.toString() ?? ''),
      runtimeMinutes: json['runtime_minutes'] is int
          ? json['runtime_minutes']
          : int.tryParse(json['runtime_minutes']?.toString() ?? ''),
      genres: (json['genres'] as List<dynamic>?)
          ?.map((g) => Genre.fromJson(g as Map<String, dynamic>))
          .toList() ??
          [],
      isCollection: parseBool(json['is_collection']),
      postersUrl: parsePostersUrl(json['posters_url']),
      isPremium: parseBool(json['is_premium']) ?? false,
      premiumPriceUsd: json['premium_price_usd']?.toString() ?? '0.00',
      premiumPriceGourde: json['premium_price_gourde']?.toString() ?? '0.00',
      description: json['description']?.toString() ?? '',
      aliasType: json['alias_type']?.toString() ?? 'movie',
      fileUuid: json['file_uuid']?.toString() ?? '',
      relatedMovies: (json['related_movies'] as List<dynamic>?)
          ?.map((m) => Movie.fromJson(m as Map<String, dynamic>))
          .toList() ??
          [],
      likes: json['likes'] is int ? json['likes'] : int.tryParse(json['likes']?.toString() ?? '') ?? 0,
      dislikes: json['dislikes'] is int ? json['dislikes'] : int.tryParse(json['dislikes']?.toString() ?? '') ?? 0,
      liked: parseBool(json['liked']) ?? false,
      disliked: parseBool(json['disliked']) ?? false,
      trailer: json['trailer']?.toString(),
      comingSoonTime: json['comming_soon_time']?.toString(), // <-- Correct key
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'release_year': releaseYear,
      'runtime_minutes': runtimeMinutes,
      'genres': genres.map((g) => g.toJson()).toList(),
      'is_collection': isCollection,
      'posters_url': postersUrl,
      'is_premium': isPremium,
      'premium_price_usd': premiumPriceUsd,
      'premium_price_gourde': premiumPriceGourde,
      'description': description,
      'alias_type': aliasType,
      'file_uuid': fileUuid,
      'related_movies': relatedMovies.map((m) => m.toJson()).toList(),
      'likes': likes,
      'dislikes': dislikes,
      'liked': liked,
      'disliked': disliked,
      'trailer': trailer,
      'comming_soon_time': comingSoonTime, // Include in output
    };
  }

  String get formattedDuration {
    if (runtimeMinutes == null || runtimeMinutes! <= 0) return 'N/A';
    final hours = runtimeMinutes! ~/ 60;
    final minutes = runtimeMinutes! % 60;
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }

  String get formattedGenres {
    return genres.isNotEmpty ? genres.map((g) => g.name).join(', ') : 'N/A';
  }

  String get firstPosterUrl => postersUrl.isNotEmpty ? postersUrl.first : '';

  bool get hasTrailer => trailer != null && trailer!.isNotEmpty;

  // Helper: Is this movie coming soon?
  bool get isComingSoon {
    if (comingSoonTime == null) return false;
    try {
      final date = DateTime.parse(comingSoonTime!);
      return date.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  // Helper: Format coming soon date
  String get formattedComingSoonDate {
    if (comingSoonTime == null) return 'Soon';
    try {
      final d = DateTime.parse(comingSoonTime!).toLocal();
      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Soon';
    }
  }
}