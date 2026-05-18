// lib/data/services/tvmaze_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tv_show_model.dart';
import '../../core/constants/app_constants.dart';

class TvMazeService {
  static final TvMazeService _instance = TvMazeService._internal();
  factory TvMazeService() => _instance;
  TvMazeService._internal();

  final http.Client _client = http.Client();

  Future<List<TvShow>> fetchShows({int page = 0}) async {
    try {
      final uri = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.showsEndpoint}?page=$page',
      );
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => TvShow.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load shows: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<TvShow> fetchShowDetail(int id) async {
    try {
      final uri = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.showDetailEndpoint}$id',
      );
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        return TvShow.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load show detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<TvShow>> searchShows(String query) async {
    try {
      final uri = Uri.parse(
        '${AppConstants.baseUrl}/search/shows?q=${Uri.encodeComponent(query)}',
      );
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((item) => TvShow.fromJson(item['show']))
            .toList();
      } else {
        throw Exception('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
