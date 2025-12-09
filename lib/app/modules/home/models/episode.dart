class Episode {
  final int id;
  final int seasonId;
  final String title;
  final String createdAt;
  final String updatedAt;
  final String fileUuid;

  Episode({
    required this.id,
    required this.seasonId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.fileUuid,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      seasonId: json['season_id'] is int
          ? json['season_id']
          : int.tryParse(json['season_id'].toString()) ?? 0,
      title: json['title'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      fileUuid: json['file_uuid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'season_id': seasonId,
      'title': title,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'file_uuid': fileUuid,
    };
  }
}