// lib/core/utils/app_pages.dart

import 'package:get/get.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/detail_controller.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/home/main_page.dart';
import '../../presentation/pages/detail/detail_page.dart';
import '../constants/app_constants.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppConstants.routeLogin,
      page: () => const LoginPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppConstants.routeHome,
      page: () => const MainPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppConstants.routeDetail,
      page: () => const DetailPage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    ),
  ];
}
