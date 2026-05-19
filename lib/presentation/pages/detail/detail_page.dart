// lib/presentation/pages/detail/detail_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/detail_controller.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DetailController controller = Get.put(
      DetailController(),
      tag: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmer();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildError(controller);
        }

        final show = controller.show.value;
        if (show == null) return const SizedBox.shrink();

        return CustomScrollView(
          slivers: [
            // Hero image app bar
            SliverAppBar(
              expandedHeight: 400,
              pinned: true,
              backgroundColor: AppColors.background,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: AppColors.textPrimary),
                  onPressed: () => Get.back(),
                ),
              ),
              actions: [
                Obx(() => Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: Icon(
                          controller.isFavorite.value
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: controller.isFavorite.value
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                        onPressed: controller.toggleFavorite,
                      ),
                    )),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: show.displayImageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.surface,
                        child: const Icon(Icons.tv,
                            color: AppColors.textMuted, size: 80),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.background.withOpacity(0.5),
                            AppColors.background,
                          ],
                          stops: const [0.4, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      show.name,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 30),
                    ),

                    const SizedBox(height: 12),

                    // Meta row
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        // Release Date
                        _MetaBadge(
                          icon: Icons.date_range,
                          iconColor: AppColors.gold,
                          text: show.displayRating,
                          textColor: AppColors.gold,
                        ),
                        // Platform
                        if (show.status != null)
                          _MetaBadge(
                            icon: Icons.desktop_windows,
                            text: show.status!,
                          ),
                        // Publisher
                        if (show.publisher != null)
                          _MetaBadge(
                            icon: Icons.business,
                            text: show.publisher!,
                          ),
                        // Developer
                        if (show.devaloper != null)
                          _MetaBadge(
                            icon: Icons.code,
                            text: show.devaloper!,
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Action buttons
                    SizedBox(
                      width: double.infinity,
                      child: Obx(() => ElevatedButton.icon(
                            onPressed: controller.toggleFavorite,
                            icon: Icon(
                              controller.isFavorite.value
                                  ? Icons.delete_outline
                                  : Icons.add_circle_outline,
                              size: 22,
                              color: controller.isFavorite.value ? Colors.redAccent : Colors.white,
                            ),
                            label: Text(
                              controller.isFavorite.value
                                  ? 'HAPUS DARI LIBRARY'
                                  : 'DAPATKAN GAME (GRATIS)',
                              style: TextStyle(
                                color: controller.isFavorite.value ? Colors.redAccent : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller.isFavorite.value 
                                  ? AppColors.surface 
                                  : AppColors.primary,
                              minimumSize: const Size(0, 48),
                              side: controller.isFavorite.value
                                  ? const BorderSide(color: Colors.redAccent)
                                  : null,
                            ),
                          )),
                    ),

                    const SizedBox(height: 28),

                    // Genre chips
                    if (show.genres.isNotEmpty) ...[
                      Text(
                        'GENRE',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  letterSpacing: 2,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: show.genres
                            .map((g) => _GenreChip(genre: g))
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Screenshots
                    if (show.screenshots != null && show.screenshots!.isNotEmpty) ...[
                      Text(
                        'SCREENSHOTS',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  letterSpacing: 2,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: show.screenshots!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 12),
                              width: 320,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: CachedNetworkImage(
                                imageUrl: show.screenshots![index],
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Shimmer.fromColors(
                                  baseColor: AppColors.shimmerBase,
                                  highlightColor: AppColors.shimmerHighlight,
                                  child: Container(color: AppColors.surface),
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  color: AppColors.surface,
                                  child: const Icon(Icons.image_not_supported, color: AppColors.textMuted),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Divider
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: 16),

                    // Summary
                    if (show.summary != null && show.summary!.isNotEmpty) ...[
                      Text(
                        'DESKRIPSI',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  letterSpacing: 2,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Html(
                        data: show.summary ?? '',
                        style: {
                          'body': Style(
                            color: AppColors.textSecondary,
                            fontSize: FontSize(14),
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                          'p': Style(
                            color: AppColors.textSecondary,
                            fontSize: FontSize(14),
                            lineHeight: LineHeight(1.6),
                          ),
                          'b': Style(color: AppColors.textPrimary),
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 400, color: AppColors.surface),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 32, width: 220, color: AppColors.surface),
                  const SizedBox(height: 12),
                  Container(
                      height: 16, width: 160, color: AppColors.surface),
                  const SizedBox(height: 24),
                  Container(
                      height: 48, color: AppColors.surface),
                  const SizedBox(height: 16),
                  Container(
                      height: 100, color: AppColors.surface),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(DetailController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Get.back(),
          ),
          const SizedBox(height: 40),
          const Icon(Icons.error_outline, color: AppColors.primary, size: 60),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage.value,
            style: const TextStyle(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String text;
  final Color? textColor;

  const _MetaBadge({
    required this.icon,
    this.iconColor,
    required this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: iconColor ?? AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor ?? AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String genre;
  const _GenreChip({required this.genre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        genre,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
