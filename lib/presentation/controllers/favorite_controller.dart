// lib/presentation/controllers/favorite_controller.dart

import 'dart:async';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../data/models/tv_show_model.dart';
import '../../data/services/favorite_service.dart';
import '../../core/constants/app_constants.dart';

class FavoriteController extends GetxController {
  final FavoriteService _favoriteService = FavoriteService();

  final RxList<TvShow> favorites = <TvShow>[].obs;
  StreamSubscription<BoxEvent>? _subscription;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
    _listenToChanges();
  }

  void loadFavorites() {
    favorites.assignAll(_favoriteService.getFavorites());
  }

  void _listenToChanges() {
    _subscription = _favoriteService.watchFavorites().listen((_) {
      loadFavorites();
    });
  }

  Future<void> removeFavorite(int showId) async {
    await _favoriteService.removeFavorite(showId);
    loadFavorites();
    Get.snackbar(
      '💔 Dihapus',
      'Show dihapus dari favorit',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
