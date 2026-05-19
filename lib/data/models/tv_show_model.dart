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
  final String? tanggalrilis;

  @HiveField(4)
  final List<String> genres;

  @HiveField(5)
  final String? summary;

  @HiveField(6)
  final String? status;

  @HiveField(7)
  final String? publisher;

  @HiveField(8)
  final String? devaloper;

  @HiveField(9)
  final List<String>? screenshots;

  @HiveField(10)
  final String? mediumImageUrl;

  TvShow({
    required this.id,
    required this.name,
    this.imageUrl,
    this.tanggalrilis,
    required this.genres,
    this.summary,
    this.status,
    this.publisher,
    this.devaloper,
    this.screenshots,
    this.mediumImageUrl,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    final genreStr = json['genre'];
    final genresList = genreStr != null ? [genreStr.toString()] : <String>[];
    
    List<String>? screenshotsList;
    if (json['screenshots'] != null) {
      screenshotsList = (json['screenshots'] as List)
          .map((e) => e['image'].toString())
          .toList();
    }

    return TvShow(
      id: json['id'] ?? 0,
      name: json['title'] ?? 'Unknown',
      imageUrl: json['thumbnail'],
      mediumImageUrl: json['thumbnail'],
      tanggalrilis: json['release_date'],
      genres: genresList,
      summary: json['description'] ?? json['short_description'],
      status: json['platform'],
      publisher: json['publisher'],
      devaloper: json['developer'],
      screenshots: screenshotsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'thumbnail': imageUrl,
      'release_date': tanggalrilis,
      'genre': genres.isNotEmpty ? genres.first : null,
      'description': summary,
      'platform': status,
      'publisher': publisher,
      'developer': devaloper,
      'screenshots': screenshots?.map((e) => {'image': e}).toList(),
    };
  }

  String get displayImageUrl => imageUrl ?? mediumImageUrl ?? '';
  String get displayRating => tanggalrilis ?? 'N/A'; // Show release date directly
  String get premieredYear => devaloper ?? '';
}
