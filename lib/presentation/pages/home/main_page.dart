// lib/presentation/pages/home/main_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/navigation_controller.dart';
import '../../controllers/favorite_controller.dart';
import 'home_page.dart';
import '../favorite/favorite_page.dart';
import '../profile/profile_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navController =
        Get.put(NavigationController());
    Get.put(FavoriteController());

    final pages = [
      const HomePage(),
      const FavoritePage(),
      const ProfilePage(),
    ];

    return Obx(() => Scaffold(
          body: IndexedStack(
            index: navController.currentIndex.value,
            children: pages,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.divider.withOpacity(0.5),
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: navController.currentIndex.value,
              onTap: navController.changePage,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_books_outlined),
                  activeIcon: Icon(Icons.library_books),
                  label: 'Library',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ));
  }
}
