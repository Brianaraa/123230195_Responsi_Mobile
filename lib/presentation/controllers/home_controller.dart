// lib/presentation/controllers/home_controller.dart

import 'package:get/get.dart';
import '../../data/models/tv_show_model.dart';
import '../../data/services/tvmaze_service.dart';

class HomeController extends GetxController {
  final TvMazeService _apiService = TvMazeService();

  final RxList<TvShow> shows = <TvShow>[].obs;
  final RxList<TvShow> searchResults = <TvShow>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isSearching = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxInt currentPage = 0.obs;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchShows();
  }

  Future<void> fetchShows({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 0;
      shows.clear();
      hasMore.value = true;
    }

    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final newShows = await _apiService.fetchShows(page: currentPage.value);
      if (newShows.isEmpty) {
        hasMore.value = false;
      } else {
        shows.addAll(newShows);
        currentPage.value++;
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat data. Periksa koneksi internet.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value || isSearching.value) return;

    isLoadingMore.value = true;
    try {
      final newShows = await _apiService.fetchShows(page: currentPage.value);
      if (newShows.isEmpty) {
        hasMore.value = false;
      } else {
        shows.addAll(newShows);
        currentPage.value++;
      }
    } catch (_) {
      // silently fail on load more
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      isSearching.value = false;
      searchResults.clear();
      searchQuery.value = '';
      return;
    }

    isSearching.value = true;
    searchQuery.value = query.trim();
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final results = await _apiService.searchShows(query);
      searchResults.assignAll(results);
    } catch (e) {
      errorMessage.value = 'Pencarian gagal.';
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    isSearching.value = false;
    searchResults.clear();
    searchQuery.value = '';
  }

  List<TvShow> get displayShows => isSearching.value ? searchResults : shows;

  // Featured show for hero section (first show)
  TvShow? get featuredShow => shows.isNotEmpty ? shows.first : null;
}
