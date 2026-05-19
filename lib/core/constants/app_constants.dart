// lib/core/constants/app_constants.dart

class AppConstants {
  // API
  static const String baseUrl = 'https://www.freetogame.com/api';
  static const String showsEndpoint = '/games';
  static const String showDetailEndpoint = '/game?id=';

  // SharedPreferences Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUsername = 'username';

  // Hive Box
  static const String favoriteBox = 'favorites';

  // Routes
  static const String routeLogin = '/login';
  static const String routeHome = '/home';
  static const String routeDetail = '/detail';
  static const String routeFavorite = '/favorite';
  static const String routeProfile = '/profile';

  // App Info
  static const String appName = 'NaraGame';
}
