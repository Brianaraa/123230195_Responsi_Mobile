// lib/data/services/favorite_service.dart

import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';
import '../models/tv_show_model.dart';

class FavoriteService {
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;
  FavoriteService._internal();

  Box<TvShow> get _box => Hive.box<TvShow>(AppConstants.favoriteBox);

  List<TvShow> getFavorites() {
    return _box.values.toList();
  }

  Future<void> addFavorite(TvShow show) async {
    await _box.put(show.id.toString(), show);
  }

  Future<void> removeFavorite(int showId) async {
    await _box.delete(showId.toString());
  }

  bool isFavorite(int showId) {
    return _box.containsKey(showId.toString());
  }

  Future<void> toggleFavorite(TvShow show) async {
    if (isFavorite(show.id)) {
      await removeFavorite(show.id);
    } else {
      await addFavorite(show);
    }
  }

  Stream<BoxEvent> watchFavorites() {
    return _box.watch();
  }
}
