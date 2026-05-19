// lib/presentation/controllers/auth_controller.dart

import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../data/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    username.value = await _authService.getUsername();
  }

  Future<void> login(String user, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final success = await _authService.login(user, password);
      if (success) {
        username.value = user.trim();
        Get.offAllNamed(AppConstants.routeHome);
      } else {
        errorMessage.value = 'Password Minimal 4 Karakter.';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan. Coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(AppConstants.routeLogin);
  }
}
