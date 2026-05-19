// lib/presentation/controllers/detail_controller.dart

import 'package:get/get.dart';
import '../../data/models/tv_show_model.dart';
import '../../data/services/tvmaze_service.dart';
import '../../data/services/favorite_service.dart';
import '../../core/constants/app_constants.dart';

class DetailController extends GetxController {
  final TvMazeService _apiService = TvMazeService();
  final FavoriteService _favoriteService = FavoriteService();

  final Rx<TvShow?> show = Rx<TvShow?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isFavorite = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      final id = args['id'] as int?;
      if (id != null) fetchDetail(id);
    }
  }

  Future<void> fetchDetail(int id) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final data = await _apiService.fetchShowDetail(id);
      show.value = data;
      isFavorite.value = _favoriteService.isFavorite(id);
    } catch (e) {
      errorMessage.value = 'Gagal memuat detail show.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite() async {
    if (show.value == null) return;
    await _favoriteService.toggleFavorite(show.value!);
    isFavorite.value = _favoriteService.isFavorite(show.value!.id);

    final message = isFavorite.value
        ? '${show.value!.name} ditambahkan ke favorit'
        : '${show.value!.name} dihapus dari favorit';

    Get.snackbar(
      isFavorite.value ? '❤️ Ditambahkan' : '💔 Dihapus',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
