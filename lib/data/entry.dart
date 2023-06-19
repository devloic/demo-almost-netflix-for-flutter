//
// entry.dart
// appflix
//
// Author: wess (me@wess.io)
// Created: 01/03/2022
//
// Copywrite (c) 2022 Wess.io
//

class Entry {
  final String id;
  final String name;
  final String? description;
  final String ageRestriction;
  final Duration durationMinutes;
  final String thumbnailImageId;
  final DateTime? netflixReleaseDate;
  final DateTime? releaseDate;
  final double trendingIndex;
  final bool isOriginal;
  final List<dynamic> cast;
  final List<dynamic> genres;
  final List<dynamic> tags;

  bool isEmpty() {
    if (id.isEmpty || name.isEmpty) {
      return true;
    }

    return false;
  }

  Entry({
    required this.id,
    required this.name,
    this.description,
    required this.ageRestriction,
    required this.durationMinutes,
    required this.thumbnailImageId,
    this.netflixReleaseDate,
    this.releaseDate,
    required this.trendingIndex,
    required this.isOriginal,
    required this.cast,
    required this.genres,
    required this.tags,
  });

  static Entry empty() {
    return Entry(
      id: '',
      name: '',
      description: '',
      ageRestriction: '',
      durationMinutes: const Duration(minutes: -1),
      thumbnailImageId: '',
      trendingIndex: -1,
      isOriginal: false,
      cast: [],
      genres: [],
      tags: [],
    );
  }

  static Entry fromJson(Map<String, dynamic> data) {
    return Entry(
      id: data['\$id'],
      name: data['name'] ?? "",
      description: data['description'],
      ageRestriction: data['ageRestriction'] ?? "",
      durationMinutes: Duration(minutes: data['durationMinutes'] ?? 0),
      thumbnailImageId: data['thumbnailImageId'] ?? "",
      netflixReleaseDate: DateTime.parse(data['netflixReleaseDate']),
      releaseDate: DateTime.parse(data['releaseDate']),
      trendingIndex: data['trendingIndex'],
      isOriginal: data['isOriginal'],
      cast: [],
      genres: [],
      tags: [],
    );
  }
}
