// lib/presentation/pages/home/home_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/tv_show_model.dart';
import '../../controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = Get.put(HomeController());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();
  bool _isSearchBarVisible = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      _controller.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Obx(() {
            if (_controller.isLoading.value && _controller.shows.isEmpty) {
              return _buildShimmerGrid();
            }

            if (_controller.errorMessage.value.isNotEmpty &&
                _controller.shows.isEmpty) {
              return _buildError();
            }

            final showList = _controller.displayShows;

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Hero featured show (only when not searching)
                Obx(() {
                  if (!_controller.isSearching.value &&
                      _controller.featuredShow != null) {
                    return SliverToBoxAdapter(
                      child: _FeaturedShowHero(
                        show: _controller.featuredShow!,
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox(height: 100));
                }),

                // Section title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Obx(() => Text(
                          _controller.isSearching.value
                              ? 'Hasil: "${_controller.searchQuery.value}"'
                              : 'Semua Show',
                          style: Theme.of(context).textTheme.headlineMedium,
                        )),
                  ),
                ),

                // List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: Obx(() => SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ShowCard(show: showList[i]),
                          ),
                          childCount: showList.length,
                        ),
                      )),
                ),

                // Load more indicator
                SliverToBoxAdapter(
                  child: Obx(() => _controller.isLoadingMore.value
                      ? const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : const SizedBox(height: 24)),
                ),
              ],
            );
          }),

          // Top app bar overlay
          _buildTopBar(context),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withOpacity(0.95),
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              children: [
                Text(
                  'NARA GAME',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.primary,
                        fontSize: 22,
                        letterSpacing: 3,
                      ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.search, color: AppColors.textPrimary),
                  onPressed: () {
                    setState(() {
                      _isSearchBarVisible = !_isSearchBarVisible;
                    });
                    if (!_isSearchBarVisible) {
                      _searchCtrl.clear();
                      _controller.clearSearch();
                    }
                  },
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _isSearchBarVisible ? 56 : 0,
            child: _isSearchBarVisible
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextField(
                      controller: _searchCtrl,
                      autofocus: true,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Cari game...',
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.textMuted, size: 20),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close,
                              color: AppColors.textMuted, size: 20),
                          onPressed: () {
                            _searchCtrl.clear();
                            _controller.clearSearch();
                          },
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      onChanged: (val) => _controller.search(val),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 0),
        child: ListView.builder(
          itemCount: 8,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, color: AppColors.textMuted, size: 60),
          const SizedBox(height: 16),
          Text(
            _controller.errorMessage.value,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _controller.fetchShows(refresh: true),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(160, 44),
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}

class _FeaturedShowHero extends StatelessWidget {
  final TvShow show;
  const _FeaturedShowHero({required this.show});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppConstants.routeDetail,
        arguments: {'id': show.id},
      ),
      child: Stack(
        children: [
          // Background image
          SizedBox(
            height: 480,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: show.displayImageUrl,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                color: AppColors.surface,
                child: const Icon(Icons.videogame_asset, color: AppColors.textMuted, size: 60),
              ),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withOpacity(0.6),
                    AppColors.background,
                  ],
                  stops: const [0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),
          // Info
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    'FEATURED GAME',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          fontSize: 10,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  show.name.toUpperCase(),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 32,
                        shadows: [
                          const Shadow(
                            blurRadius: 12,
                            color: Colors.black,
                          ),
                        ],
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.date_range, color: AppColors.gold, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      show.displayRating,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(width: 12),
                    if (show.genres.isNotEmpty)
                      Text(
                        show.genres.take(2).join(' • '),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Get.toNamed(
                        AppConstants.routeDetail,
                        arguments: {'id': show.id},
                      ),
                      icon: const Icon(Icons.play_arrow, size: 20),
                      label: const Text('GET GAME'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(130, 40),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () => Get.toNamed(
                        AppConstants.routeDetail,
                        arguments: {'id': show.id},
                      ),
                      icon: const Icon(Icons.info_outline,
                          size: 18, color: AppColors.textPrimary),
                      label: const Text(
                        'INFO',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        side: const BorderSide(color: AppColors.textSecondary),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShowCard extends StatelessWidget {
  final TvShow show;
  const _ShowCard({required this.show});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppConstants.routeDetail,
        arguments: {'id': show.id},
      ),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Poster image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: SizedBox(
                width: 130,
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: show.mediumImageUrl ?? show.displayImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: AppColors.shimmerBase,
                    highlightColor: AppColors.shimmerHighlight,
                    child: Container(color: AppColors.surface),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.surface,
                    child: const Icon(Icons.videogame_asset, color: AppColors.textMuted, size: 28),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      show.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      show.genres.isNotEmpty ? show.genres.first : 'Unknown Genre',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.desktop_windows, size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            show.status ?? 'Unknown Platform',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
