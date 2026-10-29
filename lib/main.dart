import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/routes.dart';
import 'core/storage_service.dart';
import 'core/theme.dart';
import 'features/articles/models/article_category.dart';
import 'features/articles/providers/article_provider.dart';
import 'features/articles/screens/article_list_screen.dart';
import 'features/articles/screens/home_screen.dart';
import 'features/articles/services/article_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/profile_screen.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            storageService: StorageService(preferences),
            authService: AuthService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ArticleProvider(
            articleService: ArticleService(),
          ),
        ),
      ],
      child: const EduTrackApp(),
    ),
  );
}

class EduTrackApp extends StatelessWidget {
  const EduTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name != AppRoutes.articles) {
          return null;
        }

        final category = settings.arguments;
        if (category is! ArticleCategory) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Kategori tidak ditemukan.')),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => ArticleListScreen(category: category),
        );
      },
    );
  }
}