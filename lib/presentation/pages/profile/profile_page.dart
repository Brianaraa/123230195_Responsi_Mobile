// lib/presentation/pages/profile/profile_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/favorite_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final FavoriteController favoriteController = Get.find<FavoriteController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Avatar
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Obx(() => Text(
                        authController.username.value.isNotEmpty
                            ? authController.username.value[0].toUpperCase()
                            : 'U',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 40,
                            ),
                      )),
                ),
              ),

              const SizedBox(height: 16),

              // Username
              Obx(() => Text(
                    authController.username.value, // This actually holds the email based on AuthService
                    style: Theme.of(context).textTheme.headlineMedium,
                  )),

              const SizedBox(height: 4),

              Text(
                'Member NaraGame',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 32),

              // Stats card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(() => _StatItem(
                          value:
                              '${favoriteController.favorites.length}',
                          label: 'Library Games',
                          icon: Icons.videogame_asset,
                          color: AppColors.primary,
                        )),
                    _dividerV(),
                    const _StatItem(
                      value: '∞',
                      label: 'Dimainkan',
                      icon: Icons.play_circle_outline,
                      color: AppColors.gold,
                    ),
                    _dividerV(),
                    const _StatItem(
                      value: '★',
                      label: 'Member',
                      icon: Icons.star,
                      color: Colors.amber,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Section: Kesan & Pesan
              _SectionCard(
                title: '💬 KESAN & PESAN',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kesan:',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Praktikum Mobile membuat saya mengerti bagaimana susahnya membuat aplikasi mobile. Saya menjadi paham kenapa teman saya yang devaloper mobile gajinya fantastis seperti Fantastic Beasts. Karena ini juga saya cukup ketergantungan AI, karena memang sesusah itu membuat aplikasi mobile.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pesan:',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Buat saya sendiri tidak banyak, Mas Umar dan Mas Habib sendiri sudah sangat membantu dalam praktikum mobile ini, walaupun saya cukup tidak kompeten dalam pembelajaran mobile ini tetap seru. Selanjutnya saya harap Mas Mas sekalian dapat masuk Surga, dapat menjalani kehidupan yang normal, dapat kerjaan dengan mudah, dan selalu improve untuk keberlanjutan Praktikum lainnya.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                          ),
                    ),
                  ],
                ),
              ),


              const SizedBox(height: 32),

              // Logout button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmLogout(context, authController),
                  icon: const Icon(Icons.logout, color: AppColors.primary),
                  label: const Text(
                    'KELUAR',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dividerV() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.divider,
    );
  }

  void _confirmLogout(BuildContext context, AuthController controller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(
          'Keluar?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Kamu akan keluar dari NaraGame.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 36),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppColors.textPrimary, fontSize: 20),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
