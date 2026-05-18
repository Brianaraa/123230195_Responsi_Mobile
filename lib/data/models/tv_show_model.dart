// lib/data/models/tv_show_model.dart

import 'package:hive/hive.dart';

part 'tv_show_model.g.dart';

@HiveType(typeId: 0)
class TvShow extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? imageUrl;

  @HiveField(3)
  final double? rating;

  @HiveField(4)
  final List<String> genres;

  @HiveField(5)
  final String? summary;

  @HiveField(6)
  final String? status;

  @HiveField(7)
  final String? language;

  @HiveField(8)
  final String? premiered;

  @HiveField(9)
  final String? officialSite;

  @HiveField(10)
  final String? mediumImageUrl;

  TvShow({
    required this.id,
    required this.name,
    this.imageUrl,
    this.rating,
    required this.genres,
    this.summary,
    this.status,
    this.language,
    this.premiered,
    this.officialSite,
    this.mediumImageUrl,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    final ratingMap = json['rating'];

    return TvShow(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      imageUrl: image?['original'],
      mediumImageUrl: image?['medium'],
      rating: ratingMap?['average'] != null
          ? (ratingMap['average'] as num).toDouble()
          : null,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      summary: json['summary'],
      status: json['status'],
      language: json['language'],
      premiered: json['premiered'],
      officialSite: json['officialSite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': {'original': imageUrl, 'medium': mediumImageUrl},
      'rating': {'average': rating},
      'genres': genres,
      'summary': summary,
      'status': status,
      'language': language,
      'premiered': premiered,
      'officialSite': officialSite,
    };
  }

  String get displayImageUrl => imageUrl ?? mediumImageUrl ?? '';
  String get displayRating => rating != null ? rating!.toStringAsFixed(1) : 'N/A';
  String get premieredYear => premiered?.substring(0, 4) ?? '';
}
