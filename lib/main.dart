// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_pages.dart';
import 'data/models/tv_show_model.dart';
import 'data/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Force portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TvShowAdapter());
  
  try {
    await Hive.openBox<TvShow>(AppConstants.favoriteBox);
  } catch (e) {
    // If there is a schema mismatch (from old TVMaze structure to new FreeToGame structure),
    // delete the old box from disk and open a fresh one.
    await Hive.deleteBoxFromDisk(AppConstants.favoriteBox);
    await Hive.openBox<TvShow>(AppConstants.favoriteBox);
  }

  // Check login status
  final authService = AuthService();
  final isLoggedIn = await authService.isLoggedIn();

  runApp(StreamVaultApp(initialRoute: isLoggedIn
      ? AppConstants.routeHome
      : AppConstants.routeLogin));
}

class StreamVaultApp extends StatelessWidget {
  final String initialRoute;
  const StreamVaultApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.darkTheme,
      initialRoute: initialRoute,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
    );
  }
}
