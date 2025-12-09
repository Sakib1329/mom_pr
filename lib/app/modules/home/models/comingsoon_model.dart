import 'package:intl/intl.dart';
import 'package:Nuweli/app/res/assets/imageassets.dart';

class ComingSoonItem {
  final String id;
  final String title;
  final String? subtitle;
  final String imageUrl;           // Now non-nullable with fallback
  final List<String> genres;
  final String releaseInfo;
  final bool isSeries;
  final String? fileUuid;
  final bool isNotify;             // ← New field from API

  ComingSoonItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    required this.genres,
    required this.releaseInfo,
    required this.isSeries,
    this.fileUuid,
    this.isNotify = false,
  });

  // ──────────────────────────────────────────────────
  // Factory from Movie
  // ──────────────────────────────────────────────────
  factory ComingSoonItem.fromMovie(Map<String, dynamic> movie) {
    final posters = movie['posters_url'] as List<dynamic>?;

    final releaseInfo = movie['comming_soon_time'] != null
        ? 'Coming ${DateFormat('MMM d').format(DateTime.parse(movie['comming_soon_time']))}'
        : 'Coming Soon';

    final genres = (movie['genres'] as List<dynamic>?)
        ?.map((g) => g['name'].toString())
        .toList() ??
        <String>[];

    return ComingSoonItem(
        id: movie['id'].toString(),
        title: movie['title'] ?? '',
        subtitle: movie['description'],
        imageUrl: (posters?.isNotEmpty == true)
            ? posters!.first.toString()
            : ImageAssets.img_14,
        genres: genres.isEmpty ? ['Movie'] : genres,
        releaseInfo: releaseInfo,
        isSeries: false,
     fileUuid: movie['file_uuid']?.toString(),
    isNotify: movie['is_notify'] as bool? ?? false,
    );
  }

  // ──────────────────────────────────────────────────
  // Factory from Series (Season)
  // ──────────────────────────────────────────────────
  factory ComingSoonItem.fromSeries(Map<String, dynamic> series) {
    final posters = series['posters_url'] as List<dynamic>?;

    final releaseInfo = series['comming_soon_time'] != null
        ? DateFormat('MMM d').format(DateTime.parse(series['comming_soon_time']))
        : 'Coming Soon';

    final genres = (series['genres'] as List<dynamic>?)
        ?.map((g) => g['name'].toString())
        .toList() ??
        <String>[];

    return ComingSoonItem(
      id: series['id'].toString(),
      title: series['series_name'] ?? series['season_name'] ?? 'Untitled Series',
      subtitle: series['season_name'],
      imageUrl: (posters?.isNotEmpty == true)
          ? posters!.first.toString()
          : ImageAssets.img_14,
      genres: genres.isEmpty ? ['Series'] : genres,
      releaseInfo: releaseInfo,
      isSeries: true,
      fileUuid: series['file_uuid']?.toString(), // may be null for seasons
      isNotify: series['is_notify'] as bool? ?? false,
    );
  }
}